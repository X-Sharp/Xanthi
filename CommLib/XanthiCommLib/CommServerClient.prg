// CommClient.prg
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
	CLASS CommServerClient
		
		
	PRIVATE tcpClient AS TcpClient
		
	PRIVATE readingThread AS Thread
		
	PRIVATE clientStream AS NetworkStream
		
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
		PUBLIC PROPERTY IPAddress AS STRING
			GET
				LOCAL ep AS EndPoint
				//
				ep := tcpClient:Client:RemoteEndPoint
				RETURN ep:ToString()
				
			END GET
		END PROPERTY
		
		INTERNAL CONSTRUCTOR(client AS TcpClient )
			SELF:tcpClient := client
		SELF:running := FALSE
		//
		SELF:UseBSON := TRUE
		SELF:KeepAlive := FALSE
		
		// Start the Reading Thread
		PUBLIC METHOD Start() AS VOID
			SELF:readingThread := Thread{ SELF:ReadData }
		SELF:readingThread:Start()
		
		// Close the underlying Stream, that will 
		PUBLIC METHOD Stop() AS VOID
			IF SELF:running
				SELF:clientStream:Close()
		ENDIF
		
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
			SELF:running := TRUE
			SELF:clientStream := SELF:tcpClient:GetStream()
			//
			WHILE TRUE
			// first, try to read the Header (the packet size)
			bytesRead := 0
			header :=<BYTE>{4}
			TRY
					// 4 bytes == 32 bits unsigned value == DWORD
				bytesRead := SELF:clientStream:Read(header, 0, 4)
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
			CATCH e AS Exception
				XanthiLog.Logger:Error("CommServerClient : ReadData Error reading data bytes, " + e.Message)
			END TRY
			IF bytesRead != msgSize
				XanthiLog.Logger:Info("CommServerClient : ReadData Unable to read all data bytes.")
				EXIT
			ENDIF
			// Now, decode the message
			IF SELF:UseBSON
				msg := Message.DeSerializeBinary( msgBytes )
			ELSE
				msg := Message.DeSerializeString( msgBytes )
			ENDIF
			// Ok, now Process.....
			
			// Keep the Connection open ?
			IF !SELF:KeepAlive
				EXIT
			ENDIF
			// Ok, so loopback and wait for a new Message
			END WHILE
			// We are out of the receive and process
			SELF:running := FALSE
		SELF:Server:RemoveClient(SELF:Id)
		
		
		PUBLIC METHOD WriteData(msg AS STRING ) AS VOID
			LOCAL encoder AS ASCIIEncoding
			LOCAL buffer AS BYTE[]
			//
			IF SELF:running
				encoder := ASCIIEncoding{}
				buffer := encoder:GetBytes(msg)
				SELF:clientStream:Write(buffer, 0, buffer:Length)
		ENDIF
		
		
	END CLASS
	
END NAMESPACE // XanthiServerLib
