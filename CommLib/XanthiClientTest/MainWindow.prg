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

        PRIVATE manager AS ServerManager
  
  PUBLIC CONSTRUCTOR()   STRICT//Form1
   InitializeComponent()
  RETURN
  PRIVATE METHOD startServer_Click(sender AS System.Object, e AS System.EventArgs) AS VOID STRICT
    SELF:startServer:Enabled := FALSE
    manager := ServerManager{}
    manager:Server := CommServer{ (STRING) SELF:comboIPList:SelectedItem, (INT)SELF:portNumber:Value }
    manager:Show()
    //
    
  RETURN
  PRIVATE METHOD MainWindow_Load(sender AS System.Object, e AS System.EventArgs) AS VOID STRICT
   // Fill comboIP
   SELF:comboIPList:Items:AddRange( CommTools.RetrieveAllIP():ToArray() )
   SELF:comboIPList:SelectedIndex := 0
   // Port numer
   SELF:portNumber:Value := 12345
PRIVATE METHOD buttonSend_Click(sender AS System.Object, e AS System.EventArgs) AS VOID STRICT
    LOCAL msg AS XanthiCommLib.Message
    //
    msg := XanthiCommLib.Message{}
    msg:Code := int32.Parse( SELF:tbCode:Text )
    msg:Command := int32.Parse(SELF:tbCommand:Text)
    msg:PayLoad := SELF:tbPayLoad:Text
    //
    VAR client := CommClient{ (STRING) SELF:comboIPList:SelectedItem, (INT)SELF:portNumber:Value }
    client:Connect()
    client:WriteMessage( msg )
    client:WaitReply()
    client:Close()
        RETURN
PRIVATE METHOD MainWindow_FormClosing(sender AS System.Object, e AS System.Windows.Forms.FormClosingEventArgs) AS VOID STRICT
        IF manager == NULL
            manager:Close()
        ENDIF
        
        RETURN
   //
  
 END CLASS 
END NAMESPACE
