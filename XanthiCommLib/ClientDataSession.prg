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
	/// The ClientDataSession class. UnUsed Currently
	/// </summary>
	CLASS ClientDataSession
		/// <summary>
		/// The IPAddress linked to this DataSession
		/// </summary>
		/// <value></value>
		PROPERTY IPAddress AS STRING AUTO
		/// <summary>
		/// The wanted FileName
		/// </summary>
		/// <value></value>
		PROPERTY FileName AS STRING AUTO
		/// <summary>
		/// The real FileName
		/// </summary>
		/// <value></value>
		PROPERTY RealFileName AS STRING AUTO
		/// <summary>
		/// Session ID
		/// </summary>
		/// <value></value>
		PROPERTY Id AS INT AUTO
		//
		
		
		
		CONSTRUCTOR()
			RETURN
			
	END CLASS
END NAMESPACE // XanthiCommLib