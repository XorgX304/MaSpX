pragma SPARK_Mode(On);

with Gnat.Sockets; use Gnat.Sockets;
with SPARK.Text_IO; use SPARK.Text_IO;

with fileio; use fileio;
with Http_Message; use Http_Message;
with network_ns; use network_ns;
with config; use config;
with utils; use utils;
with String_Types; use String_Types;

package server is

   procedure Canonicalize_HTTP_Request(
      Parsed_Request : Simple_HTTP_Request;
      Canonicalized_Request : out Simple_HTTP_Request
   );

   procedure Sanitize_HTTP_Request(
      Canonicalized_Request : Simple_HTTP_Request;
      Clean_Request : out Simple_HTTP_Request
   );

   procedure Fulfill_HTTP_Request(
      Client_Socket : Socket_Type;
      Clean_Request : Simple_HTTP_Request
   );

end server;
