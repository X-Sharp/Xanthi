// CommServerClient_Process.prg
// Created by    : fabri
// Creation Date : 9/16/2021 10:37:08 AM
// Created for   : 
// WorkStation   : FABXPS


USING System.Collections.Generic
USING System.Net
USING System.Net.Sockets
USING System.Text
USING System.Threading

USING XanthiCommLib
USING XSharp.RDD
USING XSharp.RDD.Support
USING Newtonsoft.Json

USING XanthiRDD


BEGIN NAMESPACE XanthiServerTest

	/// <summary>
	/// The ServerProcess class.
	/// This is where we will handle the message
	/// </summary>
	CLASS ServerProcess
		
		PUBLIC METHOD OnMessageProcess(sender AS System.Object, e AS CommClientMessageArgs) AS VOID
			LOCAL reply AS Message
			LOCAL msg AS Message
			LOCAL server AS CommServer
			LOCAL dataSession AS ServerDataSession
			// Default Reply
			reply := Message{}
			reply:Code := CodeValue.NotImplemented
			//
			msg := e:Message
			server := e:Client:Server
			//
			dataSession := server:GetDataSession( msg:SessionID )
			IF dataSession != NULL 
					IF msg.Command == CommandValue.Open
							// Already open for this SessionID
						reply:Code := CodeValue.Forbidden
					ELSE
						reply:SessionID := msg:SessionID
						SWITCH msg:Command
							
							CASE CommandValue.Close
								reply.Command := CommandValue.Close
								// Closing file
								DbCloseArea( dataSession:WorkArea) 
								// 
								server:DelDataSession( msg:SessionID )
								reply:Code := CodeValue.Ok
							CASE CommandValue.DbStruct
								reply:Command := CommandValue.DbStruct
								// Return DbStruct of file
								LOCAL oRdd AS IRdd
								VAR Workareas := dataSession:Works
								oRdd := Workareas:GetRDD((DWORD)dataSession:WorkArea)
								VAR fieldList  := GetDbStruct( oRdd )
								reply.Payload := JsonConvert.SerializeObject( fieldList )
								// 
								reply:Code := CodeValue.Ok
							CASE CommandValue.GetState
								reply:Command := CommandValue.GetState
								// Return DbStruct of file
								LOCAL oRdd AS IRdd
								VAR Workareas := dataSession:Works
								oRdd := Workareas:GetRDD((DWORD)dataSession:WorkArea)
								VAR states := List<STRING>{}
								states:Add(oRDD:BoF:ToString())
								states:Add(oRDD:EoF:ToString())
								states:Add(oRDD:Found:ToString())
								states:Add(oRDD:Recno:ToString())
								states:Add(oRDD:Reccount:ToString())
								// Todo Would be better to have an Object to store State, and SETs
								reply.Payload := JsonConvert.SerializeObject( states )
								// 
								reply:Code := CodeValue.Ok
							CASE CommandValue.Recno
								reply:Command := CommandValue.Recno
								// Return DbStruct of file
								LOCAL oRdd AS IRdd
								VAR Workareas := dataSession:Works
								oRdd := Workareas:GetRDD((DWORD)dataSession:WorkArea)
								reply.Payload := oRdd:RecNo:ToString()
								// 
								reply:Code := CodeValue.Ok
							CASE CommandValue.Reccount
								// Return DbStruct of file
								LOCAL oRdd AS IRdd
								VAR Workareas := dataSession:Works
								oRdd := Workareas:GetRDD((DWORD)dataSession:WorkArea)
								reply.Payload := oRdd:Reccount:ToString()
								// 
								reply:Code := CodeValue.Ok
							CASE CommandValue.GoTo
								reply:Command := CommandValue.GoTo
								// Return DbStruct of file
								LOCAL oRdd AS IRdd
								VAR Workareas := dataSession:Works
								oRdd := Workareas:GetRDD((DWORD)dataSession:WorkArea)
								IF oRdd:Goto( msg:Code )
										reply.Payload := oRdd:RecNo:ToString()
									reply:Code := CodeValue.Ok
								ELSE
									reply:Code := CodeValue.NotFound
								ENDIF
							CASE CommandValue.GoTop
								reply:Command := CommandValue.GoTop
								// Return DbStruct of file
								LOCAL oRdd AS IRdd
								VAR Workareas := dataSession:Works
								oRdd := Workareas:GetRDD((DWORD)dataSession:WorkArea)
								IF oRdd:GoTop()
										reply.Payload := oRdd:RecNo:ToString()
									reply:Code := CodeValue.Ok
								ELSE
									reply:Code := CodeValue.NotFound
								ENDIF
							CASE CommandValue.GoBottom
								reply:Command := CommandValue.GoBottom
								// Return DbStruct of file
								LOCAL oRdd AS IRdd
								VAR Workareas := dataSession:Works
								oRdd := Workareas:GetRDD((DWORD)dataSession:WorkArea)
								IF oRdd:GoBottom()
										reply.Payload := oRdd:RecNo:ToString()
									reply:Code := CodeValue.Ok
								ELSE
									reply:Code := CodeValue.NotFound
								ENDIF
							CASE CommandValue.Skip
								// Return DbStruct of file
								LOCAL oRdd AS IRdd
								VAR Workareas := dataSession:Works
								oRdd := Workareas:GetRDD((DWORD)dataSession:WorkArea)
								IF oRdd:Skip( msg:Code )
										reply.Payload := oRdd:RecNo:ToString()
									reply:Code := CodeValue.Ok
								ELSE
									reply:Code := CodeValue.NotFound
								ENDIF
							CASE CommandValue.FieldGet
								// Return DbStruct of file
								LOCAL oRdd AS IRdd
								VAR Workareas := dataSession:Works
								oRdd := Workareas:GetRDD((DWORD)dataSession:WorkArea)
								TRY
										VAR retValue := oRDD:GetValue( msg:Code )
										reply.Payload := JsonConvert.SerializeObject( retValue )
									reply:Code := CodeValue.Ok
								CATCH
									reply:Code := CodeValue.NotFound
								END TRY
							CASE CommandValue.None
								reply:Command := CommandValue.None
								reply:Code := CodeValue.Ok
							OTHERWISE
								reply:Code := CodeValue.NotImplemented
						END SWITCH
				ENDIF
			ELSE
				IF msg:Command == CommandValue.Open
					//
					reply.Command := CommandValue.Open
					// Todo : Should we Map the FileName to a specific Area on the Server ?
					// 
					IF String.IsNullOrEmpty(msg.Payload) .OR. !System.IO.File.Exists(msg.PayLoad)
						reply:Code := CodeValue.NotFound
					ELSE
						// Let's make it
						IF DbUseArea( TRUE, "DBFCDX", msg.PayLoad )
							// 
							dataSession := ServerDataSession{}
							dataSession:FileName := msg.PayLoad
							dataSession:WorkArea := (INT)DbSelect()
							dataSession:Works := RuntimeState:WorkAreas
							server:AddDataSession( dataSession )
							reply:Code := CodeValue.Ok
							reply:SessionID := dataSession:Id
							// And return the DbStruct 
							LOCAL oRdd AS IRdd
							VAR Workareas := dataSession:Works
							oRdd := Workareas:GetRDD((DWORD)dataSession:WorkArea)
							VAR fieldList  := GetDbStruct( oRdd )
							reply.Payload := JsonConvert.SerializeObject( fieldList )
						ENDIF
					ENDIF
				ENDIF
			ENDIF
			//
			e:Message := reply
			//
		RETURN 
		
	 PRIVATE METHOD GetDbStruct( oRDD AS IRDD ) AS List<XRddFieldInfo>
		VAR _fieldList  := List<XRddFieldInfo>{}
        LOCAL f AS INT
        LOCAL fieldCount := oRDD:FieldCount AS LONG
        FOR f:=1 UPTO fieldCount
			LOCAL oInfo    AS XRddFieldInfo
			oInfo := XRddFieldInfo{ oRDD:GetField(f) }
            _fieldList:Add(oInfo)
        NEXT
		RETURN _fieldList
		
		
	END CLASS
	
END NAMESPACE