// XanthiRDD.prg
// Created by    : fabri
// Creation Date : 1/27/2022 8:47:58 PM
// Created for   : 
// WorkStation   : FABXPS


USING System
USING System.Collections.Generic
USING System.Text
USING XanthiCommLib
USING System.Diagnostics
USING XSharp.RDD
USING XSharp.RDD.Support
USING System.IO
USING NewtonSoft.Json

BEGIN NAMESPACE XanthiRDD

	/// <summary>
	/// The XanthiRDD class.
	/// </summary>
	CLASS XanthiRDD IMPLEMENTS IRDD

		// Current state of the RDD
		PRIVATE rddState AS XanthiRDDState
		PRIVATE updateState AS LOGIC

		PRIVATE PROPERTY Client AS CommClient GET SELF:Connection:Client
		// The Connection on Client side is linked to the SessionID on Server Side
		// Good Idea ?
		PRIVATE PROPERTY SessionID AS UINT64 GET SELF:Connection:SessionID

		PROPERTY TimeOut AS INT GET SELF:Connection:TimeOut

		PROPERTY Connection AS Connection AUTO

		CONSTRUCTOR()
			SELF:Init()

		CONSTRUCTOR( server AS Connection )
			SELF:Connection := server
			//
			SELF:Init()
			RETURN

		PRIVATE METHOD Init() AS VOID
			//
			rddState := XanthiRDDState{}
			updateState := FALSE
			RETURN

			// Set the current state of RDD (Bof/Eof/Alias/...) in the next sent Message
		PRIVATE METHOD NeedUpdate( msg AS Message ) AS VOID
			//
			IF updateState
				msg:RDDState := JsonConvert.SerializeObject( SELF:rddState )
				updateState := FALSE
			ENDIF

			// Update the current state of RDD (Bof/Eof/Alias/...) from the latest received Message
		PRIVATE METHOD CheckUpdate( msg AS Message ) AS VOID
			//
			IF msg:RDDState != NULL
				SELF:rddState := JsonConvert.DeserializeObject<XanthiRDDState>( msg:RDDState )
			ENDIF

			// Check if the latest received Message contains a RDDError, if so THROW it
		PRIVATE METHOD CheckError( msg AS Message ) AS VOID
			LOCAL oError AS RDDError
			//
			IF msg:RDDError != NULL
				oError := JsonConvert.DeserializeObject<RDDError>( msg:RDDError )
				THROW oError
			ENDIF

			#region Send/Receive commands

		/// <summary>
		/// Send a Command, with no Parameters, that return a result through Message.Code
		/// </summary>
		/// <param name="nCommand">The CommandValue that identify the command</param>
		/// <returns>The success of the Command</returns>
		PRIVATE METHOD SendCommand( nCommand AS CommandValue ) AS LOGIC
			LOCAL msg AS Message
			LOCAL isOk := FALSE AS LOGIC
			IF SELF:SessionID == 0
				RETURN FALSE
			ENDIF
			// Send Message
			msg := Message{}
			msg:SessionID := (UINT64)SELF:SessionID
			msg:Command := nCommand
			SELF:NeedUpdate( msg )
			//
			IF SELF:Client:Connect()
				SELF:Client:WriteMessage( msg )
				msg := SELF:Client:WaitReply( SELF:TimeOut )
				SELF:Client:Close()
				IF msg != NULL
					SELF:CheckUpdate(msg)
					SELF:CheckError(msg)
					// We have a reply
					IF msg:Code == CodeValue.Ok
						isOk := TRUE
					ENDIF
				ENDIF
			ENDIF
			RETURN isOk

		/// <summary>
		/// Send a Command, with one Parameter, that return a result through Message.Code
		/// </summary>
		/// <param name="nCommand">The CommandValue that identify the command</param>
		/// <param name="param">The int parameter</param>
		/// <returns>The success of the Command</returns>
		PRIVATE METHOD SendCommand( nCommand AS CommandValue, param AS INT ) AS LOGIC
			LOCAL msg AS Message
			LOCAL isOk := FALSE AS LOGIC
			IF SELF:SessionID == 0
				RETURN FALSE
			ENDIF
			// Send Message
			msg := Message{}
			msg:SessionID := (UINT64)SELF:SessionID
			msg:Command := nCommand
			msg:Code := param
			SELF:NeedUpdate( msg )
			//
			IF SELF:Client:Connect()
				SELF:Client:WriteMessage( msg )
				msg := SELF:Client:WaitReply( SELF:TimeOut )
				SELF:Client:Close()
				IF msg != NULL
					SELF:CheckUpdate(msg)
					SELF:CheckError(msg)
					// We have a reply
					IF msg:Code == CodeValue.Ok
						isOk := TRUE
					ENDIF
				ENDIF
			ENDIF
			RETURN isOk

		/// <summary>
		/// Send a Command, with one Parameter, that return a result through Message.Code
		/// </summary>
		/// <param name="nCommand">The CommandValue that identify the command</param>
		/// <param name="jsonObject">The string parameter (that is usually a Serialized object in JSON)</param>
		/// <returns>The success of the Command</returns>
		PRIVATE METHOD SendCommand( nCommand AS CommandValue, jsonObject AS STRING ) AS LOGIC
			LOCAL msg AS Message
			LOCAL isOk := FALSE AS LOGIC
			IF SELF:SessionID == 0
				RETURN FALSE
			ENDIF
			// Send Message
			msg := Message{}
			msg:SessionID := (UINT64)SELF:SessionID
			msg:Command := nCommand
			msg:PayLoad := jsonObject
			SELF:NeedUpdate( msg )
			//
			IF SELF:Client:Connect()
				SELF:Client:WriteMessage( msg )
				msg := SELF:Client:WaitReply( SELF:TimeOut )
				SELF:Client:Close()
				IF msg != NULL
					SELF:CheckUpdate(msg)
					SELF:CheckError(msg)
					// We have a reply
					IF msg:Code == CodeValue.Ok
						isOk := TRUE
					ENDIF
				ENDIF
			ENDIF
			RETURN isOk

		/// <summary>
		/// Send a Command, that return a result through Message.Payload and Message.Code
		/// </summary>
		/// <param name="nCommand">The CommandValue that identify the command</param>
		/// <param name="isOk">The result of the Command as a REF Logic</param>
		/// <returns>The result of the Command in a String form (usually a Serialized object in JSON)</returns>
		PRIVATE METHOD RecvCommand( nCommand AS CommandValue, isOk REF LOGIC ) AS STRING
			LOCAL msg AS Message
			LOCAL reply := NULL AS STRING
			IF SELF:SessionID == 0
				RETURN reply
			ENDIF
			// Send Message
			msg := Message{}
			msg:SessionID := (UINT64)SELF:SessionID
			msg:Command := nCommand
			SELF:NeedUpdate( msg )
			//
			IF SELF:Client:Connect()
				SELF:Client:WriteMessage( msg )
				msg := SELF:Client:WaitReply( SELF:TimeOut )
				SELF:Client:Close()
				IF msg != NULL
					SELF:CheckUpdate(msg)
					SELF:CheckError(msg)
					// We have a reply
					IF msg:Code == CodeValue.Ok
						reply := msg:Payload
					ENDIF
				ENDIF
			ENDIF
			RETURN reply

		/// <summary>
		/// Send a Command, that receive one parameter and return a result through Message.Payload and Message.Code
		/// </summary>
		/// <param name="nCommand">The CommandValue that identify the command</param>
		/// <param name="jsonObject">The string parameter (that is usually a Serialized object in JSON)</param>
		/// <param name="isOk">The result of the Command as a REF Logic</param>
		/// <returns>The result of the Command in a String form (usually a Serialized object in JSON)</returns>
		PRIVATE METHOD RecvCommand( nCommand AS CommandValue, jsonObject AS STRING, isOk REF LOGIC ) AS STRING
			LOCAL msg AS Message
			LOCAL reply := NULL AS STRING
			IF SELF:SessionID == 0
				RETURN reply
			ENDIF
			// Send Message
			msg := Message{}
			msg:SessionID := (UINT64)SELF:SessionID
			msg:Command := nCommand
			msg:PayLoad := jsonObject
			SELF:NeedUpdate( msg )
			//
			IF SELF:Client:Connect()
				SELF:Client:WriteMessage( msg )
				msg := SELF:Client:WaitReply( SELF:TimeOut )
				SELF:Client:Close()
				IF msg != NULL
					SELF:CheckUpdate(msg)
					SELF:CheckError(msg)
					// We have a reply
					IF msg:Code == CodeValue.Ok
						reply := msg:Payload
					ENDIF
				ENDIF
			ENDIF
			RETURN reply
			
			#endregion

			#region Implement IRdd

		PUBLIC METHOD DbEval(info AS XSharp.RDD.Support.DbEvalInfo) AS LOGIC
			IF SELF:SessionID == 0
				RETURN FALSE
			ENDIF
			//
			RETURN SendCommand( CommandValue.DbEval, JsonConvert.SerializeObject( info ) )


		PUBLIC METHOD GoTop() AS LOGIC
			RETURN SendCommand( CommandValue.GoTop )

		PUBLIC METHOD GoBottom() AS LOGIC
			RETURN SendCommand( CommandValue.GoBottom )

		PUBLIC METHOD GoTo(nRec AS INT) AS LOGIC
			RETURN SendCommand( CommandValue.Goto, nRec )
	        
		PUBLIC METHOD GoToId(oRec AS OBJECT) AS LOGIC
			IF SELF:SessionID == 0
				RETURN FALSE
			ENDIF
			RETURN SendCommand( CommandValue.DbEval, JsonConvert.SerializeObject( oRec ) )

		PUBLIC METHOD Skip(nToSkip AS INT) AS LOGIC
			RETURN SendCommand( CommandValue.Skip, nToSkip )
	        
		PUBLIC METHOD SkipFilter(nToSkip AS INT) AS LOGIC
			RETURN SendCommand( CommandValue.SkipFilter, nToSkip )

		PUBLIC METHOD SkipRaw(nToSkip AS INT) AS LOGIC
			RETURN SendCommand( CommandValue.SkipRaw, nToSkip )

		PUBLIC METHOD SkipScope(nToSkip AS INT) AS LOGIC
			RETURN SendCommand( CommandValue.SkipScope, nToSkip )
  
		PUBLIC METHOD Append(lReleaseLock AS LOGIC) AS LOGIC
			RETURN SendCommand( CommandValue.Append, IIF( lReleaseLock, 1, 0 ) )

		PUBLIC METHOD Delete() AS LOGIC
			RETURN SendCommand( CommandValue.Delete )

		PUBLIC METHOD GetRec() AS BYTE[]
			LOCAL reply AS STRING
			LOCAL isOk := FALSE AS LOGIC
			LOCAL data := NULL AS BYTE[]
			//
			reply := RecvCommand( CommandValue.GetRec, REF isOk )
			IF isOk
				data := JsonConvert.DeserializeObject<BYTE[]>( reply ) 
			ENDIF
			RETURN data

		PUBLIC METHOD Pack() AS LOGIC
			RETURN SendCommand( CommandValue.Pack )
	        
		PUBLIC METHOD PutRec(aRec AS BYTE[]) AS LOGIC
			IF SELF:SessionID == 0
				RETURN FALSE
			ENDIF
			RETURN SendCommand( CommandValue.PutRec, JsonConvert.SerializeObject( aRec ) )

		PUBLIC METHOD Recall() AS LOGIC
			RETURN SendCommand( CommandValue.Recall )

		PUBLIC METHOD Zap() AS LOGIC
			RETURN SendCommand( CommandValue.Zap )
	        
		PUBLIC METHOD Close() AS LOGIC
			RETURN SendCommand( CommandValue.Close) 

		PUBLIC METHOD Create(info AS XSharp.RDD.Support.DbOpenInfo) AS LOGIC
			IF SELF:SessionID == 0
				RETURN FALSE
			ENDIF
			RETURN SendCommand( CommandValue.PutRec, JsonConvert.SerializeObject( info ) )

		PUBLIC METHOD Open(info AS XSharp.RDD.Support.DbOpenInfo) AS LOGIC
			IF SELF:SessionID == 0
				RETURN FALSE
			ENDIF
			RETURN SendCommand( CommandValue.Open, JsonConvert.SerializeObject( info ) )
	        
		PUBLIC METHOD ClearFilter() AS LOGIC
			RETURN SendCommand( CommandValue.ClearFilter)
	        
		PUBLIC METHOD ClearScope() AS LOGIC
			RETURN SendCommand( CommandValue.ClearScope)
	     
		PUBLIC METHOD Continue() AS LOGIC
			RETURN SendCommand( CommandValue.Continue)
	    
		PUBLIC METHOD GetScope() AS XSharp.RDD.Support.DbScopeInfo
			LOCAL reply AS STRING
			LOCAL isOk := FALSE AS LOGIC
			LOCAL data := NULL AS XSharp.RDD.Support.DbScopeInfo
			//
			reply := RecvCommand( CommandValue.FieldIndex, REF isOk )
			IF isOk
				data := JsonConvert.DeserializeObject<XSharp.RDD.Support.DbScopeInfo>( reply ) 
			ENDIF
			RETURN data

		PUBLIC METHOD SetFilter(info AS XSharp.RDD.Support.DbFilterInfo) AS LOGIC
			IF SELF:SessionID == 0
				RETURN FALSE
			ENDIF
			RETURN SendCommand( CommandValue.SetFilter, JsonConvert.SerializeObject( info ) )
	        

		PUBLIC METHOD SetScope(info AS XSharp.RDD.Support.DbScopeInfo) AS LOGIC
			IF SELF:SessionID == 0
				RETURN FALSE
			ENDIF
			RETURN SendCommand( CommandValue.SetScope, JsonConvert.SerializeObject( info ) )
	        

		PUBLIC METHOD SetFieldExtent(fieldCount AS INT) AS LOGIC
			RETURN SendCommand( CommandValue.SetFieldExtent, fieldCount )
	        
		PUBLIC METHOD AddField(info AS XSharp.RDD.Support.RddFieldInfo) AS LOGIC
			IF SELF:SessionID == 0
				RETURN FALSE
			ENDIF
			RETURN SendCommand( CommandValue.SetScope, JsonConvert.SerializeObject( info ) )

		PUBLIC METHOD CreateFields(aFields AS XSharp.RDD.Support.RddFieldInfo[]) AS LOGIC
			IF SELF:SessionID == 0
				RETURN FALSE
			ENDIF
			RETURN SendCommand( CommandValue.CreateFields, JsonConvert.SerializeObject( aFields ) )

		PUBLIC METHOD FieldIndex(fieldName AS STRING) AS INT
			LOCAL reply AS STRING
			LOCAL isOk := FALSE AS LOGIC
			LOCAL data := 0 AS INT
			//
			reply := RecvCommand( CommandValue.FieldIndex, REF isOk )
			IF isOk
				data := JsonConvert.DeserializeObject<INT>( reply ) 
			ENDIF
			RETURN data
	        

		PUBLIC METHOD FieldInfo(nFldPos AS INT, nOrdinal AS INT, oValue AS OBJECT) AS OBJECT
			LOCAL reply AS STRING
			LOCAL isOk := FALSE AS LOGIC
			LOCAL data := NULL AS OBJECT
			VAR cargo := Tuple<INT,INT,OBJECT>{	nFldPos, nOrdinal, oValue}
			//
			reply := RecvCommand( CommandValue.FieldInfo, JsonConvert.SerializeObject( cargo ) , REF isOk )
			IF isOk
				data := JsonConvert.DeserializeObject<OBJECT>( reply ) 
			ENDIF
			RETURN data


		PUBLIC METHOD FieldName(nFldPos AS INT) AS STRING
			LOCAL reply AS STRING
			LOCAL isOk := FALSE AS LOGIC
			LOCAL data := NULL AS STRING
			//
			reply := RecvCommand( CommandValue.FieldName, JsonConvert.SerializeObject( nFldPos ) , REF isOk )
			IF isOk
				data := JsonConvert.DeserializeObject<STRING>( reply ) 
			ENDIF
			RETURN data
	        

		PUBLIC METHOD GetField(nFldPos AS INT) AS XSharp.RDD.Support.RddFieldInfo
			LOCAL reply AS STRING
			LOCAL isOk := FALSE AS LOGIC
			LOCAL data := NULL AS XSharp.RDD.Support.RddFieldInfo
			//
			reply := RecvCommand( CommandValue.GetField, JsonConvert.SerializeObject( nFldPos ) , REF isOk )
			IF isOk
				data := JsonConvert.DeserializeObject<XSharp.RDD.Support.RddFieldInfo>( reply ) 
			ENDIF
			RETURN data

		PUBLIC METHOD GetValue(nFldPos AS INT) AS OBJECT
			LOCAL reply AS STRING
			LOCAL isOk := FALSE AS LOGIC
			LOCAL data := NULL AS BYTE[]
			//
			reply := RecvCommand( CommandValue.GetValue, JsonConvert.SerializeObject( nFldPos ) , REF isOk )
			IF isOk
				data := JsonConvert.DeserializeObject<BYTE[]>( reply ) 
			ENDIF
			RETURN data

		PUBLIC METHOD GetValueFile(nFldPos AS INT, fileName AS STRING) AS LOGIC
			LOCAL reply AS STRING
			LOCAL isOk := FALSE AS LOGIC
			LOCAL data := NULL AS BYTE[]
			//
			reply := RecvCommand( CommandValue.GetValue, JsonConvert.SerializeObject( nFldPos ) , REF isOk )
			IF isOk
				data := JsonConvert.DeserializeObject<BYTE[]>( reply )
				LOCAL file := System.IO.File.Create(fileName) AS FileStream
				file:Write(data, 0, data:Length)
				file:Close()
			ENDIF
			RETURN isOk
	        

		PUBLIC METHOD GetValueLength(nFldPos AS INT) AS INT
			LOCAL reply AS STRING
			LOCAL isOk := FALSE AS LOGIC
			LOCAL data := 0 AS INT
			//
			reply := RecvCommand( CommandValue.GetValueLength, JsonConvert.SerializeObject( nFldPos ) , REF isOk )
			IF isOk
				data := JsonConvert.DeserializeObject<INT>( reply ) 
			ENDIF
			RETURN data

		PUBLIC METHOD Flush() AS LOGIC
			IF SELF:SessionID == 0
				RETURN FALSE
			ENDIF
			RETURN SendCommand( CommandValue.Flush )

		PUBLIC METHOD GoCold() AS LOGIC
			IF SELF:SessionID == 0
				RETURN FALSE
			ENDIF
			RETURN SendCommand( CommandValue.GoCold )

		PUBLIC METHOD GoHot() AS LOGIC
			IF SELF:SessionID == 0
				RETURN FALSE
			ENDIF
			RETURN SendCommand( CommandValue.GoHot )

		PUBLIC METHOD PutValue(nFldPos AS INT, oValue AS OBJECT) AS LOGIC
			IF SELF:SessionID == 0
				RETURN FALSE
			ENDIF
			IF oValue IS BYTE[] VAR bytes
				RETURN SendCommand( CommandValue.PutValue, JsonConvert.SerializeObject( bytes ) )
			ENDIF
			RETURN FALSE
	        

		PUBLIC METHOD PutValueFile(nFldPos AS INT, fileName AS STRING) AS LOGIC
			// TODO 
			THROW NotImplementedException{}
	        

		PUBLIC METHOD Refresh() AS LOGIC
			RETURN SendCommand( CommandValue.Refresh )
	        

		PUBLIC METHOD AppendLock(uiMode AS XSharp.RDD.Enums.DbLockMode) AS LOGIC
			RETURN SendCommand( CommandValue.AppendLock, (INT) uiMode )
	        

		PUBLIC METHOD HeaderLock(uiMode AS XSharp.RDD.Enums.DbLockMode) AS LOGIC
			RETURN SendCommand( CommandValue.HeaderLock, (INT) uiMode )

		PUBLIC METHOD Lock(uiMode REF XSharp.RDD.Support.DbLockInfo) AS LOGIC
			IF SELF:SessionID == 0
				RETURN FALSE
			ENDIF
			RETURN SendCommand( CommandValue.HeaderLock, JsonConvert.SerializeObject( uiMode ) )
	        

		PUBLIC METHOD UnLock(oRecId AS OBJECT) AS LOGIC
			LOCAL recordNbr AS LONG
			//
			recordNbr := Convert.ToInt32( oRecId )
			RETURN SendCommand( CommandValue.UnLock, recordNbr )
	        

		PUBLIC METHOD CloseMemFile() AS LOGIC
			RETURN SendCommand( CommandValue.CloseMemFile )
	        

		PUBLIC METHOD CreateMemFile(info AS XSharp.RDD.Support.DbOpenInfo) AS LOGIC
			// TODO 
			THROW NotImplementedException{}

		PUBLIC METHOD OpenMemFile(info AS XSharp.RDD.Support.DbOpenInfo) AS LOGIC
			// TODO 
			THROW NotImplementedException{}
	        

		PUBLIC METHOD OrderCondition(info AS XSharp.RDD.Support.DbOrderCondInfo) AS LOGIC
			LOCAL isOk := FALSE AS LOGIC
			//
			isOk := SendCommand( CommandValue.OrderCondition, JsonConvert.SerializeObject( info ) )
			RETURN isOk

		PUBLIC METHOD OrderCreate(info AS XSharp.RDD.Support.DbOrderCreateInfo) AS LOGIC
			LOCAL isOk := FALSE AS LOGIC
			//
			isOk := SendCommand( CommandValue.OrderCreate, JsonConvert.SerializeObject( info ) )
			RETURN isOk
	        

		PUBLIC METHOD OrderDestroy(info AS XSharp.RDD.Support.DbOrderInfo) AS LOGIC
			LOCAL isOk := FALSE AS LOGIC
			//
			isOk := SendCommand( CommandValue.OrderDestroy, JsonConvert.SerializeObject( info ) )
			RETURN isOk

		PUBLIC METHOD OrderInfo(nOrdinal AS DWORD, info AS XSharp.RDD.Support.DbOrderInfo) AS OBJECT
			LOCAL reply AS STRING
			LOCAL isOk := FALSE AS LOGIC
			LOCAL data := NULL AS OBJECT
			VAR cargo := Tuple<DWORD,XSharp.RDD.Support.DbOrderInfo>{ nOrdinal, info}
			
			//
			reply := RecvCommand( CommandValue.OrderInfo, JsonConvert.SerializeObject( cargo ) , REF isOk )
			IF isOk
				data := JsonConvert.DeserializeObject<OBJECT>( reply ) 
			ENDIF
			RETURN data

		PUBLIC METHOD OrderListAdd(info AS XSharp.RDD.Support.DbOrderInfo) AS LOGIC
			LOCAL isOk := FALSE AS LOGIC
			//
			isOk := SendCommand( CommandValue.OrderListAdd, JsonConvert.SerializeObject( info ) )
			RETURN isOk
	        

		PUBLIC METHOD OrderListDelete(info AS XSharp.RDD.Support.DbOrderInfo) AS LOGIC
			LOCAL isOk := FALSE AS LOGIC
			//
			isOk := SendCommand( CommandValue.OrderListDelete, JsonConvert.SerializeObject( info ) )
			RETURN isOk
	        

		PUBLIC METHOD OrderListFocus(info AS XSharp.RDD.Support.DbOrderInfo) AS LOGIC
			LOCAL isOk := FALSE AS LOGIC
			//
			isOk := SendCommand( CommandValue.OrderListFocus, JsonConvert.SerializeObject( info ) )
			RETURN isOk
	        

		PUBLIC METHOD OrderListRebuild() AS LOGIC
			RETURN SendCommand( CommandValue.OrderListRebuild )
	        

		PUBLIC METHOD Seek(info AS XSharp.RDD.Support.DbSeekInfo) AS LOGIC
			LOCAL isOk := FALSE AS LOGIC
			//
			isOk := SendCommand( CommandValue.Seek, JsonConvert.SerializeObject( info ) )
			RETURN isOk
	        

		PUBLIC METHOD ChildEnd(info AS XSharp.RDD.Support.DbRelInfo) AS LOGIC
			LOCAL isOk := FALSE AS LOGIC
			//
			isOk := SendCommand( CommandValue.ChildEnd, JsonConvert.SerializeObject( info ) )
			RETURN isOk
	        

		PUBLIC METHOD ChildStart(info AS XSharp.RDD.Support.DbRelInfo) AS LOGIC
			LOCAL isOk := FALSE AS LOGIC
			//
			isOk := SendCommand( CommandValue.ChildStart, JsonConvert.SerializeObject( info ) )
			RETURN isOk
	        

		PUBLIC METHOD ChildSync(info AS XSharp.RDD.Support.DbRelInfo) AS LOGIC
			LOCAL isOk := FALSE AS LOGIC
			//
			isOk := SendCommand( CommandValue.ChildSync, JsonConvert.SerializeObject( info ) )
			RETURN isOk
	        

		PUBLIC METHOD ClearRel() AS LOGIC
			LOCAL isOk := FALSE AS LOGIC
			//
			isOk := SendCommand( CommandValue.ClearRel)
			RETURN isOk
	        

		PUBLIC METHOD ForceRel() AS LOGIC
			LOCAL isOk := FALSE AS LOGIC
			//
			isOk := SendCommand( CommandValue.ForceRel)
			RETURN isOk
	        

		PUBLIC METHOD RelArea(nRelNum AS DWORD) AS DWORD
			LOCAL isOk := FALSE AS LOGIC
			LOCAL reply AS STRING
			LOCAL data := 0 AS DWORD
			//
			reply := RecvCommand( CommandValue.RelArea, JsonConvert.SerializeObject( nRelNum ) , REF isOk )
			IF isOk
				data := JsonConvert.DeserializeObject<DWORD>( reply ) 
			ENDIF
			RETURN data

		PUBLIC METHOD RelEval(info AS XSharp.RDD.Support.DbRelInfo) AS LOGIC
			LOCAL isOk := FALSE AS LOGIC
			//
			isOk := SendCommand( CommandValue.RelEval, JsonConvert.SerializeObject( info ) )
			RETURN isOk
	        

		PUBLIC METHOD RelText(nRelNum AS DWORD) AS STRING
			LOCAL isOk := FALSE AS LOGIC
			LOCAL reply AS STRING
			LOCAL data := NULL AS STRING
			//
			reply := RecvCommand( CommandValue.RelText, JsonConvert.SerializeObject( nRelNum ) , REF isOk )
			IF isOk
				data := JsonConvert.DeserializeObject<STRING>( reply ) 
			ENDIF
			RETURN data
	        

		PUBLIC METHOD SetRel(info AS XSharp.RDD.Support.DbRelInfo) AS LOGIC
			LOCAL isOk := FALSE AS LOGIC
			//
			isOk := SendCommand( CommandValue.SetRel, JsonConvert.SerializeObject( info ) )
			RETURN isOk
	        

		PUBLIC METHOD SyncChildren() AS LOGIC
			LOCAL isOk := FALSE AS LOGIC
			//
			isOk := SendCommand( CommandValue.SyncChildren )
			RETURN isOk
	        

		PUBLIC METHOD Sort(info AS XSharp.RDD.Support.DbSortInfo) AS LOGIC
			LOCAL isOk := FALSE AS LOGIC
			//
			isOk := SendCommand( CommandValue.Sort, JsonConvert.SerializeObject( info ) )
			RETURN isOk
	        

		PUBLIC METHOD Trans(info AS XSharp.RDD.Support.DbTransInfo) AS LOGIC
			LOCAL isOk := FALSE AS LOGIC
			//
			isOk := SendCommand( CommandValue.Trans, JsonConvert.SerializeObject( info ) )
			RETURN isOk
	        

		PUBLIC METHOD TransRec(info AS XSharp.RDD.Support.DbTransInfo) AS LOGIC
			LOCAL isOk := FALSE AS LOGIC
			//
			isOk := SendCommand( CommandValue.TransRec, JsonConvert.SerializeObject( info ) )
			RETURN isOk
	        

		PUBLIC METHOD BlobInfo(uiPos AS DWORD, nOrdinal AS DWORD) AS OBJECT
			LOCAL reply AS STRING
			LOCAL isOk := FALSE AS LOGIC
			LOCAL data := NULL AS OBJECT
			VAR cargo := Tuple<DWORD,DWORD>{ uiPos, nOrdinal}
			//
			reply := RecvCommand( CommandValue.OrderInfo, JsonConvert.SerializeObject( cargo ) , REF isOk )
			IF isOk
				data := JsonConvert.DeserializeObject<OBJECT>( reply ) 
			ENDIF
			RETURN data
	        

		PUBLIC METHOD Compile(sBlock AS STRING) AS XSharp.ICodeblock
			LOCAL isOk := FALSE AS LOGIC
			//
			isOk := SendCommand( CommandValue.Compile, JsonConvert.SerializeObject( sBlock ) )
			RETURN NULL
	        

		PUBLIC METHOD EvalBlock(oBlock AS XSharp.ICodeblock) AS OBJECT
			LOCAL isOk := FALSE AS LOGIC
			//
			isOk := SendCommand( CommandValue.EvalBlock, JsonConvert.SerializeObject( oBlock ) )
			RETURN isOk
	        

		PUBLIC METHOD Info(nOrdinal AS INT, oValue AS OBJECT) AS OBJECT
			LOCAL reply AS STRING
			LOCAL isOk := FALSE AS LOGIC
			LOCAL data := NULL AS OBJECT
			VAR cargo := Tuple<INT,OBJECT>{ nOrdinal, oValue }
			//
			reply := RecvCommand( CommandValue.Info, JsonConvert.SerializeObject( cargo ) , REF isOk )
			IF isOk
				data := JsonConvert.DeserializeObject<OBJECT>( reply ) 
			ENDIF
			RETURN data
	        

		PUBLIC METHOD RecInfo(nOrdinal AS INT, oRecID AS OBJECT, oNewValue AS OBJECT) AS OBJECT
			LOCAL reply AS STRING
			LOCAL isOk := FALSE AS LOGIC
			LOCAL data := NULL AS OBJECT
			VAR cargo := Tuple<INT,OBJECT,OBJECT>{ nOrdinal, oRecID, oNewValue}
			//
			reply := RecvCommand( CommandValue.RecInfo, JsonConvert.SerializeObject( cargo ) , REF isOk )
			IF isOk
				data := JsonConvert.DeserializeObject<OBJECT>( reply ) 
			ENDIF
			RETURN data
	        

		PUBLIC PROPERTY Alias AS STRING
			GET
				RETURN SELF:rddState:Alias
			END GET
			SET
				SELF:rddState:Alias := VALUE
				SELF:updateState := TRUE
			END SET
		END PROPERTY
		PUBLIC PROPERTY Area AS DWORD
			GET
				RETURN SELF:rddState:Area
			END GET
			SET
				SELF:rddState:Area := VALUE
				SELF:updateState := TRUE
			END SET
		END PROPERTY
		PUBLIC PROPERTY BoF AS LOGIC
			GET
				RETURN SELF:rddState:BoF
			END GET
		END PROPERTY
		PUBLIC PROPERTY Deleted AS LOGIC
			GET
				RETURN SELF:rddState:Deleted
			END GET
		END PROPERTY
		PUBLIC PROPERTY Driver AS STRING
			GET
				RETURN SELF:rddState:Driver
			END GET
		END PROPERTY
		PUBLIC PROPERTY EoF AS LOGIC
			GET
				RETURN SELF:rddState:EoF
			END GET
		END PROPERTY
		PUBLIC PROPERTY Exclusive AS LOGIC
			GET
				RETURN SELF:rddState:Exclusive
			END GET
		END PROPERTY
		PUBLIC PROPERTY FieldCount AS INT
			GET
				RETURN SELF:rddState:FieldCount
			END GET
		END PROPERTY
		PUBLIC PROPERTY FilterText AS STRING
			GET
				RETURN SELF:rddState:FilterText
			END GET
		END PROPERTY
		PUBLIC PROPERTY Found AS LOGIC
			GET
				RETURN SELF:rddState:Found
			END GET
			SET
				SELF:rddState:Found := VALUE
				SELF:updateState := TRUE
			END SET
		END PROPERTY
		PUBLIC PROPERTY RecCount AS INT
			GET
				RETURN SELF:rddState:RecCount
			END GET
		END PROPERTY
		PUBLIC PROPERTY RecId AS OBJECT
			GET
				RETURN SELF:rddState:RecId
			END GET
		END PROPERTY
		PUBLIC PROPERTY RecNo AS INT
			GET
				RETURN SELF:rddState:RecNo
			END GET
		END PROPERTY
		PUBLIC PROPERTY Shared AS LOGIC
			GET
				RETURN SELF:rddState:Shared
			END GET
		END PROPERTY
		#endregion
	END CLASS

	/// <summary>
	/// Internal class that represent the current RDD state
	/// </summary>
	PUBLIC CLASS XanthiRDDState
	
		PUBLIC PROPERTY Alias AS STRING AUTO
		PUBLIC PROPERTY Area AS DWORD AUTO
		PUBLIC PROPERTY BoF AS LOGIC AUTO 
		PUBLIC PROPERTY Deleted AS LOGIC AUTO 
		PUBLIC PROPERTY Driver AS STRING AUTO 
		PUBLIC PROPERTY EoF AS LOGIC AUTO 
		PUBLIC PROPERTY Exclusive AS LOGIC AUTO 
		PUBLIC PROPERTY FieldCount AS INT AUTO 
		PUBLIC PROPERTY FilterText AS STRING AUTO 
		PUBLIC PROPERTY Found AS LOGIC AUTO
		PUBLIC PROPERTY RecCount AS INT AUTO 
		PUBLIC PROPERTY RecId AS OBJECT AUTO 
		PUBLIC PROPERTY RecNo AS INT AUTO 
		PUBLIC PROPERTY Shared AS LOGIC AUTO 

		CONSTRUCTOR()
			SELF:EoF := TRUE
			SELF:Bof := TRUE
			SELF:Deleted := TRUE

	END CLASS

	/// <summary>
	/// RDD Command code : MUST be >= 100
	/// </summary>
	ENUM CommandValue
		MEMBER None := 100
		MEMBER DbEval
		MEMBER GoTop
		MEMBER GoBottom
		MEMBER GoTo
		MEMBER GoToId
		MEMBER Skip
		MEMBER SkipFilter
		MEMBER SkipRaw
		MEMBER SkipScope
		MEMBER Append
		MEMBER Delete
		MEMBER GetRec
		MEMBER Pack
		MEMBER PutRec
		MEMBER Recall
		MEMBER Zap
		MEMBER Close
		MEMBER Create
		MEMBER Open
		MEMBER ClearFilter
		MEMBER ClearScope
		MEMBER Continue
		MEMBER GetScope
		MEMBER SetFilter
		MEMBER SetScope
		MEMBER SetFieldExtent
		MEMBER AddField
		MEMBER CreateFields
		MEMBER FieldIndex
		MEMBER FieldInfo
		MEMBER FieldName
		MEMBER FieldGet
		MEMBER GetField
		MEMBER GetValue
		MEMBER GetValueFile
		MEMBER GetValueLength
		MEMBER Flush
		MEMBER GoCold
		MEMBER GoHot
		MEMBER PutValue
		MEMBER PutValueFile
		MEMBER Refresh
		MEMBER AppendLock
		MEMBER HeaderLock
		MEMBER Lock
		MEMBER UnLock
		MEMBER CloseMemFile
		MEMBER CreateMemFile
		MEMBER OpenMemFile
		MEMBER OrderCondition
		MEMBER OrderCreate
		MEMBER OrderDestroy
		MEMBER OrderInfo
		MEMBER OrderListAdd
		MEMBER OrderListDelete
		MEMBER OrderListFocus
		MEMBER OrderListRebuild
		MEMBER Seek
		MEMBER ChildEnd
		MEMBER ChildStart
		MEMBER ChildSync
		MEMBER ClearRel
		MEMBER ForceRel
		MEMBER RelArea
		MEMBER RelEval
		MEMBER RelText
		MEMBER SetRel
		MEMBER SyncChildren
		MEMBER Sort
		MEMBER Trans
		MEMBER TransRec
		MEMBER BlobInfo
		MEMBER Compile
		MEMBER EvalBlock
		MEMBER Info
		MEMBER RecInfo
	END ENUM


END NAMESPACE // XanthiRDD

