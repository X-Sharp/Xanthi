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

USING XanthiTest

BEGIN NAMESPACE XanthiServerTest_Raw

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
					// Set the DataSession for all commands
					RuntimeState.SetDataSession( dataSession )
					VAR oRdd := dataSession:CurrentWorkarea
					// Indicate what Session we processed
					reply:SessionID := msg:SessionID
					reply:Command := msg:Command
					//
					SWITCH msg:Command
						CASE CommandValue.Open
						CASE CommandValue.Close
						CASE CommandValue.GoTo
						CASE CommandValue.GoTop
						CASE CommandValue.GoBottom
						CASE CommandValue.Skip
						CASE CommandValue.GetValue
						CASE CommandValue.FieldName
							reply:Code := CodeValue.Ok
						CASE CommandValue.None
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
						dataSession := ServerDataSession{ "DataSession opened by " + e:Client:IPAddress }
						server:AddDataSession( dataSession )
						//
						reply:Code := CodeValue.Ok
						reply:SessionID := dataSession:Id
					ENDIF
				CASE ConnectionCommand.CloseSession
					IF dataSession == NULL
						// DataSession unknown
						reply:Code := CodeValue.Forbidden
					ELSE
						//
						XSharp.RDD.DataSession.Close( dataSession )
						server:RemoveDataSession( dataSession:ID )
						//
						reply:Code := CodeValue.Ok
						reply:SessionID := 0
					ENDIF
				CASE ConnectionCommand.CheckSession
					reply:Code := CodeValue.Forbidden
			END SWITCH
			//
			RETURN reply
	
	END CLASS
	
END NAMESPACE