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

BEGIN NAMESPACE XanthiServerTest

 PUBLIC PARTIAL CLASS MainWindow ;
        INHERIT System.Windows.Forms.Form
        PRIVATE Server AS XanthiCommLib.CommServer
        PRIVATE connections AS INT
        PRIVATE process AS ServerProcess
  
  PUBLIC CONSTRUCTOR()   STRICT//MainWindow
   InitializeComponent()
  RETURN
  PRIVATE METHOD MainWindow_Load(sender AS System.Object, e AS System.EventArgs) AS VOID STRICT
   // Fill comboIP
   SELF:comboIPList:Items:AddRange( CommTools.RetrieveAllIP():ToArray() )
   SELF:comboIPList:SelectedIndex := 0
   // Port number
   SELF:portNumber:Value := 12345
   connections := 0
   SELF:process := ServerProcess{}
   //
  RETURN
  PRIVATE METHOD buttonStart_Click(sender AS System.Object, e AS System.EventArgs) AS VOID STRICT
   SELF:Server := CommServer{ (STRING) SELF:comboIPList:SelectedItem, (INT)SELF:portNumber:Value }
   SELF:Server:OnClientAccept += System.EventHandler<CommServerEventArgs>{ SELF, @OnClientAccept() }
   SELF:Server:OnClientClose += System.EventHandler<CommServerEventArgs>{ SELF, @OnClientClose() }
   SELF:Server:OnMessageInfo += System.EventHandler<CommClientMessageArgs>{ SELF, @OnMessageInfo() }
   SELF:Server:OnMessageProcess += System.EventHandler<CommClientMessageArgs>{ SELF:process, @OnMessageProcess() }
   SELF:buttonStop:Visible := TRUE
   SELF:buttonStart:Visible := FALSE
   SELF:listBoxClients:Items:Clear()
   SELF:listBoxMessages:Items:Clear()
   connections := 0
   SELF:Server:Start()
   
  RETURN
  
  PRIVATE METHOD OnClientAccept(sender AS System.Object, e AS CommServerEventArgs) AS VOID STRICT
   // Warning, we are in a Thread, not in the main GUI Thread
  SELF:Invoke((CommServerEventHandler)SELF:DoClientAccept, <OBJECT> { sender, e })
  
  PRIVATE METHOD OnClientClose(sender AS System.Object, e AS CommServerEventArgs) AS VOID STRICT
   // Warning, we are in a Thread, not in the main GUI Thread
  SELF:Invoke((CommServerEventHandler)SELF:DoClientClose, <OBJECT> { sender, e })
  
  PRIVATE METHOD OnMessageInfo(sender AS System.Object, e AS CommClientMessageArgs) AS VOID STRICT
   // Warning, we are in a Thread, not in the main GUI Thread
  SELF:Invoke((CommClientMessageHandler)SELF:DoClientMessageInfo, <OBJECT> { sender, e })
  
  PRIVATE METHOD DoClientAccept(sender AS System.Object, e AS CommServerEventArgs) AS VOID STRICT
  SELF:listBoxClients:Items:Add( ">> " + e:Client:IPAddress )
  connections++
  SELF:labelClients:Text := connections:ToString()
  
  PRIVATE METHOD DoClientClose(sender AS System.Object, e AS CommServerEventArgs) AS VOID STRICT
  SELF:listBoxClients:Items:Add( "<< " + e:Client:IPAddress )
  
  
  PRIVATE METHOD DoClientMessageInfo(sender AS System.Object, e AS CommClientMessageArgs) AS VOID STRICT
   SELF:listBoxMessages:Items:Add( ">> " + e:Message:ToString() )
   SELF:labelMessages:Text := SELF:listBoxMessages:Items:Count:ToString()
  RETURN
  PRIVATE METHOD buttonStop_Click(sender AS System.Object, e AS System.EventArgs) AS VOID STRICT
   IF SELF:Server != NULL .AND. SELF:Server:IsRunning
    SELF:Server:Stop()
    SELF:buttonStop:Visible := FALSE
    SELF:buttonStart:Visible := TRUE
   ENDIF
  RETURN
  PRIVATE METHOD MainWindow_FormClosing(sender AS System.Object, e AS System.Windows.Forms.FormClosingEventArgs) AS VOID STRICT
   IF SELF:Server != NULL .AND. SELF:Server:IsRunning
    SELF:Server:Stop()
   ENDIF
  RETURN
 END CLASS 
END NAMESPACE
