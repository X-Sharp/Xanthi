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
USING Newtonsoft.Json


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
			// Default Reply
			reply := Message{}
			reply:Code := CodeValue.NotImplemented
			//
			msg := e:Message
			server := e:Client:Server
			//
			SWITCH msg:Command
				CASE CommandValue.Open
					//
					LOCAL dataSession AS ServerDataSession
					reply.Command := CommandValue.Open
					// What DataSession Should we Close
					dataSession := server:GetDataSession( msg:SessionID )
					IF dataSession != NULL
							// Already open for this SessionID
						reply:Code := CodeValue.Forbidden
					ELSE
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
							ENDIF
						ENDIF
					ENDIF
				CASE CommandValue.Close
					LOCAL dataSession AS ServerDataSession
					reply.Command := CommandValue.Close
					// What DataSession Should we Close
					dataSession := server:GetDataSession( msg:SessionID )
					IF dataSession != NULL
							// Closing file
							DbCloseArea( dataSession:WorkArea) 
							// 
							server:DelDataSession( msg:SessionID )
							reply:Code := CodeValue.Ok
						reply:SessionID := msg:SessionID
					ELSE
						reply:Code := CodeValue.NotFound
					ENDIF
				CASE CommandValue.DbStruct
										LOCAL dataSession AS ServerDataSession
					reply:Command := CommandValue.DbStruct
					// What DataSession Should we Close
					dataSession := server:GetDataSession( msg:SessionID )
					IF dataSession != NULL
							// Return DbStruct of file
							LOCAL oRdd AS IRdd
							VAR Workareas := dataSession:Works
							oRdd := Workareas:GetRDD((DWORD)dataSession:WorkArea)
							VAR _fieldList  := GetDbStruct( oRdd )
							reply.Payload := JsonConvert.SerializeObject( _fieldList )
							// 
							reply:Code := CodeValue.Ok
						reply:SessionID := msg:SessionID
					ELSE
						reply:Code := CodeValue.NotFound
					ENDIF
				CASE CommandValue.None
					reply:Command := CommandValue.None
					reply:Code := CodeValue.Ok
			END SWITCH
			//
			e:Message := reply
			//
		RETURN 

	 PRIVATE METHOD GetDbStruct( oRDD AS IRDD ) AS List<DbField>
		VAR _fieldList  := List<DbField>{}
        LOCAL f AS INT
        LOCAL fieldCount := oRDD:FieldCount AS LONG
        FOR f:=1 UPTO fieldCount
            LOCAL oInfo    AS DbColumnInfo
            oInfo  := (DbColumnInfo) oRDD:FieldInfo(f, DBS_COLUMNINFO, NULL)
            _fieldList:Add(DbField{oInfo})
        NEXT
		RETURN _fieldList
		
		
	END CLASS
	
END NAMESPACE