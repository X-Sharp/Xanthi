## Xanthi Communication Library
___
### Commands
When sending a Message, you can set its SessionID, Command with Code and Payload Info  
If the Command is unknown, the Code in reply is CodeValue.NotImplemented  
If the SessionID cannot be found, the Code in reply is CodeValue.NotImplemented  

**CommandValue.OpenSession**  
- _Send to open a DataSession_    
SessionID is ignored  
Code is ignored  
Payload contains the UserName/Password to use to open a DataSession  
- _reply contains_  
SessionID of the opened DataSession  
Code is CodeValue.Ok, or CodeValue.Unauthorized
Payload contains some informations in CSV form about the Server :  
  - BSON : True/False, Indicate if the Server is using BSON or JSON to transfer data  

**CommandValue.CloseSession**  
- _Close a DataSession, and Close ALL files in the DataSession_    
SessionID to use for process  
Code is ignored  
Payload is ignored   
- _reply contains_  
SessionID of the closed DataSession  
Code is CodeValue.Ok, or CodeValue.NotFound  

**CommandValue.Open**  
- _Send to open a file_    
SessionID is the DataSession ID to use  
Code indicate the WorkArea to open, 0 if Auto (??)  
Payload contains the Filename to open  
- _reply contains_  
SessionID in which the file is open  
Code is CodeValue.Ok, or CodeValue.NotFound  

**CommandValue.Close**  
- _Close a file in SessionID_    
SessionID to use for process  
Code indicate the WorkArea to close  
Payload is ignored   
- _reply contains_  
SessionID in which the file is open  
Code is CodeValue.Ok  

