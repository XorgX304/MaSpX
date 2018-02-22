pragma SPARK_Mode(On);

with SPARK.Text_IO; use SPARK.Text_IO;

with network_ns; use network_ns;
with Http_Message; use Http_Message;

--TODO: SPARKify
package parsing is

   --Start and Finish are inclusive
   procedure Get_First_Token_In_Range(
      Source : Request_Line;
      Delimit : Character;
      Start : Positive;
      Finish : Positive;
      Token : out Measured_Request_Buffer
   )
   with Pre => Start < Finish;
   
   --creates an http message out of a raw request
   procedure Parse_HTTP_Request(
      Raw_Request : Measured_Request_Buffer;
      Parsed_Request : out Simple_HTTP_Request
   );

end parsing;
