// XanthiConnection.prg
// Created by    : fabri
// Creation Date : 9/25/2021 12:32:23 PM
// Created for   : 
// WorkStation   : FABXPS

/*


USING System
USING System.Collections.Generic
USING System.Text
USING XanthiCommLib
USING XSharp.RDD
USING XSharp.Rdd.Support
USING Newtonsoft.Json


BEGIN NAMESPACE XanthiRDD

	/// <summary>
	/// The XanthiConnection class.
	/// </summary>
	CLASS XanthiConnection
	PRIVATE _client AS CommClient
		// The Connection on Client side is linked to the SessionID on Server Side
		// Good Idea ?
	PRIVATE _sessionID AS INT
		
	INTERNAL _fields AS List<XRddFieldInfo>

		PROPERTY TimeOut AS INT GET SELF:Server:ReadTimeOut
		PROPERTY Server AS ServerInfo AUTO
		
		CONSTRUCTOR( server AS ServerInfo )
			SELF:_client := CommClient{ server:Address, server:Port  }
			SELF:_fields := List<XRddFieldInfo>{}
			SELF:_sessionID := 0
			SELF:Server := server
			RETURN
		
		
		METHOD OpenTable( fileName AS STRING ) AS LOGIC
			LOCAL msg AS Message
			LOCAL isOk := FALSE AS LOGIC
			// Send Message
			msg := Message{}
			msg:Command := CommandValue.Open
			msg:PayLoad := fileName
			//
			IF SELF:_client:Connect()
				SELF:_client:WriteMessage( msg )
				msg := SELF:_client:WaitReply( SELF:TimeOut )
				SELF:_client:Close()
				IF msg != NULL
					// We have a reply
					IF msg:Code == CodeValue.Ok
						SELF:_sessionID := (INT)msg:SessionID
						SELF:_fields := JsonConvert.DeserializeObject<List<XRddFieldInfo>>( msg:Payload )
						isOk := TRUE
					ENDIF
				ENDIF
			ENDIF
			RETURN isOk
		
		METHOD GoTop( ) AS LOGIC
			LOCAL msg AS Message
			LOCAL isOk := FALSE AS LOGIC
			IF SELF:_sessionID == 0
				RETURN FALSE
			ENDIF
			// Send Message
			msg := Message{}
			msg:SessionID := (UINT64)SELF:_sessionID
			msg:Command := CommandValue.GoTop
			//
			IF SELF:_client:Connect()
				SELF:_client:WriteMessage( msg )
				msg := SELF:_client:WaitReply( SELF:TimeOut )
				SELF:_client:Close()
				IF msg != NULL
					// We have a reply
					IF msg:Code == CodeValue.Ok
						isOk := TRUE
					ENDIF
				ENDIF
			ENDIF
			RETURN isOk
		
		METHOD GoBottom( ) AS LOGIC
			LOCAL msg AS Message
			LOCAL isOk := FALSE AS LOGIC
			IF SELF:_sessionID == 0
				RETURN FALSE
			ENDIF
			// Send Message
			msg := Message{}
			msg:SessionID := (UINT64)SELF:_sessionID
			msg:Command := CommandValue.GoBottom
			//
			IF SELF:_client:Connect()
				SELF:_client:WriteMessage( msg )
				msg := SELF:_client:WaitReply( SELF:TimeOut )
				SELF:_client:Close()
				IF msg != NULL
					// We have a reply
					IF msg:Code == CodeValue.Ok
						isOk := TRUE
					ENDIF
				ENDIF
			ENDIF
			RETURN isOk
		
		METHOD GoTo( lRec AS INT ) AS LOGIC
			LOCAL msg AS Message
			LOCAL isOk := FALSE AS LOGIC
			IF SELF:_sessionID == 0
				RETURN FALSE
			ENDIF
			// Send Message
			msg := Message{}
			msg:SessionID := (UINT64)SELF:_sessionID
			msg:Command := CommandValue.GoTo
			msg:Code := (CodeValue)lRec
			//
			IF SELF:_client:Connect()
				SELF:_client:WriteMessage( msg )
				msg := SELF:_client:WaitReply( SELF:TimeOut )
				SELF:_client:Close()
				IF msg != NULL
					// We have a reply
					IF msg:Code == CodeValue.Ok
						isOk := TRUE
					ENDIF
				ENDIF
			ENDIF
			RETURN isOk
		
		METHOD Skip( lCount AS INT ) AS LOGIC
			LOCAL msg AS Message
			LOCAL isOk := FALSE AS LOGIC
			IF SELF:_sessionID == 0
				RETURN FALSE
			ENDIF
			// Send Message
			msg := Message{}
			msg:SessionID := (UINT64)SELF:_sessionID
			msg:Command := CommandValue.Skip
			msg:Code := (CodeValue)lCount
			//
			IF SELF:_client:Connect()
				SELF:_client:WriteMessage( msg )
				msg := SELF:_client:WaitReply( SELF:TimeOut )
				SELF:_client:Close()
				IF msg != NULL
					// We have a reply
					IF msg:Code == CodeValue.Ok
						isOk := TRUE
					ENDIF
				ENDIF
			ENDIF
			RETURN isOk
		
		
		METHOD Close() AS LOGIC
			LOCAL msg AS Message
			LOCAL isOk := FALSE AS LOGIC
			IF SELF:_sessionID == 0
				RETURN FALSE
			ENDIF
			// Send Message
			msg := Message{}
			msg:SessionID := (UINT64)SELF:_sessionID
			msg:Command := CommandValue.Close
			//
			IF SELF:_client:Connect()
				SELF:_client:WriteMessage( msg )
				msg := SELF:_client:WaitReply( SELF:TimeOut )
				SELF:_client:Close()
				IF msg != NULL
					// We have a reply
					IF msg:Code == CodeValue.Ok
						isOk := TRUE
					ENDIF
				ENDIF
			ENDIF
			RETURN isOk
		
		METHOD FieldGet( nFldPos AS INT ) AS OBJECT
			LOCAL msg AS Message
			LOCAL data := NULL AS OBJECT
			IF SELF:_sessionID == 0
				RETURN data
			ENDIF
			// Send Message
			msg := Message{}
			msg:SessionID := (UINT64)SELF:_sessionID
			msg:Command := CommandValue.FieldGet
			msg:Code := (CodeValue)nFldPos
			//
			IF SELF:_client:Connect()
				SELF:_client:WriteMessage( msg )
				msg := SELF:_client:WaitReply( SELF:TimeOut )
				SELF:_client:Close()
				IF msg != NULL
					// We have a reply
					IF msg:Code == CodeValue.Ok
						data := JsonConvert.DeserializeObject<OBJECT>( msg:Payload ) 
					ENDIF
				ENDIF
			ENDIF
			RETURN data
		
	END CLASS
END NAMESPACE // XanthiClientTest_Rdd

*/