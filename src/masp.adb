pragma SPARK_Mode(On);

with GNAT.Sockets; use GNAT.Sockets;
with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;
with SPARK.Text_IO; use SPARK.Text_IO;

with server; use server;
with Http_Message; use Http_Message;
with parsing; use parsing;
with network_ns; use network_ns;
with Network_Types;
with utils; use utils;
with measured_buffer; use measured_buffer;
with config; use config;
with response_strs; use response_strs;

procedure Masp is
   Server_Socket : Gnat.Sockets.Socket_Type;
   Init_Exception_Raised : Boolean;
   Client_Socket : Gnat.Sockets.Socket_Type;
   Client_Cxn_Exception_Raised : Boolean;
   Raw_Request : Measured_Buffer_Type(MAX_REQUEST_LINE_BYTE_CT, MEASURED_BUFFER_EMPTY_CHAR);
   Client_Request_Exception_Raised : Boolean;
   Parsed_Request : Parsed_HTTP_Request_Type;
   Client_Parse_Exception_Raised : Boolean;
   Canonicalized_Request : Translated_HTTP_Request_Type;
   Clean_Request : Translated_HTTP_Request_Type;
begin
   Debug_Print_Ln("Debugging: About to Init");
   --Debug_Print_Ln("MAX_STATUS_AND_HEADERS_LENGTH: " & Natural'Image(MAX_STATUS_AND_HEADERS_LENGTH));
   Initialize_TCP_State(Server_Socket, Init_Exception_Raised);

   if Init_Exception_Raised then
      Check_Print_Ln("MaSpX: Failure to launch! Couldn't initialized network state.");
      return;
   end if;

   loop
      Clear(Raw_Request);

      Debug_Print_Ln(LF & LF & LF & "Debugging: Waiting for client cxn...");

      --TODO:ltj: make server able to accept more than one client, like in CRADLE? Probably needed for Connection:Keep-Alive
      Get_Client_Cxn(Server_Socket, Client_Socket, Client_Cxn_Exception_Raised);

      if not Client_Cxn_Exception_Raised then
         Debug_Print_Ln("Debugging: Waiting for client request...");
         Recv_NET_Request(Client_Socket, Raw_Request, Client_Request_Exception_Raised);

         if not Client_Request_Exception_Raised then
            Debug_Print_Ln("Debugging: Raw Request:" & Get_String(Raw_Request));

            Parse_HTTP_Request(Client_Socket, Raw_Request, Parsed_Request, Client_Parse_Exception_Raised);

            if not Client_Parse_Exception_Raised then

               if Parsed_Request.URI.Length >= 1 then
                  Canonicalize_HTTP_Request(Parsed_Request, Canonicalized_Request); --interpret all ..'s and .'s.

                  if Canonicalized_Request.Canonicalized then

                     Sanitize_HTTP_Request(Client_Socket, Canonicalized_Request, Clean_Request);

                     if Clean_Request.Sanitary then
                        Fulfill_HTTP_Request(Client_Socket, Clean_Request);
                     end if;

                  end if;
               end if;
            end if;
         end if;

         Close_Client_Socket(Client_Socket);
      end if;
   end loop;

end Masp;
