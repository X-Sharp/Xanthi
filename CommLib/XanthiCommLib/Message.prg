USING System
USING System.Collections.Generic
USING System.Linq
USING System.Text
USING System.IO
USING NewtonSoft.Json
USING NewtonSoft.Json.Bson

BEGIN NAMESPACE XanthiCommLib


	ENUM CodeValue
		MEMBER Ok
		MEMBER Error
		MEMBER Warning
	END ENUM
	
	ENUM CommandValue
		MEMBER None
		MEMBER Open
		MEMBER Close
		MEMBER GoTop
		MEMBER GoBottom
		MEMBER FieldGet
		MEMBER RowGet
		
	END ENUM

	ENUM ServerInfo
		MEMBER Port := 8889
		MEMBER ReadTimeOut := 10000
	END ENUM
	
	
	/// <summary>
	/// Message class used to exchange informations, command, state, ...
	/// </summary>	
	CLASS Message
		
		// 
		PROPERTY Code AS INT AUTO
		
		PROPERTY Command AS INT AUTO

		PROPERTY SessionID AS INT AUTO
		
		PROPERTY PayLoad AS STRING AUTO
		
		CONSTRUCTOR() STRICT
			SELF:Code := CodeValue.Ok
			SELF:Command := CommandValue.None
			SELF:SessionID := -1
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
		
	END CLASS
END NAMESPACE
