// XanthiLog.prg
// Created by    : fabri
// Creation Date : 8/26/2021 7:05:28 PM
// Created for   : 
// WorkStation   : FABXPS


USING System
USING System.Collections.Generic
USING System.Text
USING System.IO
USING Serilog
USING Serilog.Core

BEGIN NAMESPACE XanthiCommLib

	PUBLIC STATIC CLASS XanthiLog
		
	PRIVATE STATIC xanthiLogger := NULL AS ILogger
		
	PRIVATE STATIC logFile := NULL AS STRING
		
		PUBLIC STATIC PROPERTY Logger AS ILogger
			GET
				IF ( xanthiLogger == NULL )
					// Create the Default Config
					VAR config := LoggerConfiguration{}
					// Set the Default values
					config:MinimumLevel:Debug()
					config:WriteTo:File( XanthiLog.FileName )
					// But allow to read settings from 
					// TODO : Strangely this logConfig doesn't work
					config:ReadFrom:AppSettings( NULL, "xanthilog.config" )
					//
					xanthiLogger := config:CreateLogger()
				ENDIF
				RETURN XanthiLog.xanthiLogger
			END GET
			
			SET 
				XanthiLog.xanthiLogger := VALUE
			END SET
			
		END PROPERTY 
		
		PUBLIC STATIC PROPERTY FileName AS STRING
			GET
				IF ( logFile == NULL )
					logFile := "XanthiLogger.log"
				ENDIF
				RETURN logFile
			END GET
			
			SET
				logFile := VALUE
			END SET
		END PROPERTY
		
		
	END CLASS
	
	
END NAMESPACE // XanthiCommLib