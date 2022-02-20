// Connection.prg
// Created by    : fabri
// Creation Date : 2/19/2022 2:36:18 PM
// Created for   : 
// WorkStation   : FABXPS


USING System
USING System.Collections.Generic
USING System.Text
USING NewtonSoft.Json

BEGIN NAMESPACE XanthiCommLib

	ENUM ConnectionCommand
		MEMBER OpenSession
		MEMBER CloseSession
		MEMBER CheckSession
	END ENUM

	/// <summary>
	/// The Connection class.
	/// </summary>
	CLASS Connection
		//
		PRIVATE _client AS CommClient

		PROPERTY TimeOut AS INT GET SELF:Info:ReadTimeOut

		PROPERTY Info AS ServerInfo AUTO

		PROPERTY Client AS CommClient GET SELF:_client

		// The Connection on Client side is linked to the SessionID on Server Side
		// Good Idea ?
		PROPERTY SessionID AS UINT64 AUTO GET PRIVATE SET

		CONSTRUCTOR( server AS ServerInfo )
			SELF:_client := CommClient{ server:Address, server:Port  }
			SELF:SessionID := 0
			SELF:Info := server
			RETURN
		
		PUBLIC METHOD OpenSession() AS LOGIC
			LOCAL msg AS Message
			LOCAL isOk := FALSE AS LOGIC
			// Session already open ?
			IF SELF:SessionID != 0
				RETURN TRUE
			ENDIF
			VAR cargo := Tuple<STRING,STRING>{ SELF:Info:User, SELF:Info:Password}
			// Send Message
			msg := Message{}
			msg:SessionID := 0
			msg:Command := (INT)ConnectionCommand.OpenSession
			msg:PayLoad := JsonConvert.SerializeObject( cargo )
			//
			IF SELF:Client:Connect()
				SELF:Client:WriteMessage( msg )
				msg := SELF:Client:WaitReply( SELF:TimeOut )
				SELF:Client:Close()
				IF msg != NULL
					// We have a reply
					IF msg:Code == CodeValue.Ok
						isOk := TRUE
						// we have the "new" Session ID
						SELF:SessionID := msg:SessionID
					ENDIF
				ENDIF
			ENDIF
			RETURN isOk

		PUBLIC METHOD CloseSession() AS LOGIC
			LOCAL msg AS Message
			LOCAL isOk := FALSE AS LOGIC
			// Session already open ?
			IF SELF:SessionID != 0
				VAR cargo := Tuple<STRING,STRING>{ SELF:Info:User, SELF:Info:Password }
				// Send Message
				msg := Message{}
				msg:SessionID := SELF:SessionID
				msg:Command := (INT)ConnectionCommand.CloseSession
				msg:PayLoad := JsonConvert.SerializeObject( cargo )
				//
				IF SELF:Client:Connect()
					SELF:Client:WriteMessage( msg )
					msg := SELF:Client:WaitReply( SELF:TimeOut )
					SELF:Client:Close()
					IF msg != NULL
						// We have a reply
						IF msg:Code == CodeValue.Ok
							isOk := TRUE
							// Session is closed, forget Session ID
							SELF:SessionID := 0
						ENDIF
					ENDIF
				ENDIF
			ENDIF
			RETURN isOk

		PUBLIC METHOD CheckSession() AS LOGIC
			LOCAL msg AS Message
			LOCAL isOk := FALSE AS LOGIC
			// Session already open ?
			IF SELF:SessionID != 0
				VAR cargo := Tuple<STRING,STRING>{ SELF:Info:User, SELF:Info:Password }
				// Send Message
				msg := Message{}
				msg:SessionID := SELF:SessionID
				msg:Command := (INT)ConnectionCommand.CheckSession
				msg:PayLoad := JsonConvert.SerializeObject( cargo )
				//
				IF SELF:Client:Connect()
					SELF:Client:WriteMessage( msg )
					msg := SELF:Client:WaitReply( SELF:TimeOut )
					SELF:Client:Close()
					IF msg != NULL
						// We have a reply
						IF msg:Code == CodeValue.Ok
							isOk := TRUE
						ENDIF
					ENDIF
				ENDIF
			ENDIF
			RETURN isOk



	END CLASS
END NAMESPACE // XanthiCommLib