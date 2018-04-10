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

procedure Masp is
   Server_Socket : Gnat.Sockets.Socket_Type;
   Init_Exception_Raised : Boolean;
   Client_Socket : Gnat.Sockets.Socket_Type;
   Client_Cxn_Exception_Raised : Boolean;
   Raw_Request : Measured_Buffer_Type(MAX_REQUEST_LINE_BYTE_CT, NUL);
   Client_Request_Exception_Raised : Boolean;
   Parsed_Request : Parsed_Simple_Request;
   Client_Parse_Exception_Raised : Boolean;
   Canonicalized_Request : Translated_Simple_Request;
   Clean_Request : Translated_Simple_Request;
begin
   Debug_Print_Ln("Debugging: About to Init");
   Initialize_TCP_State(Server_Socket, Init_Exception_Raised);

   if Init_Exception_Raised then
      Check_Print_Ln("MaSpX: Failure to launch!");
      return;
   end if;

   loop
      Clear(Raw_Request);

      Debug_Print_Ln(LF & LF & LF & "Debugging: Waiting for client cxn...");

      --TODO:ltj: make server able to accept more than one client, like in CRADLE?
      Get_Client_Cxn(Server_Socket, Client_Socket, Client_Cxn_Exception_Raised);

      if not Client_Cxn_Exception_Raised then
         Debug_Print_Ln("Debugging: Waiting for client request...");
         Recv_NET_Request(Client_Socket, Raw_Request, Client_Request_Exception_Raised);

         if not Client_Request_Exception_Raised then
            Debug_Print_Ln("Debugging: Raw Request:" & Get_String(Raw_Request));

            Parse_HTTP_Request(Client_Socket, Raw_Request, Parsed_Request, Client_Parse_Exception_Raised);

            if not Client_Parse_Exception_Raised then
               --debug: print Parsed_Request
               case Parsed_Request.Method is
               when Http_Message.GET =>
                  Debug_Print_Ln("Debugging: Parsed METHOD: GET");
               when Http_Message.UNKNOWN =>
                  Debug_Print_Ln("Debugging: Parsed METHOD: UNKNOWN");
               when others =>
                  Debug_Print_Ln("Debugging: Parsed METHOD:");
               end case;
               Debug_Print_Ln("Debugging: Parsed URI:" & Get_String(Parsed_Request.URI));

               Canonicalize_HTTP_Request(Parsed_Request, Canonicalized_Request); --interpret all ..'s and .'s.

               if Canonicalized_Request.Canonicalized then

                  Sanitize_HTTP_Request(Client_Socket, Canonicalized_Request, Clean_Request);

                  if Clean_Request.Sanitary then
                     Fulfill_HTTP_Request(Client_Socket, Clean_Request);
                  end if;

               end if;
            end if;
         end if;

         Close_Client_Socket(Client_Socket);
      end if;
   end loop;

end Masp;
