pragma SPARK_Mode(On);

with Gnat.Sockets; use Gnat.Sockets;
with SPARK.Text_IO; use SPARK.Text_IO;
with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;

with fileio_ns; use fileio_ns;
with Http_Message; use Http_Message;
with network_ns; use network_ns;
with config; use config;
with utils; use utils;
with String_Types; use String_Types;
with measured_buffer; use measured_buffer;
with parsing; use parsing;
with error; use error;
with Http_Message; use Http_Message;

package server is

   procedure Canonicalize_HTTP_Request(
      Parsed_Request : Parsed_HTTP_Request_Type;
      Canonicalized_Request : out Translated_HTTP_Request_Type
   )
   with Global => (In_Out => Standard_Output),
        Pre =>  Parsed_Request.URI.Length <= Parsed_Request.URI.Max_Size and
                Parsed_Request.URI.Length >= 1,
        Post => Canonicalized_Request.Path.Length <= Canonicalized_Request.Path.Max_Size;

   procedure Sanitize_HTTP_Request(
      Client_Socket : Socket_Type;
      Canonicalized_Request : Translated_HTTP_Request_Type;
      Clean_Request : out Translated_HTTP_Request_Type
   )
   with Global => null,
        Pre =>  Canonicalized_Request.Path.Length <= Canonicalized_Request.Path.Max_Size and
                Canonicalized_Request.Canonicalized = True,
        Post => Clean_Request.Path.Length <= Clean_Request.Path.Max_Size;

   procedure Fulfill_HTTP_Request(
      Client_Socket : Socket_Type;
      Clean_Request : Translated_HTTP_Request_Type
   )
   with Global => null,
        Pre => Clean_Request.Path.Length <= Clean_Request.Path.Max_Size and
               Clean_Request.Sanitary;

end server;
