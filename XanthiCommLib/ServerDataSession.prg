// ServerDataSession.prg
// Created by    : fabri
// Creation Date : 8/29/2021 10:08:23 AM
// Created for   : 
// WorkStation   : FABXPS


USING System
USING System.Collections.Generic
USING System.Text

USING Xsharp.RDD

BEGIN NAMESPACE XanthiCommLib

	/// <summary>
	/// The ServerDataSession class.
	/// </summary>
	CLASS ServerDataSession
		
	STATIC PRIVATE _autoSessionID := 0 AS UINT64
		
		PROPERTY FileName AS STRING AUTO
		//PROPERTY RealFileName AS STRING AUTO
		PROPERTY Id AS UINT64 AUTO
		PROPERTY WorkArea AS INT AUTO
		PROPERTY Works AS Workareas AUTO
		
		CONSTRUCTOR()
			SELF:Id := ++ServerDataSession._autoSessionID
			RETURN
		
	END CLASS
END NAMESPACE // XanthiCommLib