// ServerInfo.prg
// Created by    : fabri
// Creation Date : 2/19/2022 6:41:13 PM
// Created for   : 
// WorkStation   : FABXPS


USING System
USING System.Collections.Generic
USING System.Text
USING System.NET

BEGIN NAMESPACE XanthiCommLib

	/// <summary>
	/// Server Informations
	/// </summary>
	CLASS ServerInfo

		PROPERTY Port AS INT GET SELF:EndPoint:Port SET SELF:EndPoint:Port := VALUE

		PROPERTY ReadTimeOut AS INT AUTO

		PROPERTY Address AS System.Net.IPAddress GET SELF:EndPoint:Address SET SELF:EndPoint:Address := VALUE

		PROPERTY EndPoint AS System.Net.IPEndPoint AUTO

		PROPERTY User AS STRING AUTO
		PROPERTY Password AS STRING AUTO

		CONSTRUCTOR()
			SELF:EndPoint := System.Net.IPEndPoint{ IPAddress.Loopback , 12345 }
			SELF:ReadTimeOut := 10000

		CONSTRUCTOR( ep AS System.Net.IPEndPoint, timeOut := 10000 AS INT )
			SELF:EndPoint := ep
			SELF:ReadTimeOut := timeOut

		CONSTRUCTOR( remoteHost AS STRING, port := 12345 AS LONG, timeOut := 10000 AS INT, u := NULL AS STRING, p := NULL AS STRING )
			SELF:EndPoint := IPEndPoint{ IPAddress.Parse(remoteHost), port}
			SELF:ReadTimeOut := timeOut
			SELF:User := u
			SELF:Password := p

	END CLASS

END NAMESPACE // XanthiCommLib