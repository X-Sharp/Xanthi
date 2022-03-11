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
	CLASS ServerDataSession INHERIT DataSession
		
		
		CONSTRUCTOR( name AS STRING )
			SUPER( name )

			RETURN
		
		PROTECTED NEW STATIC METHOD OnTimer(source AS OBJECT, e AS System.Timers.ElapsedEventArgs) AS VOID
			// Catch the Timer to keep the DataSession alive through Threads


	END CLASS
END NAMESPACE // XanthiCommLib