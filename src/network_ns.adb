pragma SPARK_Mode(Off);

package body network_ns is

   procedure Initialize_TCP_State(
      Server_Socket : out Gnat.Sockets.Socket_Type;
      Exception_Raised : out Boolean)
   is
      Server_Socket_Addr : Gnat.Sockets.Sock_Addr_Type;
   begin
      Exception_Raised := False;
      Server_Socket := Gnat.Sockets.No_Socket;
      Server_Socket_Addr := Gnat.Sockets.No_Sock_Addr;
   
      -- create the socket which will used for all http traffic
      Gnat.Sockets.Create_Socket(
         Socket => Server_Socket,
         Family => Gnat.Sockets.Family_Inet,
         Mode   => Gnat.Sockets.Socket_Stream);

      -- Allow socket to be bound to address already in use
      --commented out in Ironsides
      --Gnat.Sockets.Set_Socket_Option(Server_HTTP_Socket,
      --   Gnat.Sockets.Socket_Level, (Gnat.Sockets.Reuse_Address, True));

      -- bind the socket to the first IP address on localhost, http port 80
      Server_Socket_Addr.Addr := Gnat.Sockets.ANY_INET_ADDR;
      Server_Socket_Addr.Port := Gnat.Sockets.Port_Type(HTTP_PORT);
      Gnat.Sockets.Bind_Socket(Server_Socket, Server_Socket_Addr);

      --now ready to accept connections
      Gnat.Sockets.Listen_Socket(Socket => Server_Socket, Length => MAX_CXNS);  -- allow MAX_CXNS queued connections

      --if any of the above operations fail
      exception
         --ltj: we're expecting some possible socket error issues.
         when E : GNAT.Sockets.Socket_Error =>
            Ada.Text_IO.Put_Line(Ada.Exceptions.Exception_Name(E) & ":  " & Ada.Exceptions.Exception_Message(E));
            Exception_Raised := True;
         when E : others =>
            Ada.Text_IO.Put_Line("MaSpX: network_ns.adb: Initialize_TCP_State: WARNING, UNEXPECTED TYPE OF EXCEPTION");
            Ada.Text_IO.Put_Line(Ada.Exceptions.Exception_Name(E) & ":  " & Ada.Exceptions.Exception_Message(E));
            Exception_Raised := True;
   end Initialize_TCP_State;
   
   -----------------------------------------------------------------------------
   procedure Get_Client_Cxn(
      Server_Socket : Gnat.Sockets.Socket_Type;
      Client_Socket : out Gnat.Sockets.Socket_Type;
      Exception_Raised : out Boolean)
   is
      Client_Socket_Addr : Gnat.Sockets.Sock_Addr_Type;
   begin
      Exception_Raised := False;
      Client_Socket := GNAT.Sockets.No_Socket;
      Client_Socket_Addr := GNAT.Sockets.No_Sock_Addr;
   
      --establishes connection
      Gnat.Sockets.Accept_Socket(
         Server_Socket, Client_Socket, Client_Socket_Addr);
         
      --TODO: add timeout to socket here
      --Socket_Timeout.Set_Socket_Timeout(
         --Socket => Convert(Socket),
        -- Milliseconds => Socket_Timeout_Milliseconds);
      exception
         when E : GNAT.Sockets.Socket_Error =>
            Ada.Text_IO.Put_Line(Ada.Exceptions.Exception_Name(E) & ":  " & Ada.Exceptions.Exception_Message(E));
            Exception_Raised := True;
         when E : others =>
            Ada.Text_IO.Put_Line("MaSpX: network_ns.adb: Get_Client_Cxn: WARNING, UNEXPECTED TYPE OF EXCEPTION");
            Ada.Text_IO.Put_Line(Ada.Exceptions.Exception_Name(E) & ":  " & Ada.Exceptions.Exception_Message(E));
            Exception_Raised := True;
   end Get_Client_Cxn;
   
   -----------------------------------------------------------------------------
   procedure Recv_NET_Request(
      Client_Socket : Gnat.Sockets.Socket_Type;
      Request : out Measured_Buffer_Type;
      Exception_Raised : out Boolean)
   is
      Client_Stream : Gnat.Sockets.Stream_Access;
      SP_ct : Natural := 0;  --space count
      C_ct : Positive := 1; --character count
      Prev_C : String (1 .. 1);
      C : String(1 .. 1);
      Response : Simple_HTTP_Response;
   begin
      Exception_Raised := False;
      Prev_C(1) := NUL;
      Client_Stream := Gnat.Sockets.Stream(Client_Socket);
      
      loop
         if not Is_Full(Request) then
            String'Read(Client_Stream, C); --TODO-PERF:ltj: can C be a bigger buffer???
            
            if C(1) = Request.EmptyChar then
               Debug_Print_Ln("Invalid character entered! Sending 400 Bad Request");
               Response := Construct_Simple_HTTP_Response(c400_BAD_REQUEST_PAGE);
               Send_Simple_Response(Client_Socket, Response);
               Exception_Raised := True;
               return;
            end if;
               
            Append(Request, C(1));   
         
            case C(1) is
            when CR =>
               Ada.Text_IO.Put("\r");
            when LF =>
               Ada.Text_IO.Put("\n");
            when others =>
               Ada.Text_IO.Put(C);
            end case;
         
            --TODO:ltj: make server well-behaved. According to this: https://www.w3.org/Protocols/HTTP/AsImplemented.html a well behaved server does not require the carriage return character.
            if C(1) = LF and Prev_C(1) = CR then --this only works for Simple-Request, other versions of HTTP will be multi-line
               exit;
            end if;
            
            Prev_C := C;
         else
            Debug_Print_Ln("Max request buffer exceeded! Sending 400 Bad Request");
            Response := Construct_Simple_HTTP_Response(c400_BAD_REQUEST_PAGE);
            Send_Simple_Response(Client_Socket, Response);
            Exception_Raised := True;
            return;
         end if;
      end loop;
      
      exception
         when E : Ada.IO_Exceptions.End_Error =>
            Ada.Text_IO.Put_Line(Ada.Exceptions.Exception_Name(E) & ":  " & Ada.Exceptions.Exception_Message(E));
            Exception_Raised := True;
         when E : others =>
            Ada.Text_IO.Put_Line("MaSpX: network_ns.adb: Recv_NET_Request: WARNING, UNEXPECTED TYPE OF EXCEPTION");
            Ada.Text_IO.Put_Line(Ada.Exceptions.Exception_Name(E) & ":  " & Ada.Exceptions.Exception_Message(E));
            Exception_Raised := True;
   end Recv_NET_Request;
   
   -----------------------------------------------------------------------------
   procedure Send_TEST_Response(
      Client_Socket : Gnat.Sockets.Socket_Type)
      --Message_Byte_Array : Network_Types.Byte_Array_Type)
   is
      Client_Stream : Gnat.Sockets.Stream_Access;
      --Message_Stream_Array : Ada.Streams.Stream_Element_Array (1 .. Ada.Streams.Stream_Element_Offset(Network_Types.MAX_HTTP_MSG_LENGTH));
      --for Message_Stream_Array'Address use Message_Byte_Array'Address;2
      --Result_Last : Ada.Streams.Stream_Element_Offset;
   begin
      Client_Stream := Gnat.Sockets.Stream(Client_Socket);
      
      String'Write(Client_Stream, STATIC_TEST_RESPONSE_11);
      --Gnat.Sockets.Send_Socket(Client_Socket, Message_Stream_Array, Result_Last);
      
      --This introduces erratic behavior in Chrome... but apparently it's not the only cause
      --One Request One Response is HTTP/0.9/1.0
      --Gnat.Sockets.Shutdown_Socket(Client_Socket);
   end Send_TEST_Response;
   
   -----------------------------------------------------------------------------
   procedure Send_Simple_Response(
      Client_Socket : Gnat.Sockets.Socket_Type;
      Response : Simple_HTTP_Response)
   is  --TODO:ltj: make constant for 2. Like CR_Length + LF_Length or Line_Ending_Length to put it in one.
      Send_String : String(1 .. (STATIC_RESPONSE_HEADER_09'Length + STATIC_RESPONSE_CONTENT_LENGTH_HEADER_09'Length + ContentSize'Image(Response.Content_Length)'Length + 2 + STATIC_RESPONSE_ACCEPT_RANGES_HEADER_09'Length + 2 + STATIC_RESPONSE_CONTENT_TYPE_09'Length + 10 + 2 + 2 + Response.Content_Length));
      Client_Stream : Gnat.Sockets.Stream_Access;
   begin
      Client_Stream := Gnat.Sockets.Stream(Client_Socket);
   
      if Response.Content_Type = JPG then
         Send_String := STATIC_RESPONSE_HEADER_09 & 
                        STATIC_RESPONSE_CONTENT_LENGTH_HEADER_09 & ContentSize'Image(Response.Content_Length) & CR & LF &
                        STATIC_RESPONSE_ACCEPT_RANGES_HEADER_09 & CR & LF &
                        STATIC_RESPONSE_CONTENT_TYPE_09 & "image/jpeg" & CR & LF &
                        CR & LF &
                        Response.Entity_Body(1 .. Response.Content_Length);
      else
         Send_String := STATIC_RESPONSE_HEADER_09 & 
                        STATIC_RESPONSE_CONTENT_LENGTH_HEADER_09 & ContentSize'Image(Response.Content_Length) & CR & LF &
                        STATIC_RESPONSE_ACCEPT_RANGES_HEADER_09 & CR & LF &
                        STATIC_RESPONSE_CONTENT_TYPE_09 & "text/html " & CR & LF &
                        CR & LF &
                        Response.Entity_Body(1 .. Response.Content_Length);
      end if;
      
      --TODO:ltj: add exception handling...
      String'Write(Client_Stream, Send_String);
   end Send_Simple_Response;
   
   -----------------------------------------------------------------------------
   procedure Close_Client_Socket(
      Client_Socket : GNAT.Sockets.Socket_Type)
   is
   begin
      --the Shutdown on Write flushes the stream, apparently.
      GNAT.Sockets.Shutdown_Socket(Client_Socket, GNAT.Sockets.Shut_Write);
      GNAT.Sockets.Close_Socket(Client_Socket);
   end Close_Client_Socket;
   
end network_ns;
