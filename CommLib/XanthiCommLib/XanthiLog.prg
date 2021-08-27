﻿// XanthiLog.prg
// Created by    : fabri
// Creation Date : 8/26/2021 7:05:28 PM
// Created for   : 
// WorkStation   : FABXPS


USING System
USING System.Collections.Generic
USING System.Text
USING System.IO
USING NLog

BEGIN NAMESPACE XanthiCommLib

	PUBLIC STATIC CLASS XanthiLog
		
	PRIVATE STATIC xanthiLog := NULL AS NLog.Logger
		
		PUBLIC STATIC PROPERTY Logger AS NLog.Logger
			GET
				IF ( xanthiLog == NULL )
					// Create the Default Config
					VAR config := NLog.Config.LoggingConfiguration{}
					// Targets where to log to: File and Console
					VAR logfile := NLog.Targets.FileTarget{"logfile"} { FileName = "XanthiLogger.log" }
					// Rules for mapping loggers to targets            
					config:AddRule(LogLevel.Trace, LogLevel.Fatal, logfile)
					// Apply config           
					NLog.LogManager:Configuration := config
					//
					XanthiLog.xanthiLog := NLog.LogManager.GetCurrentClassLogger()
				ENDIF
				RETURN XanthiLog.xanthiLog
			END GET
			
			SET 
				XanthiLog.xanthiLog = VALUE
			END SET
			
		END PROPERTY 
		
	END CLASS
	
	
END NAMESPACE // XanthiCommLib