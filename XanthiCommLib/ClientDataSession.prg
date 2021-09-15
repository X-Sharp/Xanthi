// ClientDataSession.prg
// Created by    : fabri
// Creation Date : 9/9/2021 10:38:20 AM
// Created for   : 
// WorkStation   : FABXPS


USING System
USING System.Collections.Generic
USING System.Text

BEGIN NAMESPACE XanthiCommLib

	/// <summary>
	/// The ClientDataSession class.
	/// </summary>
	CLASS ClientDataSession
		// The IPAddress linked to this DataSession
		PROPERTY IPAddress AS STRING AUTO
		// The wanted FileName
		PROPERTY FileName AS STRING AUTO
		// The real FileName
		PROPERTY RealFileName AS STRING AUTO
		// Session ID
		PROPERTY Id AS INT AUTO
		
		
		
		CONSTRUCTOR()
			RETURN
			
	END CLASS
END NAMESPACE // XanthiCommLib