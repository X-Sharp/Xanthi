﻿// CommClient.prg
// Created by    : fabri
// Creation Date : 8/27/2021 6:29:02 PM
// Created for   : 
// WorkStation   : FABXPS


USING System.Collections.Generic
USING System.Net
USING System.Net.Sockets
USING System.Text
USING System.Threading


BEGIN NAMESPACE XanthiCommLib

	/// <summary>
	/// The CommServerClient class.
	/// This is the client communication Class, used on the Server-Side
	/// </summary>
	PARTIAL CLASS CommServerClient
		
		
		
		
	PRIVATE readingThread AS Thread
	PRIVATE quitReadFlag AS ManualResetEvent
		
	PRIVATE tcpClient AS TcpClient
	PRIVATE clientStream AS NetworkStream
	PRIVATE ep AS IpEndPoint
		
	PRIVATE running AS LOGIC
		
	INTERNAL Id AS INT
		
		// Use BSON or JSON for Serialization ?
	PRIVATE UseBSON AS LOGIC
		// Keep the Connection Open ?
	PRIVATE KeepAlive AS LOGIC
		
		PUBLIC PROPERTY AccessSessions AS Mutex AUTO GET INTERNAL SET 
		PUBLIC PROPERTY AccessClients AS Mutex AUTO GET INTERNAL SET 
		
		PUBLIC PROPERTY Server AS CommServer AUTO GET INTERNAL SET 
		
		// Retrieve the IP address of the Client (The one that started the connection)
		PUBLIC PROPERTY IPAddress AS STRING GET SELF:ep:ToString()
		
		// CallBack ?
	PUBLIC EVENT OnMessage AS EventHandler<CommClientMessageArgs>
		
		INTERNAL CONSTRUCTOR(client AS TcpClient )
			SELF:tcpClient := client
			SELF:ep := (IPEndPoint) tcpClient:Client:RemoteEndPoint
			// Indicate that the ReadData Thread is running
			SELF:running := FALSE
			SELF:quitReadFlag := ManualResetEvent{ FALSE}
			//
			SELF:UseBSON := TRUE
		SELF:KeepAlive := FALSE
		
		// Start the Reading Thread
		PUBLIC METHOD Start() AS VOID
			SELF:readingThread := Thread{ SELF:ReadData }
			SELF:readingThread:Start()
		RETURN
		
		// Close the underlying Stream, and stop the ReadData thread
		// !!! WARNING !!! You may enter a dead-loop if the Thread that is calling this method is the same as the one that will receive the OnClientClose Event
		PUBLIC METHOD Stop() AS VOID
			IF SELF:running
				// Close the Socket and Stream (this will generate a "normal" exception in ReadData)
				SELF:tcpClient:Close()
				SELF:clientStream:Close()
				// Wait that the ReadData Thread is really out
				SELF:quitReadFlag:WaitOne()
			ENDIF
		RETURN
		
		/// <summary>
		/// The underlying Reading Thread that will get the message from the Client, and Dispatch to the current operation
		/// </summary>
		PRIVATE METHOD ReadData() AS VOID
			LOCAL msgBytes AS BYTE[]
			LOCAL header AS BYTE[]
			LOCAL bytesRead AS INT
			LOCAL encoder AS ASCIIEncoding
			LOCAL reception AS STRING
			LOCAL msg AS Message
			LOCAL msgSize AS DWORD
			//
			TRY
					SELF:running := TRUE
					SELF:clientStream := SELF:tcpClient:GetStream()
					//
					DO WHILE TRUE
						// first, try to read the Header (the packet size)
						bytesRead := 0
						header :=BYTE[]{4}
						TRY
								// 4 bytes == 32 bits unsigned value == DWORD
							bytesRead := SELF:clientStream:Read(header, 0, 4)
						CATCH err AS System.IO.IOException
							XanthiLog.Logger:Info("CommServerClient : ReadData Stream Closed, " + err.Message)
							EXIT
						CATCH e AS Exception
							XanthiLog.Logger:Error("CommServerClient : ReadData Header, " + e.Message)
						END TRY
						IF bytesRead != 4
							XanthiLog.Logger:Info("CommServerClient : ReadData Unable to read 4 bytes for Header")
							EXIT
						ENDIF
						// Ok, what is the size of the expected Message
						msgSize := BitConverter.ToUInt32( header, 0 )
						// Todo: should we have a limit here ?
						msgBytes := BYTE[]{ msgSize }
						TRY
								// Now, read the Data
							bytesRead := SELF:clientStream:Read(msgBytes, 0, (INT)msgSize)
						CATCH err AS System.IO.IOException
							XanthiLog.Logger:Info("CommServerClient : ReadData Stream Closed, " + err.Message)
							EXIT
						CATCH e AS Exception
							XanthiLog.Logger:Error("CommServerClient : ReadData Error reading data bytes, " + e.Message)
						END TRY
						IF bytesRead != msgSize
							XanthiLog.Logger:Warn("CommServerClient : ReadData Unable to read all data bytes.")
							EXIT
						ENDIF
						// Now, decode the message
						IF SELF:UseBSON
							msg := Message.DeSerializeBinary( msgBytes )
						ELSE
							msg := Message.DeSerializeString( msgBytes )
						ENDIF
						// Message CallBack
						SELF:DoOnMessage( msg )
						// Ok, now Process.....
						XanthiLog.Logger:Info("CommServerClient : Process message," + msg:Command:ToString() + "," + msg:PayLoad )
						VAR reply := SELF:ProcessMessage( msg )
						IF reply != NULL
							// Write Back
							IF SELF:UseBSON
									VAR bsonBytes := msg:SerializeBinary( )
								SELF:WriteData( bsonBytes)
							ELSE
								VAR jsonString := msg.SerializeString( )
								SELF:WriteData(jsonString)
							ENDIF
							// Just to be sure...
							SELF:clientStream:Flush()
						ENDIF
						// Keep the Connection open ?
						IF !SELF:KeepAlive
							EXIT
						ENDIF
						// Ok, so loopback and wait for a new Message
				ENDDO
			CATCH e AS Exception
				XanthiLog.Logger:Error("CommServerClient : ReadData, " + e.Message)
			FINALLY
				TRY
						// We are out of the receive and process
						SELF:running := FALSE
						// Indicate we are closing
						SELF:Server:DoOnClientClose(SELF) 
						// Then remove the reference to this Client in the Server Clients list
					SELF:Server:RemoveClient(SELF:Id)
				CATCH e AS Exception
					XanthiLog.Logger:Error("CommServerClient : ReadData Finally, " + e.Message)
				FINALLY
					// And raise the Flag indicating that this Thread is out
					SELF:quitReadFlag:@@Set()
				END TRY
			END TRY
		RETURN
		
		
		PRIVATE METHOD WriteData(msg AS STRING ) AS VOID
			LOCAL encoder AS ASCIIEncoding
			LOCAL buffer AS BYTE[]
			//
			TRY
					encoder := ASCIIEncoding{}
					buffer := encoder:GetBytes(msg)
				SELF:WriteData(buffer)
			CATCH e AS Exception
				XanthiLog.Logger:Error("CommServerClient : WriteData, " + e.Message)
			END TRY
		RETURN
		
				// Write the raw Data
		PRIVATE METHOD WriteData(buffer AS BYTE[] ) AS VOID
			//
			TRY
					IF SELF:running
					// First send the size (as a UINT32)
							VAR msgSize := BitConverter.GetBytes( (UINT32)buffer:Length )
							SELF:clientStream:Write(msgSize, 0, msgSize:Length)
						SELF:clientStream:Write(buffer, 0, buffer:Length)
				ENDIF
			CATCH e AS Exception
				XanthiLog.Logger:Error("CommServerClient : WriteData, " + e.Message)
			END TRY
		RETURN
		
		
		INTERNAL METHOD DoOnMessage(msg AS Message) AS VOID
			TRY
					// Do we have a CallBack method ?
					IF SELF:OnMessage != NULL
						VAR args := CommClientMessageArgs{}
						args:Client := SELF
						args:Message := msg
						// 
						SELF:OnMessage(SELF, args)
				ENDIF
			CATCH e AS Exception
				XanthiLog.Logger:Error("CommServer : DoClientClose, " + e.Message)
			END TRY
		RETURN
		
	END CLASS
	
END NAMESPACE // XanthiServerLib
