USING System
USING System.Collections.Generic
USING System.Linq
USING System.Text
USING System.IO
USING NewtonSoft.Json
USING NewtonSoft.Json.Bson
USING System.Net

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
		/// <summary>
		/// The Session ID for this message
		/// </summary>
		PROPERTY SessionID AS INT AUTO

		/// <summary>
		/// The Command send by the message (One of the Command Value)
		/// Value >= 100 : RDD Command code
		/// Value < 100  : Connection/Session management Code
		/// </summary>
		PROPERTY Command AS INT AUTO

		/// <summary>
		/// Parameter or simple Return Value
		/// </summary>
		PROPERTY Code AS INT AUTO

		/// <summary>
		/// The PayLoad for the current Command
		/// </summary>
		PROPERTY PayLoad AS STRING AUTO
		
		/// <summary>
		/// The RDD State object, result of the last Command
		/// </summary>
		PROPERTY RDDState AS STRING AUTO

		/// <summary>
		/// The RDD Error object, result of the last Command
		/// </summary>
		PROPERTY RDDError AS STRING AUTO
		
		CONSTRUCTOR()
			SELF:Code := CodeValue.Ok
			SELF:Command := 0 // CommandValue.None
			SELF:SessionID := 0
			SELF:PayLoad := NULL
			SELF:RDDState := NULL
			SELF:RDDError := NULL
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

		/// <summary>
		/// DeSerialize a BSON Byte Array to a Message object
		/// </summary>
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

/// <summary>
/// Definition of the DELEGATE used in Callback on message reception
/// </summary>
/// <param name="sender"></param>
/// <param name="e"></param>
PUBLIC DELEGATE CommClientMessageHandler(sender AS System.Object, e AS CommClientMessageArgs) AS VOID


	END NAMESPACE
