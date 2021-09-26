## Xanthi Communication Library
___
### Message
The Message object is sent by the Client to the Server, and returned as a Reply

**PROPERTY SessionID AS INT**  
The Session ID for this message

**PROPERTY Command AS INT**  
The Command send by the message

**PROPERTY Code AS CodeValue**  
When send Parameter if numeric, and Return code

**PROPERTY PayLoad AS STRING**  
The PayLoad for the current Command
___

### CommClient  
The CommClient Class used to create a client Object to communicate with the CommServer


**CONSTRUCTOR(remoteHost AS IPAddress, port AS LONG )**  
**CONSTRUCTOR(remoteHost AS STRING , port AS LONG )**  
**CONSTRUCTOR(remoteHost AS IPEndPoint )**  
Create a CommClient Object, indicating the Server to connect to

**METHOD Connect() AS LOGIC**  
Try to Connect to the Server, Return TRUE is successfull

**METHOD Close() AS LOGIC**  
Close the current Client, Return TRUE is successfull

**PROPERTY IsConnected AS LOGIC**  
Indicate if the current Client is connected

**METHOD WriteMessage( msg AS Message ) AS VOID**  
Send a Message object to the Server

**METHOD WaitReply( timeOut := (INT)ServerInfo.ReadTimeOut AS INT) AS Message**  
Wait for the Server to send a reply Message, used after a WriteMessage.

___
### CommServer
The CommServer Class 

**CONSTRUCTOR(netAddress AS IPAddress, port AS LONG )**  
**CONSTRUCTOR(netAddress AS STRING , port AS LONG )**  
**CONSTRUCTOR(netAddress AS IPEndPoint )**  
Create a CommServer Object

**Start()**  
Start the Server  

**Stop()**  
Stop the Server, and Close all CommServerClient running is any  

**IsRunning**  
Indicate if the Server is currently running

**EVENT OnClientAccept AS EventHandler\<CommServerEventArgs\>**   
If provided, a CallBack method each time a Client is connected.
The Callback prototype is :  
_METHOD OnClientAccept(sender AS System.Object, e AS CommServerEventArgs) AS VOID_  
sender is the CommServer  
e contains the CommServerClient object that has been accepted

**EVENT OnClientClose AS EventHandler\<CommServerEventArgs\>**  
If provided, a CallBack method each time a Client is closed, either when the Server closes, or when the distant Client is closing
The Callback prototype is :  
_METHOD OnClientClose(sender AS System.Object, e AS CommServerEventArgs) AS VOID_  
sender is the CommServer  
e contains the CommServerClient object that has been closed

**EVENT OnMessage AS EventHandler\<CommClientMessageArgs\>**  
If provided, a CallBack method each time a Message is received by the Client  
The Callback prototype is :  
_METHOD OnMessage(sender AS System.Object, e AS CommClientMessageArgs) AS VOID_  
sender is the CommServer  
e contains the Message object that has been received  
___

### CommServerClient
The Client that is created when the Server receive a connection  

**PROPERTY Server AS CommServer GET**  
The CommServer that created the Client

**PROPERTY IPAddress AS STRING GET** 
The IP address of the Client (The one that started the connection)
___
### CommServerEventArgs  
	
**PROPERTY Client AS CommServerClient**  
The Client Object
___
### CommClientMessageArgs  
	
**PROPERTY Client AS CommServerClient**  
The Client Object

**PROPERTY Message AS Message**  
The Message Object  
___

