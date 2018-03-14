pragma SPARK_Mode(Off);

package body network_ns is

   procedure Initialize_TCP_State(
      Server_Socket : out Gnat.Sockets.Socket_Type;
      Server_Socket_Addr : out Gnat.Sockets.Sock_Addr_Type)
   is
   begin
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
      Gnat.Sockets.Listen_Socket(Socket => Server_Socket, Length => MAX_CXNS);  -- allow 16 queued connections

      --if any of the above operations fail
      exception
         when E : others =>
            Ada.Text_IO.Put_Line(Ada.Exceptions.Exception_Name(E) & ":  " & Ada.Exceptions.Exception_Message(E));
   end Initialize_TCP_State;
   
   -----------------------------------------------------------------------------
   procedure Get_Client_Cxn(
      Server_Socket : Gnat.Sockets.Socket_Type;
      Client_Socket : out Gnat.Sockets.Socket_Type;
      Client_Socket_Addr : out Gnat.Sockets.Sock_Addr_Type)
   is
   begin
      Client_Socket := GNAT.Sockets.No_Socket;
      Client_Socket_Addr := GNAT.Sockets.No_Sock_Addr;
   
      --establishes connection
      Gnat.Sockets.Accept_Socket(
         Server_Socket, Client_Socket, Client_Socket_Addr);
         
      --TODO: add timeout to socket here
      --Socket_Timeout.Set_Socket_Timeout(
         --Socket => Convert(Socket),
        -- Milliseconds => Socket_Timeout_Milliseconds);
   end Get_Client_Cxn;
   
   -----------------------------------------------------------------------------
   procedure Recv_NET_Request(
      Client_Socket : Gnat.Sockets.Socket_Type;
      Request : out Measured_Request_Buffer)
   is
      Client_Stream : Gnat.Sockets.Stream_Access;
      SP_ct : Natural := 0;  --space count
      C_ct : Positive := 1; --character count
      Prev_C : String (1 .. 1);
      C : String(1 .. 1);
   begin
      Prev_C(1) := NUL;
      Client_Stream := Gnat.Sockets.Stream(Client_Socket);
      
      loop
         String'Read(Client_Stream, C); --TODO-SEC:what happens when non-ASCII character (control char is encountered) or when longer than 259??
                                                 --http/0.9 request line *should* be all printable ascii, but of course, we've got to test violations of the standard        
         Request.Buffer(C_ct) := C(1);  --TODO-SEC:what happens when network input is longer than String_Request? Crash probably. Fix by exiting loop when capacity reached.
         Request.Length := C_ct;
         
         C_ct := C_ct + 1;
         
         case C(1) is
            when CR =>
               Ada.Text_IO.Put("\r");
            when LF =>
               Ada.Text_IO.Put("\n");
            when others =>
               Ada.Text_IO.Put(C);
         end case;
         
         if C(1) = LF and Prev_C(1) = CR then --this only works for Simple-Request, other versions of HTTP will be multi-line
            exit;
         end if;
            
         Prev_C := C;
      end loop;
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
   is
      Send_String : String(1 .. (STATIC_RESPONSE_HEADER_09'Length + STATIC_RESPONSE_CONTENT_LENGTH_HEADER_09'Length + ContentSize'Image(Response.Content_Length)'Length + 2 + 2 + Response.Content_Length));
      Client_Stream : Gnat.Sockets.Stream_Access;
   begin
      Client_Stream := Gnat.Sockets.Stream(Client_Socket);
   
      Send_String := STATIC_RESPONSE_HEADER_09 & 
                     STATIC_RESPONSE_CONTENT_LENGTH_HEADER_09 & ContentSize'Image(Response.Content_Length) & CR & LF &
                     CR & LF &
                     Response.Entity_Body(1 .. Response.Content_Length);
   
      String'Write(Client_Stream, Send_String);
   end Send_Simple_Response;
   
   -----------------------------------------------------------------------------
   procedure Close_Client_Socket(
      Client_Socket : GNAT.Sockets.Socket_Type)
   is
   begin
      GNAT.Sockets.Close_Socket(Client_Socket);
   end Close_Client_Socket;
end network_ns;
