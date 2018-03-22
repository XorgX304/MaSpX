pragma SPARK_Mode(On);

with SPARK.Text_IO; use SPARK.Text_IO;
with GNAT.Sockets;

with network_ns; use network_ns;
with config; use config;
with Http_Message; use Http_Message;
with String_Types; use String_Types;
with utils; use utils;

--TODO: SPARKify
package parsing is

   function Is_Substring(
      Substring : String;
      Source : String
   ) return Boolean
   with Global => null,
        Pre => Substring'Length <= Source'Length and
               Substring'Length >= 1,
        Post => (if Is_Substring'Result then
                    (for some I in Source'Range => Check_Substring(Substring, I, Source))
                 else
                    (for all I in Source'Range => not Check_Substring(Substring, I, Source)));
        
   function Check_Substring(
      Substring : String;
      Start : Positive;
      Source : String
   ) return Boolean
   with Global => null,
        Pre => Substring'Length <= Source'Length and
               Substring'Length >= 1 and     --we're not in the business of the empty string
               Start >= Source'First and Start <= Source'Last,
        Post => (if Check_Substring'Result then
                    Substring = Source(Start .. Start + Substring'Length - 1)
                 else
                    Substring /= Source(Start .. Start + Substring'Length - 1));

   --Start and Finish are inclusive
   procedure Get_First_Token_In_Range(
      Source : String;
      Delimit : Character;
      Start : Positive;
      Finish : Positive;
      Token_String : out String;
      Token_First_Empty_Index : out Natural
   )
   with Global => null,
        Pre => Start < Finish and then
               (Start < Source'Last and Start >= Source'First and
               Finish <= Source'Last and Finish > Source'First) and then
               Source'Length = Token_String'Length;
        
   --Start and Finish are inclusive
   procedure Get_First_Token_In_Range_COPY_ALT(
      Source : String;
      Delimit : Character;
      Start : Positive;
      Finish : Positive;
      Token_String : out String;
      Token_First_Empty_Index : out Natural
   )
   with Global => (In_Out => Standard_Output),
        Pre => Start < Finish and then
               (Start < Source'Last and Start >= Source'First and
               Finish <= Source'Last and Finish > Source'First) and then
               Source'Length = Token_String'Length,
        Post => Is_Substring(Token_String(Token_String'First .. Token_First_Empty_Index - 1), Source);-- and
        --        Token_First_Empty_Index = Get_First_Delimit_Index(Token_String, Delimit)
   
   function Get_First_Delimit_Index_In_Range(
      Source : String;
      Delimit : Character;
      Start : Positive;
      Finish : Positive
   ) return Natural
   with Global => null,
        Pre => Start < Finish and then
               (Start < Source'Last and Start >= Source'First and
               Finish <= Source'Last and Finish > Source'First),
        Post => (Get_First_Delimit_Index_In_Range'Result >= Start and
                Get_First_Delimit_Index_In_Range'Result <= Finish) or
                Get_First_Delimit_Index_In_Range'Result = 0;
        
   --TODO:ltj:Get_Token_Ct --if we check this early, we can rule out some issues up front. Maybe put in precondition of parse_http_request?
   
   --TODO:ltj:Tokenize_String --convert string into array of tokens. Upper bound on array calc'd by how many possible tokens in string
   
   --TODO:ltj:Compress_Delimits --delete any side-by-side delimiters.
   
   --TODO:ltj:Get_First_Delimit_Index --get the first delimiter in a string
   
   --creates an http message out of a raw request
   procedure Parse_HTTP_Request(
      Client_Socket : GNAT.Sockets.Socket_Type;
      Raw_Request : Measured_Request_Buffer;
      Parsed_Request : out Simple_HTTP_Request;
      Exception_Raised : out Boolean
   );

end parsing;
