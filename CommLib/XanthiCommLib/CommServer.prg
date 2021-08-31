// CommServer.prg
// Created by    : fabri
// Creation Date : 8/27/2021 6:27:52 PM
// Created for   : 
// WorkStation   : FABXPS


USING System
USING System.Collections.Generic
USING System.Diagnostics
USING System.Net
USING System.Net.Sockets
USING System.Threading

BEGIN NAMESPACE XanthiCommLib

	PUBLIC DELEGATE  CommClientEvent( sender AS CommServer, clt AS CommServerClient) AS VOID
		
	PUBLIC CLASS CommServer
		
		
		
	PRIVATE listeningThread AS Thread
		
		//PRIVATE dispatchingThread AS Thread
		
	PRIVATE accessSessionsMutex AS Mutex
	PRIVATE accessClientsMutex AS Mutex
		
		//PRIVATE messageEventFlag AS AutoResetEvent
		
	PRIVATE quitEventFlag AS AutoResetEvent
		
	PRIVATE isRunning AS LOGIC
		
	PRIVATE ep AS IPEndPoint
		
	PRIVATE listener AS TcpListener
		
	PRIVATE autoInc AS LONG
		
		// running Clients
	PRIVATE clients AS List<CommServerClient>
		// opened DataSessions
	PRIVATE sessions AS List<DataSession>
		
		// CallBack ?
	PUBLIC OnClientAccept AS CommClientEvent
		// CallBack ?
	PUBLIC OnClientClose AS CommClientEvent
		
		/// <summary>
		/// Create a Comm Server Object
		/// </summary>
		/// <param name="netAddress">
		/// IP Address as string, in xxx.xxx.xxx.xxx format, to listen to.
		/// If null, Server will listen to LoopBack
		/// If EmptyString, Server will listent to Any addresses (including Loopback)</param>
		/// <param name="port">Server port</param>
		PUBLIC CONSTRUCTOR(netAddress AS STRING , port AS LONG )
			LOCAL elements AS STRING[]
			LOCAL elts AS BYTE[]
			LOCAL i AS LONG
			LOCAL ipadd AS IPAddress
			//
			TRY
					// Do we have an Address with xxx.xxx.xxx.xxx ?
					IF !string.IsNullOrEmpty(netAddress)
							elements := netAddress:Split('.')
							IF elements:Length != 4
								THROW Exception{"We need 4 blocks in an IP Address"}
							ENDIF
							elts := BYTE[]{ 4 }
							//Init
							i := 0
							DO WHILE i < 4
								elts[i] := Convert.ToByte(elements[i])
								//Iterators
								i++
							ENDDO
							ipadd := IPAddress{elts}
						SELF:ep := IPEndPoint{ipadd, port}
					ELSEIF netAddress == NULL
						// LoopBack Adress : 127.0.0.1
						SELF:ep := IPEndPoint{IPAddress.Loopback, port}
					ELSE
						// Try to get it
						SELF:ep := IPEndPoint{IPAddress.Any, port}
					ENDIF
				SELF:InitServer()
			CATCH e AS Exception
				XanthiLog.Logger:Error("CommServer : Constructor, " + e.Message)
			END TRY
		RETURN
		
		/// <summary>
		/// Create a Comm Server Object
		/// </summary>
		/// <param name="netAddress">
		/// IP Address to listen to.
		/// </param>
		/// <param name="port">Server port</param>
		PUBLIC CONSTRUCTOR(netAddress AS IPAddress, port AS LONG )
			TRY
				SELF:ep := IPEndPoint{netAddress, port}
			CATCH e AS Exception
				XanthiLog.Logger:Error("CommServer : Constructor, " + e.Message)
			END TRY
		RETURN
		
		/// <summary>
		/// Create a Comm Server Object
		/// </summary>
		/// <param name="netAddress">
		/// IP EndPoint to listen to.
		/// </param>
		PUBLIC CONSTRUCTOR(netAddress AS IPEndPoint )
			TRY
				SELF:ep := netAddress
			CATCH e AS Exception
				XanthiLog.Logger:Error("CommServer : Constructor, " + e.Message)
			END TRY
		RETURN
		
		// Init all Server properties 
		PRIVATE METHOD InitServer() AS VOID
			TRY
					SELF:listener := TcpListener{SELF:ep}
					SELF:isRunning := FALSE
					SELF:accessSessionsMutex := Mutex{}
					SELF:accessClientsMutex := Mutex{}
					//SELF:messageEventFlag := AutoResetEvent{ FALSE}
				SELF:quitEventFlag := AutoResetEvent{ FALSE}
			CATCH e AS Exception
				XanthiLog.Logger:Error("CommServer : InitServer, " + e.Message)
			END TRY
		RETURN
		
		/// <summary>
		/// Start the Comm Server
		/// </summary>
		PUBLIC METHOD Start() AS VOID
			// The real listening Thread
			SELF:listeningThread := Thread{SELF:listening}
		SELF:listeningThread:Start()
		// Dispatch thread???
		//SELF:dispatchingThread := Thread{SELF:Dispatch}
		//SELF:dispatchingThread:Start()
		
		/*
		PRIVATE METHOD Dispatch() AS VOID
		LOCAL attente AS WaitHandle[]
		LOCAL who AS LONG
		LOCAL msg AS Message
		// Array with system Event to wait For
		attente := <WaitHandle>{ SELF:messageEventFlag, SELF:quitEventFlag }
		DO WHILE TRUE
		who := WaitHandle.WaitAny(attente, -1)
		IF who == 1
		EXIT
		ENDIF
		SELF:accessMessagesMutex:WaitOne()
		msg := NULL
		DO WHILE SELF:messages:Count > 0
		msg := SELF:messages:Pop()
		SELF:accessClientsMutex:WaitOne()
		FOREACH clt AS CommServerClient IN SELF:clients 
		IF clt:Id != msg:Id
		clt:Ecrire(msg:Data)
		ENDIF
		NEXT
		SELF:accessClientsMutex:ReleaseMutex()
		ENDDO
		SELF:accessMessagesMutex:ReleaseMutex()
		ENDDO
		//
		SELF:accessClientsMutex:WaitOne()
		FOREACH clt2 AS ClientReseau IN SELF:clients 
		clt2:Stop()
		NEXT
		SELF:accessClientsMutex:ReleaseMutex()
		*/
		
		
		/// <summary>
		/// listening to All incoming Connection
		/// </summary>
		PRIVATE METHOD listening() AS VOID
			LOCAL client AS TcpClient
			LOCAL clientNetwork AS CommServerClient
			// 
			SELF:clients := List<CommServerClient>{}
		TRY
			// Start listening for client requests.
			SELF:listener:Start()
			
			SELF:isRunning := TRUE
			SELF:autoInc := 0
			// Please, run forever...
			DO WHILE TRUE
					// This is a blocking call
					client := SELF:listener:AcceptTcpClient()
					// We are creating a CommClient with the accepted TcpConnection
					clientNetwork := CommServerClient{client}
					clientNetwork:AccessSessions := SELF:accessSessionsMutex
					clientNetwork:AccessClients := SELF:accessClientsMutex
					//clientNetwork:Messages := SELF:messages
					//clientNetwork:messageEventFlag := SELF:messageEventFlag
					clientNetwork:Server := SELF
					clientNetwork:Start()
					clientNetwork:Id := SELF:autoInc++
					// Add the current Client to the list of running Clients
					SELF:accessClientsMutex:WaitOne()
					SELF:clients:Add(clientNetwork)
					SELF:accessClientsMutex:ReleaseMutex()
					//
					// Need some CallBack ?
					IF SELF:OnClientAccept != NULL
						SELF:OnClientAccept(SELF, clientNetwork)
					ENDIF
					END WHILE
				SELF:isRunning := FALSE
			CATCH e AS Exception
				XanthiLog.Logger:Error("CommServer : Listening, " + e.Message)
		END TRY
		
		/// <summary>
		/// Stop the Server
		/// </summary>
		PUBLIC METHOD Stop() AS VOID
			IF SELF:isRunning
				// This will force the Listener to exit the blocking AcceptTcpClient
				SELF:listener:Stop()
				// Inform all Clients that they MUST leave....
				SELF:quitEventFlag:@@Set()
		ENDIF
		
		
		PUBLIC METHOD RemoveClient(id AS LONG ) AS VOID
			LOCAL clt AS CommServerClient
			// Single Acces to the Client list (Maybe we could use Begin Lock ?)
			SELF:accessClientsMutex:WaitOne()
			// Search for the CommServerClient object in the list
			clt := SELF:clients:Find({x AS CommServerClient => x:Id == id})
			IF clt != NULL
				// Remove it
				SELF:clients:Remove(clt)
			ENDIF
			// And free access to the list
			SELF:accessClientsMutex:ReleaseMutex()
			// Doesn't exist ?
			IF clt == NULL
				RETURN
			ENDIF
			TRY
					// Do we have a CallBack method ?
					IF SELF:OnClientClose != NULL
						SELF:OnClientClose(SELF, clt)
					ENDIF
				
			CATCH e AS Exception
				XanthiLog.Logger:Error("CommServer : RemoveClient, " + e.Message)
		END TRY
		
		
	END CLASS
	
END NAMESPACE
