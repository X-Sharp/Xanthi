USING System
USING System.Collections.Generic
USING System.ComponentModel
USING System.Data
USING System.Drawing

USING System.Text

USING System.Windows.Forms

USING XanthiCommLib

BEGIN NAMESPACE XanthiClientTest


 PUBLIC PARTIAL CLASS ServerManager ;
        INHERIT System.Windows.Forms.Form
        PUBLIC Server AS XanthiCommLib.CommServer
 
  PUBLIC CONSTRUCTOR() STRICT 
   InitializeComponent()
  RETURN
  PRIVATE METHOD ServerManager_Load(sender AS System.Object, e AS System.EventArgs) AS VOID STRICT
   SELF:Server:OnClientAccept += System.EventHandler<CommServerEventArgs>{ SELF, @OnClientAccept() }
   SELF:Server:OnClientClose += System.EventHandler<CommServerEventArgs>{ SELF, @OnClientClose() }
   SELF:serverIP:Text := SELF:Server:IPAddress
   SELF:Server:Start()


  PRIVATE METHOD ServerManager_FormClosing(sender AS System.Object, e AS System.Windows.Forms.FormClosingEventArgs) AS VOID STRICT
   SELF:Server:Stop()
  RETURN
  
  PRIVATE METHOD OnClientAccept(sender AS System.Object, e AS CommServerEventArgs) AS VOID STRICT
   // Warning, we are in a Thread, not in the main GUI Thread
  SELF:Invoke((CommServerEventHandler)SELF:DoClientAccept, <OBJECT> { sender, e })

    PRIVATE METHOD OnClientClose(sender AS System.Object, e AS CommServerEventArgs) AS VOID STRICT
   // Warning, we are in a Thread, not in the main GUI Thread
  SELF:Invoke((CommServerEventHandler)SELF:DoClientClose, <OBJECT> { sender, e })
  
  PRIVATE METHOD DoClientAccept(sender AS System.Object, e AS CommServerEventArgs) AS VOID STRICT
    SELF:listBoxClients:Items:Add( ">> " + e:Client:IPAddress )

      PRIVATE METHOD DoClientClose(sender AS System.Object, e AS CommServerEventArgs) AS VOID STRICT
    SELF:listBoxClients:Items:Add( "<< " + e:Client:IPAddress )
   
  RETURN
PRIVATE METHOD buttonStop_Click(sender AS System.Object, e AS System.EventArgs) AS VOID STRICT
    IF SELF:Server:IsRunning
        SELF:Server:Stop()
        SELF:buttonStop:Enabled := FALSE
    ENDIF
        RETURN
  
 END CLASS 
END NAMESPACE
