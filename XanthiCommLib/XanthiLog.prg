// XanthiLog.prg
// Created by    : fabri
// Creation Date : 8/26/2021 7:05:28 PM
// Created for   : 
// WorkStation   : FABXPS


USING System
USING System.Collections.Generic
USING System.Text
USING System.IO

BEGIN NAMESPACE XanthiCommLib

	/// <summary>
	/// The XanthiLog class.
	/// </summary>
	ABSTRACT CLASS XanthiLog
		
	PUBLIC ABSTRACT METHOD Log( message AS STRING ) AS VOID
		
	PUBLIC ABSTRACT METHOD Clear() AS VOID
		
		ABSTRACT PROPERTY Text AS STRING GET 
		
		OPERATOR+(lhs AS XanthiLog, rhs AS STRING) AS XanthiLog
			lhs:Log(rhs)
			RETURN lhs
			
		END CLASS
		
		
		
		
	/// <summary>
	/// File logger class.
	/// </summary>
	CLASS XanthiFileLogger INHERIT XanthiLog
		
		PROPERTY FileName AS STRING AUTO
		
		CONSTRUCTOR( file AS STRING )
			SELF:fileName := file
			IF File.Exists( file )
				File.Delete( file )
			ENDIF
		
		PUBLIC OVERRIDE METHOD Log( message AS STRING ) AS VOID
			BEGIN USING VAR sw := StreamWriter{ SELF:fileName, TRUE }
				sw:Write(message)
				sw:Close()
			END USING
		RETURN
		
		PUBLIC OVERRIDE METHOD Clear() AS VOID
			IF File.Exists( SELF:fileName )
				File.Delete( SELF:fileName )
			ENDIF
		RETURN
		
		PROPERTY Text AS STRING GET File.ReadAllText( SELF:FileName )
		
	END CLASS
	
	
END NAMESPACE // XanthiCommLib