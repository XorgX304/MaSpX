with Gnat.Sockets;
with Ada.Exceptions;
with Ada.Text_IO;
with Ada.IO_Exceptions;
with Ada.Characters;
with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;
with Ada.Streams;
with SPARK.Text_IO; use SPARK.Text_IO;

with network_types; use Network_Types;
with Http_Message; use Http_Message;
with config; use config;
with utils; use utils;
with measured_buffer; use measured_buffer;
with error; use error;
with response_strs; use response_strs;

package network_ns 
with SPARK_Mode => On
is

   STATIC_TEST_RESPONSE_09 : constant String := "Hello World! My payload includes a trailing CRLF." & CR & LF;
   
   --ltj: constant tokens for parsing aid
   GET_TOKEN_STR : constant String := "GET";
   HEAD_TOKEN_STR : constant String := "HEAD";
   POST_TOKEN_STR : constant String := "POST";

   procedure Initialize_TCP_State(
      Server_Socket : out Gnat.Sockets.Socket_Type;
      Exception_Raised : out Boolean
   );
   
   procedure Get_Client_Cxn(
      Server_Socket : Gnat.Sockets.Socket_Type;
      Client_Socket : out Gnat.Sockets.Socket_Type;
      Exception_Raised : out Boolean
   );
   
   procedure Recv_NET_Request(
      Client_Socket : Gnat.Sockets.Socket_Type;
      Request : out Measured_Buffer_Type;
      Exception_Raised : out Boolean
   )
   with Global => (In_Out => Standard_Output),
        Post => (if not Exception_Raised then
                    not Is_Empty(Request) and Request.Length <= Request.Size);
   
   procedure Send_HTTP_Response(
      Client_Socket : Gnat.Sockets.Socket_Type;
      Response : HTTP_Response_Type
   );
   
   procedure Close_Client_Socket(
      Client_Socket : GNAT.Sockets.Socket_Type
   );

end network_ns;
