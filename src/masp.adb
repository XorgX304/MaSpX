pragma SPARK_Mode(On);

with GNAT.Sockets; use GNAT.Sockets;
with Ada.Characters.Latin_1;
with SPARK.Text_IO; use SPARK.Text_IO;

with server; use server;
with Http_Message; use Http_Message;
with parsing; use parsing;
with network_ns; use network_ns;
with Network_Types;
with utils_ns;
with utils; use utils;

procedure Masp is
   Server_Socket : Gnat.Sockets.Socket_Type;
   Init_Exception_Raised : Boolean;
   Client_Socket : Gnat.Sockets.Socket_Type;
   Client_Cxn_Exception_Raised : Boolean;
   --Message_Byte_Array : Network_Types.Byte_Array_Type;
   Raw_Request : Measured_Request_Buffer;
   Client_Request_Exception_Raised : Boolean;
   Parsed_Request : Simple_HTTP_Request;
begin
   Debug_Print_Ln("Debugging: About to Init");
   Initialize_TCP_State(Server_Socket, Init_Exception_Raised); --        <--- network, non-SPARK stuff

   if Init_Exception_Raised then
      Check_Print_Ln("MaSpX: Failure to launch!");
      return;
   end if;

   loop
      Raw_Request.Length := 1;
      Raw_Request.Buffer := (others=>' ');

      Debug_Print_Ln("Debugging: Waiting for client cxn...");
      --TODO:ltj: make server able to accept more than one client, like in CRADLE
      Get_Client_Cxn(Server_Socket, Client_Socket, Client_Cxn_Exception_Raised); --        <--- network, non-SPARK stuff

      if not Client_Cxn_Exception_Raised then
         Debug_Print_Ln("Debugging: Waiting for client request...");
         Recv_NET_Request(Client_Socket, Raw_Request, Client_Request_Exception_Raised); --          <--- get string of request, non-SPARK

         if not Client_Request_Exception_Raised then
            Debug_Print_Ln("Debugging: Raw Request:" & Raw_Request.Buffer);

            Parse_HTTP_Request(Raw_Request, Parsed_Request); --         <--- SPARK

            --debug: print Parsed_Request
            case Parsed_Request.Method is
            when Http_Message.GET =>
               Debug_Print_Ln("Debugging: Parsed METHOD: GET");
            when Http_Message.UNKNOWN =>
               Debug_Print_Ln("Debugging: Parsed METHOD: UNKNOWN");
            when others =>
               Debug_Print_Ln("Debugging: Parsed METHOD:");
            end case;
            Debug_Print_Ln("Debugging: Parsed URI:" & Parsed_Request.RequestURI);

            --TODO:ltj: Canonicalize_HTTP_Request --interpret all ..'s and .'s. remove extra slashes, or throw error on them

            --TODO:ltj: Sanitize_HTTP_Request --be wary of directory traversal attacks

            Fulfill_HTTP_Request(Client_Socket, Parsed_Request);  --           <-- SPARK
         end if;

         Close_Client_Socket(Client_Socket); --                <--- Non-SPARK
      end if;
   end loop;

end Masp;
