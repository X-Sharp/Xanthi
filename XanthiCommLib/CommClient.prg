﻿// CommClient.prg
// Created by    : fabri
// Creation Date : 9/7/2021 10:11:18 PM
// Created for   : 
// WorkStation   : FABXPS


USING System
USING System.Collections.Generic
USING System.Text
USING System.Net
USING System.Net.Sockets
USING System.Threading

BEGIN NAMESPACE XanthiCommLib

	/// <summary>
	/// The CommClient class.
	/// </summary>
	PUBLIC CLASS CommClient
		
	PRIVATE remoteHostEP AS IPEndPoint
	PRIVATE tcpClient AS TcpClient
	PRIVATE clientStream AS NetworkStream
	PRIVATE messages AS Queue<Message>
		// Use BSON or JSON for Serialization ?
	PRIVATE UseBSON AS LOGIC
		
	PRIVATE Running AS LOGIC
	PRIVATE KeepAlive AS LOGIC
		
		
		/// <summary>
		/// Create a Comm Client Object
		/// </summary>
		/// <param name="remoteHost">
		/// IP EndPoint to talk to.
		/// </param>
		PUBLIC CONSTRUCTOR(remoteHost AS IPEndPoint )
			SELF:_Init( remoteHost)
		RETURN
		
		PRIVATE METHOD _Init(remoteHost AS IPEndPoint) AS VOID
			TRY
					SELF:remoteHostEP := remoteHost
					//
					SELF:UseBSON := TRUE
					SELF:clientStream := NULL
					SELF:messages := Queue<Message>{}
					SELF:Running := FALSE
				SELF:KeepAlive := FALSE
			CATCH e AS Exception
				XanthiLog.Logger:Error("CommClient : Constructor, " + e.Message)
			END TRY
		RETURN
		
		/// <summary>
		/// Create a Comm Client Object
		/// </summary>
		/// <param name="remoteHost">
		/// IP Address to talk to.
		/// </param>
		/// <param name="port">Server port</param>
		PUBLIC CONSTRUCTOR(remoteHost AS IPAddress, port AS LONG )
			TRY
				SELF:_Init( IPEndPoint{remoteHost, port} )
			CATCH e AS Exception
				XanthiLog.Logger:Error("CommClient : Constructor, " + e.Message)
			END TRY
		RETURN
		
		/// <summary>
		/// Create a Comm Client Object
		/// </summary>
		/// <param name="remoteHost">
		/// IP Address to talk to.
		/// </param>
		/// <param name="port">Server port</param>
		PUBLIC CONSTRUCTOR(remoteHost AS STRING, port AS LONG )
			TRY
				SELF:_Init( IPEndPoint{ IPAddress.Parse(remoteHost), port} )
			CATCH e AS Exception
				XanthiLog.Logger:Error("CommClient : Constructor, " + e.Message)
			END TRY
		RETURN
		
		PUBLIC METHOD Connect() AS LOGIC
			LOCAL isOk := FALSE AS LOGIC
			TRY
					SELF:tcpClient := TcpClient{ }
					SELF:tcpClient:Connect(SELF:remoteHostEP)
					IF SELF:tcpClient:Connected
						SELF:clientStream := SELF:tcpClient:GetStream()
						isOk := TRUE
				ENDIF
			CATCH e AS Exception
				XanthiLog.Logger:Error("CommClient : Connect, " + e.Message)
			END TRY
		RETURN isOk
		
		PUBLIC METHOD Close() AS LOGIC
			LOCAL isOk := FALSE AS LOGIC
			TRY
					IF SELF:IsConnected
						SELF:clientStream:Close()
						SELF:tcpClient:Close()
						SELF:clientStream := NULL
						isOk := TRUE
				ENDIF
			CATCH e AS Exception
				XanthiLog.Logger:Error("CommClient : Close, " + e.Message)
			END TRY
		RETURN isOk
		
		PROPERTY IsConnected AS LOGIC => SELF:clientStream != NULL
		
		PUBLIC METHOD WriteMessage( msg AS Message ) AS VOID
			// Now, Encode the message
			IF SELF:UseBSON
					VAR bsonBytes := msg:SerializeBinary( )
				SELF:WriteData( bsonBytes)
			ELSE
				VAR jsonString := msg.SerializeString( )
				SELF:WriteData(jsonString)
			ENDIF
		RETURN
		
		PUBLIC METHOD WaitReply( timeOut := (INT)ServerInfo.ReadTimeOut AS INT) AS Message
			LOCAL msg := NULL AS Message
			//
			TRY
					IF IsConnected
							// Message is waiting in Queue ?
							BEGIN LOCK SELF:messages
								IF SELF:messages:Count > 0
									msg := SELF:messages:Dequeue()
								ENDIF
							END LOCK
							IF ( msg == NULL )
								//
								SELF:clientStream:ReadTimeout := timeOut
								SELF:ReadData()
								BEGIN LOCK SELF:messages
									IF SELF:messages:Count > 0
										msg := SELF:messages:Dequeue()
									ENDIF
								END LOCK
						ENDIF
					ELSE
						XanthiLog.Logger:Warn("CommClient : WaitReply, Connection is Closed " + SELF:remoteHostEP:ToString() )
				ENDIF
			CATCH e AS Exception
				XanthiLog.Logger:Error("CommClient : WaitReply, " + e.Message)
			END TRY
		RETURN msg
		
		// Write a Message
		PRIVATE METHOD WriteData(msg AS STRING ) AS VOID
			LOCAL encoder AS ASCIIEncoding
			LOCAL buffer AS BYTE[]
			//
			TRY
					encoder := ASCIIEncoding{}
					buffer := encoder:GetBytes(msg)
				SELF:WriteData(buffer)
			CATCH e AS Exception
				XanthiLog.Logger:Error("CommClient : WriteData, " + e.Message)
			END TRY
			
		RETURN
		
		// Write the raw Data
		PRIVATE METHOD WriteData(buffer AS BYTE[] ) AS VOID
			//
			TRY
					IF IsConnected
							// First send the size (as a UINT32)
							VAR msgSize := BitConverter.GetBytes( (UINT32)buffer:Length )
							SELF:clientStream:Write(msgSize, 0, msgSize:Length)
							// Then the Data
						SELF:clientStream:Write(buffer, 0, buffer:Length)
					ELSE
						XanthiLog.Logger:Warn("CommClient : WriteData, Connection is Closed " + SELF:remoteHostEP:ToString() )
				ENDIF
			CATCH e AS Exception
				XanthiLog.Logger:Error("CommClient : WriteData, " + e.Message)
			END TRY
			
		RETURN
		
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
					//
					SELF:Running := TRUE
					DO WHILE TRUE
						// first, try to read the Header (the packet size)
						bytesRead := 0
						header :=BYTE[]{4}
						TRY
								// 4 bytes == 32 bits unsigned value == DWORD
							bytesRead := SELF:clientStream:Read(header, 0, 4)
						CATCH err AS System.IO.IOException
							XanthiLog.Logger:Info("CommClient : ReadData Stream Closed, " + err.Message)
							EXIT
						CATCH e AS Exception
							XanthiLog.Logger:Error("CommClient : ReadData Header, " + e.Message)
						END TRY
						IF bytesRead != 4
							XanthiLog.Logger:Info("CommClient : ReadData Unable to read 4 bytes for Header")
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
							XanthiLog.Logger:Info("CommClient : ReadData Stream Closed, " + err.Message)
							EXIT
						CATCH e AS Exception
							XanthiLog.Logger:Error("CommClient : ReadData Error reading data bytes, " + e.Message)
						END TRY
						IF bytesRead != msgSize
							XanthiLog.Logger:Warn("CommClient : ReadData Unable to read all data bytes.")
							EXIT
						ENDIF
						// Now, decode the message
						IF SELF:UseBSON
							msg := Message.DeSerializeBinary( msgBytes )
						ELSE
							msg := Message.DeSerializeString( msgBytes )
						ENDIF
						// Ok, now Store.....
						XanthiLog.Logger:Info("CommClient : Enqueue message," + msg:Command:ToString() + "," + msg:PayLoad )
						BEGIN LOCK SELF:messages
							SELF:messages:Enqueue( msg )
						END LOCK
						// Keep the Connection open ?
						IF !SELF:KeepAlive
							EXIT
						ENDIF
						// Ok, so loopback and wait for a new Message
				ENDDO
			CATCH e AS Exception
				XanthiLog.Logger:Error("CommClient : ReadData, " + e.Message)
			FINALLY
				// We are out of the receive and process
				SELF:running := FALSE
			END TRY
		RETURN
		
	END CLASS
END NAMESPACE // XanthiCommLib