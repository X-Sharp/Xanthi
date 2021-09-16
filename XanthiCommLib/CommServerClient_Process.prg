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


BEGIN NAMESPACE XanthiCommLib

	/// <summary>
	/// The CommServerClient class.
	/// This is the client communication Class, used on the Server-Side
	/// </summary>
	PARTIAL CLASS CommServerClient
	
		PRIVATE METHOD ProcessMessage( msg AS Message ) AS Message
			XanthiLog.Logger:Error("CommServerClient : Processing Command, " + msg:Command:ToString())
		RETURN msg
		
		
	END CLASS
	
END NAMESPACE