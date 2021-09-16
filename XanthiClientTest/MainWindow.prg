USING System
USING System.Collections.Generic
USING System.ComponentModel
USING System.Data
USING System.Drawing
USING System.Linq

USING System.Text
USING System.Threading.Tasks

USING System.Windows.Forms
USING XanthiCommLib

BEGIN NAMESPACE XanthiClientTest

	PUBLIC PARTIAL CLASS MainWindow ;
		INHERIT System.Windows.Forms.Form
		
		PUBLIC CONSTRUCTOR()   STRICT//MainWindow
			InitializeComponent()
		RETURN
		
		PRIVATE METHOD buttonSend_Click(sender AS System.Object, e AS System.EventArgs) AS VOID STRICT
			LOCAL msg AS XanthiCommLib.Message
			LOCAL number AS INT
			//
			msg := XanthiCommLib.Message{}
			int32.TryParse( SELF:tbCode:Text, OUT number )
			msg:Code := number
			int32.TryParse(SELF:tbCommand:Text, OUT number)
			msg:Command := number
			msg:PayLoad := SELF:tbPayLoad:Text
			//
			IF SendMessage( msg, (STRING) SELF:comboIPList:SelectedItem, (INT)SELF:portNumber:Value )
				SELF:statusLabel:Text := ""
			ELSE
				SELF:statusLabel:ForeColor := Color.Red
				SELF:statusLabel:Text := "Unable to connect to " + ((STRING) SELF:comboIPList:SelectedItem) + ":" + ((INT)SELF:portNumber:Value):ToString()
		ENDIF
		
		PRIVATE METHOD SendMessage( msg AS XanthiCommLib.Message, ip AS STRING, port AS INT ) AS LOGIC STRICT
			
			//
			VAR client := CommClient{ ip,port }
			IF client:Connect()
				client:WriteMessage( msg )
				msg := client:WaitReply()
				IF msg != NULL
					// Fill the Reply area
					SELF:tbCodeReply:Text := msg:Code:ToString()
					SELF:tbCommandReply:Text := msg:Command:ToString()
					SELF:tbPayloadReply:Text := msg:PayLoad
				ENDIF
				client:Close()
				RETURN TRUE
			ENDIF
		RETURN FALSE
		
		
		PRIVATE METHOD MainWindow_Load(sender AS System.Object, e AS System.EventArgs) AS VOID STRICT
			// Fill comboIP
			SELF:comboIPList:Items:AddRange( CommTools.RetrieveAllIP():ToArray() )
			SELF:comboIPList:SelectedIndex := 0
			// Port number
			SELF:portNumber:Value := 12345
			//
			SELF:statusLabel:Text := ""
		RETURN
		PRIVATE METHOD buttonMultiSend_Click(sender AS System.Object, e AS System.EventArgs) AS VOID STRICT
			LOCAL msg AS XanthiCommLib.Message
			LOCAL number AS INT
			LOCAL howMany AS INT
			//
			int32.TryParse( SELF:tbMulti:Text, OUT howMany )
			IF howMany > 1
				msg := XanthiCommLib.Message{}
				int32.TryParse( SELF:tbCode:Text, OUT number )
				msg:Code := number
				int32.TryParse(SELF:tbCommand:Text, OUT number)
				msg:Command := number
				msg:PayLoad := SELF:tbPayLoad:Text
				//
				VAR ip := (STRING) SELF:comboIPList:SelectedItem
				VAR port := (INT)SELF:portNumber:Value
				IF SELF:checkTasks:Checked
						FOR VAR i:= 1 TO howMany
							//
							Task.Run( { => SendMessage( msg, ip, port ) } )
					NEXT
				ELSE
					FOR VAR i:= 1 TO howMany
						//
						SendMessage( msg, ip, port )
					NEXT
				ENDIF
			ENDIF
			
			
		RETURN
		
		//
		
	END CLASS 
END NAMESPACE
