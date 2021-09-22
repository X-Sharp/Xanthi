USING System
USING System.Collections.Generic
USING System.Linq
USING System.Text
USING System.IO
USING NewtonSoft.Json
USING NewtonSoft.Json.Bson

BEGIN NAMESPACE XanthiCommLib


	ENUM CodeValue
		MEMBER Ok := 200
		MEMBER NoContent := 204
		MEMBER BadRequest := 400
		MEMBER Unauthorized := 401
		MEMBER PaymentRequired := 402
		MEMBER Forbidden := 403
		MEMBER NotFound := 404
		MEMBER MethodNotAllowed := 405
		MEMBER RequestTimeout := 408
		MEMBER Conflict := 409
		MEMBER PayloadTooLArge := 413
		MEMBER UpgradeRequired := 426
		MEMBER TooManyRequests := 429
		MEMBER InternalServerError := 500
		MEMBER NotImplemented := 501
		MEMBER ServiceUnavailable := 503

	END ENUM
	
	ENUM CommandValue
		MEMBER None
		MEMBER Open
		MEMBER Close
		MEMBER GoTop
		MEMBER GoBottom
		MEMBER FieldGet
		MEMBER RowGet
		MEMBER DbStruct
		
	END ENUM

	ENUM ServerInfo
		MEMBER Port := 8889
		MEMBER ReadTimeOut := 10000
	END ENUM

	PUBLIC DELEGATE  CommClientMessageHandler(sender AS System.Object, e AS CommClientMessageArgs) AS VOID
	
		/// <summary>
		/// The CommServerEvent class.
	/// </summary>
	CLASS CommClientMessageArgs INHERIT EventArgs
	
	PUBLIC PROPERTY Client AS CommServerClient AUTO
	PUBLIC PROPERTY Message AS Message AUTO
	
	CONSTRUCTOR()
	RETURN
	
END CLASS
	
	
	/// <summary>
	/// Message class used to exchange informations, command, state, ...
	/// </summary>	
	CLASS Message
		// The Session ID for this message
		PROPERTY SessionID AS UINT64 AUTO
		// The Command send by the message
		PROPERTY Command AS CommandValue AUTO
		// Parameter or Return Value
		PROPERTY Code AS CodeValue AUTO
		// The PayLoad for the current Command
		PROPERTY PayLoad AS STRING AUTO
		
		CONSTRUCTOR() STRICT
			SELF:Code := CodeValue.Ok
			SELF:Command := CommandValue.None
			SELF:SessionID := 0
			RETURN
		
		/// <summary>
		/// Serialize a Message object to a BSON Byte Array
		/// </summary>	
		METHOD SerializeBinary() AS BYTE[]
			VAR ms := MemoryStream{}
			BEGIN USING VAR writer := BsonDataWriter{ms}
				//
				VAR serializer := JsonSerializer{}
				serializer:Serialize(writer, SELF)
			END USING
			//
			VAR bsonByteArray := ms:ToArray()
			RETURN bsonByteArray
			
		/// <summary>
		/// Serialize a Message object to a JSON String
		/// </summary>		
		METHOD SerializeString() AS STRING
			//
			RETURN JsonConvert.SerializeObject( SELF )
		
		/// <summary>
		/// DeSerialize a BYTE array to a Message object
		/// </summary>
		STATIC METHOD DeSerializeBinary( byteArray AS BYTE[] ) AS Message
			LOCAL msg AS Message
			VAR ms := MemoryStream{byteArray}
			BEGIN USING VAR reader := BsonDataReader{ms}
				//
				VAR serializer := JsonSerializer{}
				msg := serializer:DeSerialize<Message>(reader)
			END USING
			//
		RETURN msg
		
		/// <summary>
		/// DeSerialize a JSON String to a Message object
		/// </summary>
		STATIC METHOD DeSerializeString( json AS STRING ) AS Message
			LOCAL msg AS Message
			msg := JSonConvert.DeserializeObject<Message>( json )
			//
		RETURN msg

		STATIC METHOD DeSerializeString( byteArray AS BYTE[] ) AS Message
			LOCAL msg AS Message
			VAR ms := MemoryStream{byteArray}
			BEGIN USING VAR reader := StreamReader{ms}
				//
				VAR serializer := JsonSerializer{}
				msg := (Message)serializer:DeSerialize(reader, TypeOf(Message) )
			END USING
			//
		RETURN msg

		PUBLIC METHOD ToString() AS STRING
		RETURN SELF:SessionID:ToString() + ", "  + SELF:Command:ToString() + "," + SELF:Code:ToString() + ", " + SELF:PayLoad
		
	END CLASS
END NAMESPACE
