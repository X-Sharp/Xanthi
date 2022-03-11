USING System
USING System.Collections.Generic
USING System.Linq
USING System.Text
USING System.Windows.Forms

USING XSharp.Rdd.Support

USING XanthiClientTest_Rdd
USING XanthiRdd
USING XanthiCommLib

BEGIN NAMESPACE XanthiClientTest_Rdd

[STAThread] ;
FUNCTION Start() AS VOID
		
    Console.WriteLine("Xanthi Test")
    //
    VAR srvr := ServerInfo{ "127.0.0.1" }
    srvr:User := "Fabrice"
    srvr:Password := "XSharp"
    //
    VAR con := Connection{ srvr }
    con:OpenSession()
    //
    VAR xanthi := XanthiRDD{ con }
    //xanthi:Connection := con
    // Only the filename is used currently
    VAR dbf := DbOpenInfo{ "customer.dbf", "customer", 1, TRUE, TRUE }
    //
		
    IF xanthi:Open( dbf )

        Console.WriteLine( "RecCount : {0}", xanthi:RecCount )
        DO WHILE !xanthi:Eof
        Console.WriteLine( "---------------------")
        Console.WriteLine( "Record {0}", xanthi:RecNo)
        FOR VAR i := 1 TO xanthi:FieldCount
            Console.Write( xanthi:FieldName(i) + " : " )
            Console.WriteLine( xanthi:GetValue( i ) )
        NEXT
        xanthi:Skip(1)
        ENDDO 
    ELSE
        Console.WriteLine( "Cannot open file." )
    ENDIF
		
    Console.WriteLine("Press Return to Close")
    Console.ReadLine()
		
    RETURN
		
    END NAMESPACE
	

