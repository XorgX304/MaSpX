pragma SPARK_Mode(On);

with config; use config;
with utils; use utils;

package measured_buffer is

   subtype Buffer_Size_Type is Natural range Natural'First .. MAX_RESPONSE_LENGTH; --ltj: instead of just choosing obvious maximum, we can calculate it too: Natural'Max(Natural'Max(MAX_REQUEST_LINE_BYTE_CT, MAX_FILE_READ_BYTE_CT), Natural'Max(MAX_URI_BYTE_CT, MAX_PARSED_URI_BYTE_CT)); --ltj:set to the largest of the above constants
   subtype Buffer_Index_Type is Positive range Positive'First .. Buffer_Size_Type'Last;
   EMPTY_BUFFER_LENGTH : constant Natural := 0;
   
   type Measured_Buffer_Type(Max_Size : Buffer_Size_Type; EmptyChar : Character) is
   record
      Buffer : String(Positive'First .. Max_Size) := (others=>EmptyChar);
      Length : Buffer_Size_Type := EMPTY_BUFFER_LENGTH;
   end record;
   --with Type_Invariant => Measured_Buffer_Type.Length = Calc_Length(Buf);
--------------------------------------------------------------------------------
   EMPTY_HEADER_VALUE_BUFFER : constant Measured_Buffer_Type(MAX_HEADER_VALUE_BYTE_CT, MEASURED_BUFFER_EMPTY_CHAR) :=
      (Max_Size => MAX_HEADER_VALUE_BYTE_CT,
       EmptyChar => MEASURED_BUFFER_EMPTY_CHAR,
       Buffer => (others=>MEASURED_BUFFER_EMPTY_CHAR),
       Length => EMPTY_BUFFER_LENGTH);

--------------------------------------------------------------------------------
   function Construct_Measured_Buffer(
      SizeInst : Buffer_Size_Type; 
      EmptyCharInst : Character;
      Str : String
   ) return Measured_Buffer_Type
   with Global => null,
        Pre => Str'Length <= SizeInst and
               Str'Length >= 1,
        Post => Construct_Measured_Buffer'Result.Max_Size = SizeInst and
                Construct_Measured_Buffer'Result.EmptyChar = EmptyCharInst and
                Construct_Measured_Buffer'Result.Length <= Construct_Measured_Buffer'Result.Max_Size and
                Construct_Measured_Buffer'Result.Length = Str'Length;
   
   function Get_Char(Buf : Measured_Buffer_Type; Idx : Buffer_Size_Type) return Character
   is ( Buf.Buffer(Idx) )
   with Global => null,
        Pre => Idx >= Positive'First and Idx <= Buf.Max_Size;
     
   function Peek(Buf : Measured_Buffer_Type) return Character
   is ( Buf.Buffer(Buf.Length) )
   with Global => null,
        Pre => not Is_Empty(Buf) and
               Buf.Length <= Buf.Max_Size;
     
   --ltj: used for type_invariant but those can only be used on private types or corresponding full views...
   function Calc_Length(Buf : Measured_Buffer_Type) return Buffer_Size_Type
   with Global => null,
        Post => (if Is_Full(Buf) then 
                    Calc_Length'Result = Buf.Max_Size
                 elsif Is_Empty(Buf) then
                    Calc_Length'Result = 0
                 else
                    Calc_Length'Result > 0 and Calc_Length'Result < Buf.Max_Size);   
   
   function Get_Length(Buf : Measured_Buffer_Type) return Buffer_Size_Type
   is ( Buf.Length )
   with Global => null;
     
   procedure Set_Length(Buf : in out Measured_Buffer_Type; New_Length : Buffer_Size_Type)
   with Global => null,
        Pre => New_Length <= Buf.Max_Size,
        Post => Buf.Length = New_Length;
    
   function Is_Empty(Buf : Measured_Buffer_Type) return Boolean
   is ( Buf.Length <= EMPTY_BUFFER_LENGTH )
   with Global => null;
   
   
   
   function Is_Full(Buf : Measured_Buffer_Type) return Boolean
   is ( Buf.Length >= Buf.Max_Size )
   with Global => null;        
   
   
   procedure Append(Buf : in out Measured_Buffer_Type; C : Character)
   with Global => null,
        Pre =>  not Is_Full(Buf),
        Post => Buf.Length'Old + 1 = Buf.Length and
                Buf.Buffer(Buf.Length) = C;
  
   procedure Append_Str(Buf : in out Measured_Buffer_Type; S : String)
   with Global => null,
        Pre => S'Length >= 1 and then
               Buf.Length <= Buf.Max_Size - S'Length,
        Post => Buf.Length'Old + S'Length = Buf.Length and
                Buf.Length <= Buf.Max_Size;
                
   procedure Set_Str(Buf : out Measured_Buffer_Type; S : String)
   with Global => null,
        Pre => S'Length >= 1 and then
               S'Length <= Buf.Max_Size,
        Post => S'Length = Buf.Length and
                Buf.Length <= Buf.Max_Size;
                
   procedure Replace_Char(Buf : in out Measured_Buffer_Type; BeforeChar,AfterChar : Character)
   with Global => null,
        Pre => Buf.Length <= Buf.Max_Size,
        Post => Buf.Length'Old = Buf.Length;
   
   procedure Clear(Buf : out Measured_Buffer_Type)
   with Global => null,
        Post => Is_Empty(Buf) and
                (for all I in Positive'First .. Buf.Max_Size => Buf.Buffer(I) = Buf.EmptyChar);
                
   procedure Copy(Dst_Buf : in out Measured_Buffer_Type; Src_Buf : Measured_Buffer_Type)
   with Global => null,
        Pre => Src_Buf.Length <= Dst_Buf.Max_Size and
               Src_Buf.Length <= Src_Buf.Max_Size,
        Post => Dst_Buf.Buffer(Positive'First .. Src_Buf.Length) = Src_Buf.Buffer(Positive'First .. Src_Buf.Length) and
                Dst_Buf.Length = Src_Buf.Length;

   function Has_Prefix(Buf : Measured_Buffer_Type; Prefix : String) return Boolean
   is ( Buf.Buffer(Positive'First .. Prefix'Length) = Prefix )
   with Global => null,
        Pre => Prefix'Length <= Buf.Max_Size;
        
     
   function Get_String(Buf : Measured_Buffer_Type) return String
   is ( Buf.Buffer(Positive'First .. Buf.Length) )
   with Global => null,
        Pre => Buf.Length <= Buf.Max_Size,
        Post => Get_String'Result'Length <= Buf.Max_Size and
                Get_String'Result'Length = Buf.Length;
                
   function Get_String_Trunc(Buf : Measured_Buffer_Type) return String
   with Global => null,
        Post => Get_String_Trunc'Result'Length <= Buf.Max_Size and
                ( if Buf.Length <= Buf.Max_Size then
                     Get_String_Trunc'Result'Length = Buf.Length
                  else
                     Get_String_Trunc'Result'Length = Buf.Max_Size );
                
   function Get_Extension(Buf : Measured_Buffer_Type) return String
   with Global => null,
        Pre => Buf.Length <= Buf.Max_Size,
        Post => Get_Extension'Result'Length <= Buf.Length;

end measured_buffer;
