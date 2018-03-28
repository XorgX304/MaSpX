pragma SPARK_Mode(On);

with SPARK.Text_IO; use SPARK.Text_IO;
with GNAT.Sockets;
with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;

with network_ns; use network_ns;
with config; use config;
with Http_Message; use Http_Message;
with String_Types; use String_Types;
with utils; use utils;
with measured_buffer; use measured_buffer;


package parsing is

   type Tokens_Request_Array_Type is array (Max_Buffer_Size_Type range <>) of Measured_Buffer_Type(MAX_REQUEST_LINE_BYTE_CT, NUL);

   --Start and Finish are inclusive
   procedure Get_First_Token_In_Range(
      Source_Buf : Measured_Buffer_Type;
      Delimit : Character;
      Start : Positive;
      Finish : Positive;
      Token_Buf : out Measured_Buffer_Type
   )
   with Global => null,
        Pre => Start <= Finish and then
               (Start <= Source_Buf.Size and Start >= Positive'First and
               Finish <= Source_Buf.Size and Finish >= Positive'First) and then
               Source_Buf.Size = Token_Buf.Size;
        
   --TODO:ltj:Get_Token_Ct --if we check this early, we can rule out some issues up front. Maybe put in precondition of parse_http_request?
   
--     function Tokenize_Request_Buffer( 
--        Raw_Request : Measured_Buffer_Type;
--        Delimit : Character
--     ) return Tokens_Request_Array_Type;
   
   --TODO:ltj:Compress_Delimits --delete any side-by-side delimiters.
   
   --TODO:ltj:Get_First_Delimit_Index --get the first delimiter in a string
   
   --creates an http message out of a raw request
   procedure Parse_HTTP_Request(
      Client_Socket : GNAT.Sockets.Socket_Type; -- pre Open (but network code..)
      Raw_Request : Measured_Buffer_Type;  --pre not null, or empty
      Parsed_Request : out Simple_HTTP_Request;
      Exception_Raised : out Boolean  --refactor Invalid Request
   );

end parsing;
