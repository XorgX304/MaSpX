pragma SPARK_Mode(On);

with Gnat.Sockets; use Gnat.Sockets;
with SPARK.Text_IO; use SPARK.Text_IO;
with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;

with fileio; use fileio;
with Http_Message; use Http_Message;
with network_ns; use network_ns;
with config; use config;
with utils; use utils;
with String_Types; use String_Types;
with measured_buffer; use measured_buffer;
with parsing; use parsing;

package server is

   procedure Canonicalize_HTTP_Request(
      Parsed_Request : Parsed_Simple_Request;
      Canonicalized_Request : out Translated_Simple_Request
   )
   with Global => (In_Out => Standard_Output),
        Pre =>  Parsed_Request.URI.Length <= Parsed_Request.URI.Size,
        Post => Canonicalized_Request.Path.Length <= Canonicalized_Request.Path.Size and
                Canonicalized_Request.Canonicalized = True;

   procedure Sanitize_HTTP_Request(
      Client_Socket : Socket_Type;
      Canonicalized_Request : Translated_Simple_Request;
      Clean_Request : out Translated_Simple_Request
   )
   with Global => null,
        Pre =>  Canonicalized_Request.Path.Length <= Canonicalized_Request.Path.Size and
                Canonicalized_Request.Canonicalized = True,
        Post => Clean_Request.Path.Length <= Clean_Request.Path.Size;

   procedure Fulfill_HTTP_Request(
      Client_Socket : Socket_Type;
      Clean_Request : Translated_Simple_Request
   )
   with Global => (In_Out => Standard_Output),
        Pre => Clean_Request.Path.Length <= Clean_Request.Path.Size and
               Clean_Request.Sanitary;

end server;
