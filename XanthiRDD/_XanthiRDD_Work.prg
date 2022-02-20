// FabRDD.prg
// Created by    : fabri
// Creation Date : 9/9/2021 10:34:11 AM
// Created for   : 
// WorkStation   : FABXPS

/*

USING System
USING System.Collections.Generic
USING System.Text
USING XanthiCommLib
USING System.Diagnostics
USING XSharp.RDD
USING XSharp.RDD.Support
USING System.IO

BEGIN NAMESPACE XanthiRDD

	/// <summary>
	/// The XanthiRDD class.
	/// </summary>
	[DebuggerDisplay("XanthiRDD ({Alias,nq})")];
		CLASS XanthiRDD_Work INHERIT Workarea
		#region Fields
		PRIVATE  _aRlocks AS DWORD[]
		INTERNAL _Encoding AS System.Text.Encoding
		INTERNAL _Connection AS XanthiConnection
			INTERNAL _fieldCount AS LONG
			INTERNAL _Recno AS INT
			INTERNAL _Reccount AS INT
				
		#endregion
		
		PROPERTY Connection AS XanthiConnection GET SELF:_Connection SET SELF:_Connection := VALUE
		
		/// <summary>Create instande of RDD </summary>
		CONSTRUCTOR()
			SUPER()
			SELF:_Connection := NULL
			RETURN
		
		/// <inheritdoc />
		VIRTUAL METHOD Open(info AS DbOpenInfo) AS LOGIC
			LOCAL alias AS STRING
			LOCAL fileName AS STRING
			LOCAL tries := 0 AS INT
			LOCAL result AS LOGIC
			//
			IF SELF:_Connection == NULL
				RETURN FALSE
			ENDIF
			alias := Path.GetFileNameWithoutExtension(info:Alias)
			fileName := info:FileName 
			IF alias:Length > 10
				alias := String.Empty
			ENDIF
			// TimeOut set at 1000ms
			SELF:_Connection:TimeOut := 1000
			REPEAT
				// wait 1000 ms before retrying
				tries += 1
				result := SELF:_Connection:OpenTable( fileName )
			UNTIL tries == 10 .OR. result
			IF !result
				NetErr(TRUE)
				SELF:Close()
				SELF:_FileName := fileName
				// TODO Set Error to  ERDD_OPEN_FILE, EG_OPEN, "Open"
				RETURN FALSE
			ENDIF
			IF !SELF:_FieldSub()
				SELF:Close()
				RETURN FALSE
			ENDIF
			SELF:Alias   := info:Alias
			SELF:Area    := info:Workarea
		RETURN TRUE
		
		PROTECTED METHOD _FieldSub() AS LOGIC
			//
			SUPER:CreateFields( SELF:_Connection:_Fields:ToArray() )
		RETURN TRUE
		
		
		PROPERTY RecNo AS LONG GET (LONG) SELF:_RecNo
		PROPERTY RecCount AS LONG GET (LONG) SELF:_RecCount
		
		METHOD Close( ) AS LOGIC
			RETURN SELF:_Connection:Close()
		
		VIRTUAL METHOD GoBottom() AS LOGIC
			// 
			
		RETURN SELF:_Connection:GoBottom()
		
		/// <inheritdoc />
		VIRTUAL METHOD GoTop() AS LOGIC
			// 
		RETURN	SELF:_Connection:GoTop()
		
		VIRTUAL METHOD GoTo(lRec AS LONG) AS LOGIC
			LOCAL states AS List<STRING> 
			LOCAL recordnum AS INT 
			states := List<STRING>{}
			IF SELF:_Connection:GetStates( states ) .AND. states:Count >= 4
				recordnum := Convert.ToInt32(states[3])
				IF recordnum == lRec
						//SUPER:BoF := (String.Compare(states[0],"true",TRUE)==0)
						//SUPER:EoF := (String.Compare(states[1],"true",TRUE)==0)
					//SUPER:_Found := (String.Compare(states[2],"true",TRUE)==0)
					// Write
					// Refresh
				ELSE
					SELF:_Connection:Goto( lRec )
				ENDIF
			ENDIF
		RETURN SELF:RecordMovement()
		
		VIRTUAL METHOD Skip(lCount AS LONG) AS LOGIC
			IF lCount == 0
				// Refresh Record
			ELSE
				SELF:_Connection:Skip( lCount )
			ENDIF
			VAR flag := SELF:RecordMovement()
			IF lCount > 0
				SUPER:BoF := FALSE
				RETURN flag
			ENDIF
			IF lCount < 0
				SUPER:_EoF := FALSE
			ENDIF
		RETURN flag

		METHOD GetValue(nFldPos AS INT) AS OBJECT
		RETURN SELF:_Connection:FieldGet( nFldPos )


	END CLASS
END NAMESPACE // XanthiCommLib

*/