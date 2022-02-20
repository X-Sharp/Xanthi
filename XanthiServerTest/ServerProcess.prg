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
			// The Message we will handle
			msg := e:Message
			// The Comm Server
			server := e:Client:Server
			// Default Reply
			reply := Message{}
			reply.Command := msg:Command
			reply:Code := CodeValue.NotImplemented
			//
			dataSession := server:GetDataSession( msg:SessionID )
			//
			IF ( msg:Command >= ConnectionCommand.OpenSession ) .AND. ( msg:Command <= ConnectionCommand.CheckSession )
				reply := SELF:ProcessConnectionCommand( dataSession, e )
			ELSE
				IF dataSession != NULL 
					// Indicate what Session we processed
					reply:SessionID := msg:SessionID
					SWITCH msg:Command
					CASE CommandValue.Open
						//
						LOCAL info := JsonConvert.DeserializeObject<DbOpenInfo>( msg:Payload ) AS DbOpenInfo
						IF DbUseArea( TRUE, "DBFCDX", info:FullName, info:Alias, info:Shared, info:ReadOnly )
							//
							VAR currentRDDState := SELF:GetCurrentRDDState(dataSession)
							reply:Code := CodeValue.Ok
							reply:RDDState := JsonConvert.SerializeObject( currentRDDState )
						ENDIF
					CASE CommandValue.Close
						reply.Command := CommandValue.Close
						// Closing file
						DbCloseArea( dataSession:WorkArea) 
						// 
						server:DelDataSession( msg:SessionID )
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
			ENDIF
			//
			e:Message := reply
			//
			RETURN 
		
			//		PRIVATE METHOD GetDbStruct( oRDD AS IRDD ) AS List<XRddFieldInfo>
			//			VAR _fieldList  := List<XRddFieldInfo>{}
			//			LOCAL f AS INT
			//			LOCAL fieldCount := oRDD:FieldCount AS LONG
			//			FOR f:=1 UPTO fieldCount
			//				LOCAL oInfo    AS XRddFieldInfo
			//				oInfo := XRddFieldInfo{ oRDD:GetField(f) }
			//				_fieldList:Add(oInfo)
			//			NEXT
			//		RETURN _fieldList
		
		PRIVATE METHOD ProcessConnectionCommand( dataSession AS ServerDataSession, e AS CommClientMessageArgs ) AS Message
			LOCAL msg AS Message
			LOCAL server AS CommServer
			LOCAL reply AS Message
			// Default Reply
			reply := Message{}
			reply:Code := CodeValue.NotImplemented
			// The Message we will handle
			msg := e:Message
			// The Comm Server
			server := e:Client:Server
			//
			SWITCH msg.Command
			CASE ConnectionCommand.OpenSession
				IF dataSession != NULL
					// DataSession is already open for this SessionID
					reply:Code := CodeValue.Forbidden
				ELSE
					//
					//VAR cargo := Tuple<STRING,STRING,STRING>{ SELF:Info:User, SELF:Info:Password, SELF:Info:Driver}
					TRY
						VAR cargo := Jsonconvert.DeserializeObject<Tuple<STRING,STRING>>( msg:Payload )
						IF ( cargo:Item1 == "Fabrice" .AND. cargo.Item2 == "XSharp"  )
							dataSession := ServerDataSession{}
							dataSession:WorkArea := (INT)DbSelect()
							dataSession:Works := RuntimeState:WorkAreas
							server:AddDataSession( dataSession )
							//
							reply:Code := CodeValue.Ok
							reply:SessionID := dataSession:Id
						ENDIF
					END TRY
				ENDIF
			CASE ConnectionCommand.CloseSession
				reply:Code := CodeValue.Forbidden
			CASE ConnectionCommand.CheckSession
				reply:Code := CodeValue.Forbidden
			END SWITCH
			//
			RETURN reply
	
		PRIVATE METHOD GetCurrentRDDState(dataSession AS ServerDataSession) AS XanthiRDDState
			LOCAL state AS XanthiRDDState
			LOCAL oRdd AS IRdd
			//
			oRdd := dataSession:Works:GetRDD( (DWORD)dataSession:WorkArea )
			//
			state := XanthiRDDState{}
			state:Alias :=		oRdd:Alias
			state:Area :=		oRdd:Area
			state:BoF :=		oRdd:Bof
			state:Deleted :=	oRdd:Deleted
			state:Driver :=		oRdd:Driver
			state:EoF :=		oRdd:Eof
			state:Exclusive :=	oRdd:Exclusive
			state:FieldCount :=	oRdd:FieldCount
			state:FilterText := oRdd:FilterText
			state:Found :=		oRdd:Found
			state:RecCount :=	oRdd:RecCount
			state:RecId :=		oRdd:RecId
			state:RecNo :=		oRdd:RecNo
			state:Shared :=		oRdd:Shared
			//
			RETURN state
	END CLASS
	
END NAMESPACE