## Xanthi Communication Library
___
### Commands
When sending a Message, you can set its SessionID, Command with Code and Payload Info  
If the Command is unknown, the Code in reply is CodeValue.NotImplemented  
If the SessionID cannot be found, the Code in reply is CodeValue.NotImplemented  

**CommandValue.Open**  
- _Send to open a file_    
SessionID Value is ignored  
Code is ignored  
Payload contains the Filename to open  
- _reply contains_  
SessionID in which the file is open  
Code is CodeValue.Ok, or CodeValue.NotFound  

**CommandValue.Close**  
- _Close a file in SessionID_    
SessionID to use for process  
Code is ignored  
Payload is ignored   
- _reply contains_  
SessionID in which the file is open  
Code is CodeValue.Ok  

