// CommTools.prg
// Created by    : fabri
// Creation Date : 9/13/2021 10:47:11 AM
// Created for   : 
// WorkStation   : FABXPS


USING System
USING System.Collections.Generic
USING System.Text
USING System.Net
USING System.Net.Sockets

BEGIN NAMESPACE XanthiCommLib

	/// <summary>
	/// The CommTools class.
	/// </summary>
	STATIC CLASS CommTools
	
		STATIC METHOD RetrieveAllIP() AS List<STRING>
			LOCAL host AS IPHostEntry
			LOCAL localIP AS STRING
			VAR IPs := List<STRING>{}
			// Add Loopback as first address
			IPs:Add("127.0.0.1")
			//
			host := Dns.GetHostEntry(Dns.GetHostName())
			FOREACH ip AS IPAddress IN host:AddressList
				IF(ip:AddressFamily== AddressFamily.InterNetwork)
					localip := ip.ToString()
					IPs.Add(localip)
				ENDIF
			NEXT
		RETURN IPs
		
	END CLASS



END NAMESPACE // XanthiCommLib