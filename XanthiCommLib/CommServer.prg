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
USING System.Threading.Tasks

BEGIN NAMESPACE XanthiCommLib

	/// <summary>
	/// Xanthi Communication server
	/// </summary>
	PUBLIC CLASS CommServer
		
		PRIVATE listeningThread AS Thread
		
		PRIVATE accessSessionsMutex AS Mutex
		
		PRIVATE _isRunning AS LOGIC
		
		PRIVATE ep AS IPEndPoint
		
		PRIVATE listener AS TcpListener
		
		PRIVATE autoInc AS LONG
		
		// running Clients
		PRIVATE clients AS List<CommServerClient>
		// opened DataSessions
		PRIVATE dataSessions AS Dictionary<INT,ServerDataSession>
		
		// CallBack ?
		PUBLIC EVENT OnClientAccept AS EventHandler<CommServerEventArgs>
			// CallBack ?
		PUBLIC EVENT OnClientClose AS EventHandler<CommServerEventArgs>
			// CallBack ?
		PUBLIC EVENT OnMessageInfo AS EventHandler<CommClientMessageArgs>
		PUBLIC EVENT OnMessageProcess AS EventHandler<CommClientMessageArgs>		
		
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
					i := 1
					FOREACH ipField AS STRING IN elements
						elts[i++] := Convert.ToByte(ipField)
					NEXT
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
				SELF:InitServer()
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
				SELF:InitServer()
			CATCH e AS Exception
				XanthiLog.Logger:Error("CommServer : Constructor, " + e.Message)
			END TRY
			RETURN
		
			// Init all Server properties 
		/// <summary>
		/// 
		/// </summary>
		PRIVATE METHOD InitServer() AS VOID
			TRY
				SELF:listener := TcpListener{SELF:ep}
				SELF:_isRunning := FALSE
				SELF:accessSessionsMutex := Mutex{}
				SELF:dataSessions := Dictionary<INT,ServerDataSession>{}
			CATCH e AS Exception
				XanthiLog.Logger:Error("CommServer : InitServer, " + e.Message)
			END TRY
			RETURN
		
		PUBLIC PROPERTY IPAddress AS STRING GET ep:Address:ToString()
		
		/// <summary>
		/// Start the Comm Server
		/// </summary>
		PUBLIC METHOD Start() AS VOID
			IF !SELF:IsRunning
				// The real listening Thread
				SELF:listeningThread := Thread{SELF:listening}
				SELF:listeningThread:Start()
			ENDIF
			RETURN
		
		PROPERTY IsRunning AS LOGIC GET SELF:_isRunning
		
		
		/// <summary>
		/// listening to All incoming Connection.
		/// When a client is connecting, the newly created client will be initialized wth OnMessageInfo, and OnMessageProcess.
		/// Then OnClientAccept is called.
		/// </summary>
		PRIVATE METHOD listening() AS VOID
			LOCAL client AS TcpClient
			LOCAL clientNetwork AS CommServerClient
			// 
			SELF:clients := List<CommServerClient>{}
			TRY
				// Start listening for client requests.
				SELF:listener:Start()
				//
				SELF:_isRunning := TRUE
				SELF:autoInc := 0
				// Please, run forever...
				DO WHILE TRUE
					// This is a blocking call
					client := SELF:listener:AcceptTcpClient()
					// We are creating a CommClient with the accepted TcpConnection
					clientNetwork := CommServerClient{client}
					IF SELF:OnMessageInfo != NULL
						clientNetwork:OnMessageInfo += SELF:OnMessageInfo
					ENDIF
					IF SELF:OnMessageProcess != NULL
						clientNetwork:OnMessageProcess += SELF:OnMessageProcess
					ENDIF
					clientNetwork:Server := SELF
					clientNetwork:Start()
					clientNetwork:Id := SELF:autoInc++
					// Add the current Client to the list of running Clients
					BEGIN LOCK clientNetwork
						SELF:clients:Add(clientNetwork)
					END LOCK
					//
					// Need some CallBack ?
					IF SELF:OnClientAccept != NULL
						VAR args := CommServerEventArgs{}
						args:Client := clientNetwork
						SELF:OnClientAccept(SELF, args)
					ENDIF
				END WHILE
			CATCH err AS SocketException
				XanthiLog.Logger:Information("CommServer : Listening Closed, " + err.Message)
			CATCH e AS Exception
				XanthiLog.Logger:Error("CommServer : Listening, " + e.Message)
			FINALLY
				SELF:_isRunning := FALSE
			END TRY
		
		/// <summary>
		/// Stop the Server
		/// </summary>
		PUBLIC METHOD Stop() AS VOID
			LOCAL clt AS CommServerClient
			LOCAL length AS INT
			//
			IF SELF:isRunning
				// Put this in a Thread/Task to avoid a DeadLock in the Stop Method of the Client
				VAR onStop := Task.Run( {  ;
					=> ;
					// This will force the Listener to exit the blocking AcceptTcpClient
					SELF:listener:Stop()
					BEGIN LOCK clients
						length := SELF:clients:Count
					END LOCK
					DO WHILE ( length > 0 )
						BEGIN LOCK clients
							clt := SELF:clients[0]
						END LOCK
						//
						clt:Stop()
						BEGIN LOCK clients
							length := SELF:clients:Count
						END LOCK
					ENDDO
				} )
				//
			ENDIF
			RETURN 
		
		/// <summary>
		/// Remove a Client from the managed Client list
		/// </summary>
		/// <param name="id"></param>
		INTERNAL METHOD RemoveClient(id AS LONG ) AS VOID
			LOCAL clt AS CommServerClient
			// Single Acces to the Client list (Maybe we could use Begin Lock ?)
			BEGIN LOCK clients
				// Search for the CommServerClient object in the list
				clt := SELF:clients:Find({x AS CommServerClient => x:Id == id})
				IF clt != NULL
					// Remove it
					SELF:clients:Remove(clt)
				ENDIF
				// And free access to the list
			END LOCK
			// Doesn't exist ?
			IF clt == NULL
				RETURN
			ENDIF
		
		/// <summary>
		/// Callback the OnClientClose delegate
		/// </summary>
		/// <param name="clt"></param>
		INTERNAL METHOD DoOnClientClose(clt AS CommServerClient) AS VOID
			TRY
				// Do we have a CallBack method ?
				IF SELF:OnClientClose != NULL
					VAR args := CommServerEventArgs{}
					args:Client := clt
					// 
					SELF:OnClientClose(SELF, args)
				ENDIF
			CATCH e AS Exception
				XanthiLog.Logger:Error("CommServer : DoClientClose, " + e.Message)
			END TRY
			RETURN
			
			#region DataSession management
		/// <summary>
		/// Get a data Session from the managed Session list
		/// </summary>
		/// <param name="id">The Id of the Session to retrieve</param>
		/// <returns></returns>
		PUBLIC METHOD GetDataSession( id AS INT ) AS ServerDataSession
			LOCAL session := NULL AS ServerDataSession
			TRY
				BEGIN LOCK SELF:dataSessions
					SELF:dataSessions:TryGetValue( id, OUT session )
				END LOCK
			CATCH e AS Exception
				XanthiLog.Logger:Error("CommServer : GetDataSession, " + e.Message)
			END TRY
			RETURN session
		
		/// <summary>
		/// Add a managed Session to the list
		/// </summary>
		/// <param name="session"></param>
		PUBLIC METHOD AddDataSession( session AS ServerDataSession ) AS VOID
			TRY
				BEGIN LOCK SELF:dataSessions
					SELF:dataSessions:Add(session:Id, session)
				END LOCK
			CATCH e AS Exception
				XanthiLog.Logger:Error("CommServer : AddDataSession, " + e.Message)
			END TRY
			RETURN 
		
		/// <summary>
		/// Delete a Session from the list
		/// </summary>
		/// <param name="id"></param>
		PUBLIC METHOD RemoveDataSession( id AS INT ) AS VOID
			TRY
				BEGIN LOCK SELF:dataSessions
					SELF:dataSessions:Remove( id )
					// Todo Should we close the WorkArea ??
				END LOCK
			CATCH e AS Exception
				XanthiLog.Logger:Error("CommServer : RemoveDataSession, " + e.Message)
			END TRY
			RETURN 
			
			#endregion
		

		
	END CLASS
	
END NAMESPACE
