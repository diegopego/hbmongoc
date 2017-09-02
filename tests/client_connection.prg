/*
 * test: client_connection
 */

#include "hbmongoc.ch"

PROCEDURE main()
    LOCAL uri
    LOCAL client
    LOCAL uriString
    LOCAL commandPing
    LOCAL retVal
    LOCAL reply
    LOCAL error
    LOCAL i

    CLS

    mongoc_init()

    uriString := "mongodb://localhost:27017"

    ? "Uri string:", uriString

    uri := mongoc_uri_new( uriString )

    IF uri = nil
        alert( "URI not valid...")
        QUIT
    ENDIF

    client := mongoc_client_new_from_uri( uri )

    WAIT "Press any key to start ping test..."

//    commandPing := { "ping" => 1 }
//    commandPing := hb_jsonEncode( { "ping" => 1 } )
    commandPing := bson_new()
    BSON_APPEND_INT32( commandPing, "ping", 1 )

    FOR i := 1 TO 1000000
        retVal := mongoc_client_command_simple( client, "admin", commandPing, nil, @reply, @error )

        IF retVal
            ? "Server reply:", i, bson_as_json( reply )
//            ? "Server reply:", i, ( reply )
        ELSE
            ? "Server error:", error
            EXIT
        ENDIF

    NEXT

    WAIT

    mongoc_cleanup()

RETURN
