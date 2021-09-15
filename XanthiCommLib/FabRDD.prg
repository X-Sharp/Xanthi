// FabRDD.prg
// Created by    : fabri
// Creation Date : 9/9/2021 10:34:11 AM
// Created for   : 
// WorkStation   : FABXPS


USING System
USING System.Collections.Generic
USING System.Text
USING XanthiCommLib

BEGIN NAMESPACE XanthiCommLib

	/// <summary>
	/// The FabRDD class.
	/// </summary>
	CLASS FabRDD
		
	PRIVATE client AS CommClient
	PRIVATE _lastMessage AS Message

	PROPERTY LastMessage AS Message => _lastMessage
		
		CONSTRUCTOR( ServerIP AS STRING )
			client := CommClient{ ServerIP, (LONG)ServerInfo.Port  }
			RETURN
		
		METHOD Use( fileName AS STRING ) AS LOGIC
			LOCAL msg AS Message
			LOCAL isOk := FALSE AS LOGIC
			//
			msg := Message{}
			msg:Command := CommandValue.Open
			msg:PayLoad := fileName
			//
			IF client:Connect()
				client:WriteMessage( msg )
				msg := client:WaitReply()
				client:Close()
				IF msg != NULL
					isOk := TRUE
				ENDIF
			ENDIF
			RETURN isOk
		
		METHOD Close( workarea AS INT ) AS LOGIC
			RETURN FALSE
		
		METHOD GoTop( workarea AS INT ) AS LOGIC
			RETURN FALSE
		
		METHOD GoBottom( workarea AS INT ) AS LOGIC
			RETURN FALSE
			
		METHOD Skip( workarea AS INT, skipMove AS INT ) AS LOGIC
			RETURN FALSE
			
		METHOD FieldGet( workarea AS INT, nFied AS INT ) AS LOGIC
			RETURN FALSE
			
		METHOD GetStruct( workarea AS INT ) AS LOGIC
			RETURN FALSE
			
			
	END CLASS
END NAMESPACE // XanthiCommLib