pragma SPARK_Mode(On);

with Gnat.Sockets;
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
   Server_Socket_addr : Gnat.Sockets.Sock_Addr_Type;
   Client_Socket : Gnat.Sockets.Socket_Type;
   Client_Socket_addr : Gnat.Sockets.Sock_Addr_Type;
   --Message_Byte_Array : Network_Types.Byte_Array_Type;
   Raw_Request : Measured_Request_Buffer;
   Parsed_Request : Simple_HTTP_Request;
begin
   Put_line("Debugging: About to Init");
   Initialize_TCP_State(Server_Socket, Server_Socket_addr); --        <--- network, non-SPARK stuff

   loop
      Raw_Request.Length := 1;
      Raw_Request.Buffer := (others=>' ');

      --Put_Line("Debugging: Waiting for client cxn...");
      Debug_Print_Ln("Debugging: Waiting for client cxn...");
      --TODO: make server able to accept more than one client, like in CRADLE
      Get_Client_Cxn(Server_Socket, Client_Socket, Client_Socket_addr); --        <--- network, non-SPARK stuff

      Debug_Print_Ln("Debugging: Waiting for client request...");
      Recv_NET_Request(Client_Socket, Raw_Request); --          <--- get string of request, non-SPARK
      Debug_Print_Ln("Debugging: Raw Request:" & Raw_Request.Buffer);

      Parse_HTTP_Request(Raw_Request, Parsed_Request); --         <--- SPARK goes here

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

      Fulfill_HTTP_Request(Client_Socket, Parsed_Request);

      Close_Client_Socket(Client_Socket);
   end loop;

end Masp;
