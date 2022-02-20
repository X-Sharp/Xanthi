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
USING XanthiRDD

BEGIN NAMESPACE XanthiClientTest_Raw

	PUBLIC PARTIAL CLASS MainWindow ;
		INHERIT System.Windows.Forms.Form
		
		PUBLIC CONSTRUCTOR()   STRICT//MainWindow
			InitializeComponent()
		RETURN
		
		PRIVATE METHOD buttonSend_Click(sender AS System.Object, e AS System.EventArgs) AS VOID STRICT
			LOCAL msg AS XanthiCommLib.Message
			LOCAL number AS INT
			LOCAL cmd AS CommandValue
			LOCAL code AS CodeValue
			//
			msg := XanthiCommLib.Message{}
			int32.TryParse( SELF:tbSessionID:Text, OUT number )
			msg:SessionID := (UINT64)number
			IF Enum.TryParse(SELF:comboCommand:Text, OUT cmd )
				msg:Command := cmd
			ENDIF
			IF Enum.TryParse(SELF:comboCode:Text, OUT code )
				msg:Code := Code
			ENDIF
			msg:PayLoad := SELF:tbPayLoad:Text
			//
			IF SendMessage( msg, (STRING) SELF:comboIPList:SelectedItem, (INT)SELF:portNumber:Value )
				//SELF:statusLabel:Text := ""
			ELSE
				SELF:statusLabel:ForeColor := Color.Red
				SELF:statusLabel:Text := "Unable to connect to " + ((STRING) SELF:comboIPList:SelectedItem) + ":" + ((INT)SELF:portNumber:Value):ToString()
		ENDIF
		
		PRIVATE METHOD SendMessage( msg AS XanthiCommLib.Message, ip AS STRING, port AS INT ) AS LOGIC STRICT
			//
			VAR watch := System.Diagnostics.StopWatch{}
			watch:Start()
			VAR client := CommClient{ ip,port }
			IF client:Connect()
				client:WriteMessage( msg )
				msg := client:WaitReply()
				watch:Stop()
				SELF:statusLabel:Text := "Elapsed : " + watch:ElapsedMilliseconds:ToString() + " ms"
				IF msg != NULL
					// Fill the Reply area
					SELF:tbSessionIDReply:Text := msg:SessionID:ToString()
					SELF:tbCommandReply:Text := msg:Command:ToString()
					SELF:tbCodeReply:Text := msg:Code:ToString()
					SELF:tbPayloadReply:Text := msg:PayLoad
					// Clear the send area
					SELF:tbSessionID:Text := ""
					SELF:comboCommand:Text := ""
					SELF:comboCode:Text := ""
					SELF:tbPayLoad:Text := ""
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
			//
			VAR commands := Enum.GetValues(TYPEOF(XanthiRDD.CommandValue))
			FOREACH VAR cmd IN commands
				SELF:comboCommand:Items:Add( cmd:ToString() )
			NEXT
			VAR codes := Enum.GetValues(TYPEOF(XanthiCommLib.CodeValue))
			FOREACH VAR code IN codes
				SELF:comboCode:Items:Add( code:ToString() )
			NEXT
		RETURN
		PRIVATE METHOD buttonMultiSend_Click(sender AS System.Object, e AS System.EventArgs) AS VOID STRICT
			LOCAL msg AS XanthiCommLib.Message
			LOCAL number AS INT
			LOCAL howMany AS INT
			LOCAL cmd AS CommandValue
			LOCAL code AS CodeValue
			//
			int32.TryParse( SELF:tbMulti:Text, OUT howMany )
			IF howMany > 1
				msg := XanthiCommLib.Message{}
				int32.TryParse( SELF:tbSessionID:Text, OUT number )
				msg:SessionID := (UINT64)number
				IF Enum.TryParse(SELF:comboCommand:Text, OUT cmd )
					msg:Command := cmd
				ENDIF
				IF Enum.TryParse(SELF:comboCode:Text, OUT code )
					msg:Code := Code
				ENDIF
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
