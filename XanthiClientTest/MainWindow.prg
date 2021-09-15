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
   VAR client := CommClient{ (STRING) SELF:comboIPList:SelectedItem, (INT)SELF:portNumber:Value }
   IF client:Connect()
       SELF:statusLabel:ForeColor := Color.Black
    SELF:statusLabel:Text := "Connected to " + ((STRING) SELF:comboIPList:SelectedItem) + ":" + ((INT)SELF:portNumber:Value):ToString()
    client:WriteMessage( msg )
    client:WaitReply()
    client:Close()
    SELF:statusLabel:Text := ""
   ELSE
    SELF:statusLabel:ForeColor := Color.Red
    SELF:statusLabel:Text := "Unable to connect to " + ((STRING) SELF:comboIPList:SelectedItem) + ":" + ((INT)SELF:portNumber:Value):ToString()
   ENDIF
  RETURN
  PRIVATE METHOD MainWindow_Load(sender AS System.Object, e AS System.EventArgs) AS VOID STRICT
   // Fill comboIP
   SELF:comboIPList:Items:AddRange( CommTools.RetrieveAllIP():ToArray() )
   SELF:comboIPList:SelectedIndex := 0
   // Port number
   SELF:portNumber:Value := 12345
   //
   SELF:statusLabel:Text := ""
  RETURN
  //
  
 END CLASS 
END NAMESPACE
