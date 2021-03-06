pragma SPARK_Mode(On);

package body measured_buffer is

   function Construct_Measured_Buffer(
      SizeInst : Buffer_Size_Type; 
      EmptyCharInst : Character;
      Str : String) return Measured_Buffer_Type
   is
      Buf : Measured_Buffer_Type(SizeInst, EmptyCharInst);
   begin
      Buf.Buffer := (others=>EmptyCharInst);
      Buf.Length := 0;
      
      Append_Str(Buf, Str);
      
      return Buf;
   end Construct_Measured_Buffer;

--------------------------------------------------------------------------------
   function Calc_Length(Buf : Measured_Buffer_Type) return Buffer_Size_Type
   is
      Length : Buffer_Size_Type := 1;
   begin
      if Is_Full(Buf) then
         return Buf.Max_Size;
      elsif Is_Empty(Buf) then
         return 0;
      else
         for I in Positive'First + 1 .. Buf.Max_Size - 1 loop --ltj: we can do Buf.Size - 1 because we know that the Buf is not empty, or full and it is filled from the left.
            if Get_Char(Buf, I) = Buf.EmptyChar then       --     we start Length at 1 and start at Positive'First +1 because we essentially count one by saying it's not empty
               exit;
            end if;
         
            Length := Length + 1;
            
            pragma Loop_Invariant( Length = I );
         end loop;
      
         return Length;
      end if;
   end Calc_Length;

--------------------------------------------------------------------------------
   procedure Set_Length(Buf : in out Measured_Buffer_Type; New_Length : Buffer_Size_Type)
   is
   begin
      Buf.Length := New_Length;
   end Set_Length;
   
--------------------------------------------------------------------------------
   procedure Append(Buf : in out Measured_Buffer_Type; C : Character)
   is
      Append_Idx : Buffer_Size_Type := Buf.Length + 1;
   begin
      Buf.Buffer(Append_Idx) := C;
      Buf.Length := Append_Idx;
   end Append;

--------------------------------------------------------------------------------
   procedure Append_Str(Buf : in out Measured_Buffer_Type; S : String)
   is
   begin
      Buf.Buffer(Buf.Length+1 .. Buf.Length+S'Length) := S;
      Buf.Length := Buf.Length + S'Length;
   end Append_Str;
   
--------------------------------------------------------------------------------
   procedure Set_Str(Buf : out Measured_Buffer_Type; S : String)
   is
   begin
      Clear(Buf);
      Append_Str(Buf, S);
   end Set_Str;

--------------------------------------------------------------------------------
   procedure Replace_Char(Buf : in out Measured_Buffer_Type; BeforeChar,AfterChar : Character)
   is
   begin
      for I in Positive'First .. Buf.Length loop
         if Buf.Buffer(I) = BeforeChar then
            Buf.Buffer(I) := AfterChar;
         end if;
      end loop;
   end Replace_Char;

--------------------------------------------------------------------------------
   procedure Clear(Buf : out Measured_Buffer_Type)
   is
   begin
      Buf.Buffer := (others=>Buf.EmptyChar);
      Buf.Length := EMPTY_BUFFER_LENGTH;
   end Clear;

--------------------------------------------------------------------------------
   procedure Copy(Dst_Buf : in out Measured_Buffer_Type; Src_Buf : Measured_Buffer_Type)
   is
   begin
      Dst_Buf.Buffer(Positive'First .. Src_Buf.Length) := Src_Buf.Buffer(Positive'First .. Src_Buf.Length);
      Dst_Buf.Length := Src_Buf.Length;
   end Copy;

--------------------------------------------------------------------------------
   function Get_String_Trunc(Buf : Measured_Buffer_Type) return String
   is
   begin
      if Buf.Length <= Buf.Max_Size then
         return Buf.Buffer(Buf.Buffer'First .. Buf.Length);
      else
         return Buf.Buffer(Buf.Buffer'First .. Buf.Max_Size);
      end if;
   end Get_String_Trunc;

--------------------------------------------------------------------------------
   function Get_Extension(Buf : Measured_Buffer_Type) return String
   is
   begin
      for I in reverse Buf.Buffer'First .. Buf.Length loop
         if Buf.Buffer(I) = '.' then
            return Buf.Buffer(I .. Buf.Length);
         end if;
      end loop;
      
      return "";
   end Get_Extension;
   
--------------------------------------------------------------------------------
   
end measured_buffer;
