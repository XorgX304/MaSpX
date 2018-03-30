pragma SPARK_Mode(On);

package body measured_buffer is

   function Calc_Length(Buf : Measured_Buffer_Type) return Max_Buffer_Size_Type
   is
      Length : Max_Buffer_Size_Type := 1;
   begin
      if Is_Full(Buf) then
         return Buf.Size;
      elsif Is_Empty(Buf) then
         return 0;
      else
         for I in Positive'First + 1 .. Buf.Size - 1 loop --ltj: we can do Buf.Size - 1 because we know that the Buf is not empty, or full and it is filled from the left.
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
   procedure Set_Length(Buf : in out Measured_Buffer_Type; New_Length : Max_Buffer_Size_Type)
   is
   begin
      Buf.Length := New_Length;
   end Set_Length;
   
--------------------------------------------------------------------------------
   procedure Append(Buf : in out Measured_Buffer_Type; C : Character)
   is
      Append_Idx : Max_Buffer_Size_Type := Buf.Length + 1;
   begin
      Buf.Buffer(Append_Idx) := C;
      Buf.Length := Append_Idx;
   end Append;
   
--------------------------------------------------------------------------------
   procedure Clear(Buf : out Measured_Buffer_Type)
   is
   begin
      Buf.Buffer := (others=>Buf.EmptyChar);
      Buf.Length := EMPTY_BUFFER_LENGTH;
   end Clear;
   
end measured_buffer;
