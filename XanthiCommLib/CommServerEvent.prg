// CommServerEvent.prg
// Created by    : fabri
// Creation Date : 9/13/2021 11:38:32 AM
// Created for   : 
// WorkStation   : FABXPS


USING System
USING System.Collections.Generic
USING System.Text

BEGIN NAMESPACE XanthiCommLib

	PUBLIC DELEGATE  CommServerEventHandler(sender AS System.Object, e AS CommServerEventArgs) AS VOID
	
		/// <summary>
		/// The CommServerEvent class.
	/// </summary>
	CLASS CommServerEventArgs INHERIT EventArgs
	
	PUBLIC PROPERTY Client AS CommServerClient AUTO
	
	CONSTRUCTOR()
	RETURN
	
END CLASS
END NAMESPACE // XanthiCommLib