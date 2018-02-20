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
      C : String(1 .. 1);
   begin
      Client_Stream := Gnat.Sockets.Stream(Client_Socket);
      
      loop
         String'Read(Client_Stream, C); --TODO-SEC:what happens when non-ASCII character (control char is encountered)
                                                 --http/0.9 request line *should* be all printable ascii, but of course, we've got to test violations of the standard
         if C = " " then
            SP_ct := SP_ct + 1;
         end if;
         
         --stop after two tokens, as all http/0.9 cares about is GET and URI
         if SP_ct = 2 then
            exit;
         end if;
         
         Request.Buffer(C_ct) := C(1);  --TODO-SEC:what happens when network input is longer than String_Request? Crash probably. Fix by exiting loop when capacity reached.
         Request.Length := C_ct;
         
         C_ct := C_ct + 1;
      
      end loop;
   end Recv_NET_Request;
   
   -----------------------------------------------------------------------------
   procedure Send_TEST_Response(
      Client_Socket : Gnat.Sockets.Socket_Type)
      --Message_Byte_Array : Network_Types.Byte_Array_Type)
   is
      Client_Stream : Gnat.Sockets.Stream_Access;
      --Message_Stream_Array : Ada.Streams.Stream_Element_Array (1 .. Ada.Streams.Stream_Element_Offset(Network_Types.MAX_HTTP_MSG_LENGTH));
      --for Message_Stream_Array'Address use Message_Byte_Array'Address;
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
end network_ns;
