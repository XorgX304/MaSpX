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
   type Tokens_Filename_Array_Type is array (Max_Buffer_Size_Type range <>) of Measured_Buffer_Type(MAX_FS_PATH_BYTE_CT, NUL);
   
   BLANK_FILENAME_TOKEN : constant Measured_Buffer_Type(MAX_FS_PATH_BYTE_CT, NUL) :=
      (Size => MAX_FS_PATH_BYTE_CT,
       EmptyChar => NUL,
       Buffer => (others=>NUL),
       Length => 0);

   --Start and Finish are inclusive
   procedure Get_First_Token_In_Range(
      Source_Buf : Measured_Buffer_Type;
      Delimit : Character;
      Start : Max_Buffer_Size_Type;
      Finish : Max_Buffer_Size_Type;
      Token_Buf : out Measured_Buffer_Type
   )
   with Global => null,
        Pre => Start <= Finish and then
               Source_Buf.Length <= Source_Buf.Size and then
               (Start <= Source_Buf.Length and Start >= Positive'First and
               Finish <= Source_Buf.Length and Finish >= Positive'First) and then
               Source_Buf.Size = Token_Buf.Size,
        Post => Token_Buf.Length <= Source_Buf.Length;
   
   function Get_All_Request_Tokens(
      Raw_Request : Measured_Buffer_Type;
      Delimit : Character
   ) return Tokens_Request_Array_Type
   with Global => null,
        Pre => Is_Delimits_Well_Formed(Raw_Request, Delimit) and then
               not Is_Leading_Delimit(Raw_Request, Delimit) and then
               Raw_Request.Length <= Raw_Request.Size and then
               not Is_Empty(Raw_Request) and then
               Raw_Request.Size = MAX_REQUEST_LINE_BYTE_CT and then
               Raw_Request.EmptyChar = NUL,
        Post => Get_All_Request_Tokens'Result'Length = Get_Token_Ct(Raw_Request, Delimit) and
                (for all I in Get_All_Request_Tokens'Result'Range => 
                    Get_All_Request_Tokens'Result(I).Length <= Get_All_Request_Tokens'Result(I).Size);
                    
   procedure Resolve_Special_Directories(Filename : in out Measured_Buffer_Type)
   with Global => (Input => BLANK_FILENAME_TOKEN),
        Pre => Is_Delimits_Well_Formed(Filename, '\') and then
               Filename.Length <= Filename.Size and then
               not Is_Empty(Filename) and then
               Filename.Size = MAX_FS_PATH_BYTE_CT and then
               Filename.EmptyChar = NUL;
               
   function Get_All_Filename_Tokens(
      Filename : Measured_Buffer_Type;
      Delimit : Character
   ) return Tokens_Filename_Array_Type
   with Global => null,
        Pre => Is_Delimits_Well_Formed(Filename, '\') and then
               Filename.Length <= Filename.Size and then
               not Is_Empty(Filename) and then
               Filename.Size = MAX_FS_PATH_BYTE_CT and then
               Filename.EmptyChar = NUL,
        Post => Get_All_Filename_Tokens'Result'Length = Get_Token_Ct(Filename, Delimit) and
                (for all I in Get_All_Filename_Tokens'Result'Range =>
                    Get_All_Filename_Tokens'Result(I).Length <= Get_All_Filename_Tokens'Result(I).Size);
        
   function Detokenize_Filename_Tokens(
      Tokens : Tokens_Filename_Array_Type;
      Delimit : Character
   ) return Measured_Buffer_Type
   with Global => (Input => BLANK_FILENAME_TOKEN),
        Pre => (for all I in Tokens'Range => Tokens(I).Length <= Tokens(I).Size),
        Post => Detokenize_Filename_Tokens'Result.Size = MAX_FS_PATH_BYTE_CT and
                Detokenize_Filename_Tokens'Result.EmptyChar = NUL;
                
   function Is_Last_Token(
      Tokens : Tokens_Filename_Array_Type;
      J : Positive
   ) return Boolean
   with Global => (Input => BLANK_FILENAME_TOKEN);
   
   function Is_Delimits_Well_Formed(
      Source_Buf : Measured_Buffer_Type;
      Delimit : Character
   ) return Boolean
   with Global => null;
   
   function Is_Leading_Delimit(
      Source_Buf : Measured_Buffer_Type;
      Delimit : Character
   ) return Boolean
   with Global => null;
   
   function Get_Token_Ct(
      Source_Buf : Measured_Buffer_Type;
      Delimit : Character
   ) return Max_Buffer_Size_Type
   with Global => null;      
   
   --creates an http message out of a raw request
   procedure Parse_HTTP_Request(
      Client_Socket : GNAT.Sockets.Socket_Type; -- pre Open (but network code..)
      Raw_Request : Measured_Buffer_Type;
      Parsed_Request : out Simple_HTTP_Request;
      Exception_Raised : out Boolean  --refactor Invalid Request
   )
   with Global => null,
        Pre => not Is_Empty(Raw_Request) and
               Raw_Request.Size = MAX_REQUEST_LINE_BYTE_CT and
               Raw_Request.EmptyChar = NUL and
               Raw_Request.Length <= Raw_Request.Size,
        Post => Parsed_Request.Stage = Parsed and then
                Parsed_Request.URI.Length <= Parsed_Request.URI.Size;

end parsing;
