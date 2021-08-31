// DataSession.prg
// Created by    : fabri
// Creation Date : 8/29/2021 10:08:23 AM
// Created for   : 
// WorkStation   : FABXPS


USING System
USING System.Collections.Generic
USING System.Text

BEGIN NAMESPACE XanthiCommLib

	/// <summary>
    /// The DataSession class.
    /// </summary>
	CLASS DataSession

    PROPERTY FileName AS STRING AUTO
    PROPERTY RealFileName AS STRING AUTO
    PROPERTY Id AS INT AUTO


 
    CONSTRUCTOR()
         RETURN

	END CLASS
END NAMESPACE // XanthiCommLib