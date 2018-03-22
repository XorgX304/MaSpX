package body measured_buffer_type is

   function Is_Left_Neighbor_EmptyChar_And_This_Isnt(Buf : Measured_Buffer_Type; Idx : Max_Buffer_Size_Type) return Boolean
   is
      This_Isnt : Boolean;
      Left_Neighbor_EmptyChar : Boolean;
   begin
      if Idx = Positive'First then
         return False;
      else
         This_Isnt := Buf.Get_Char(Idx) = not Buf.EmptyChar;
         Left_Neighbor_EmptyChar := Buf.Get_Char(Idx-1) = Buf.EmptyChar;
      end if;
      
      return Left_Neighbor_EmptyChar and This_Isnt;
      
   end Is_Left_Neighbor_EmptyChar_And_This_Isnt;
   
   function Is_Right_Neighbor_EmptyChar_And_This_Isnt(Buf : Measured_Buffer_Type; Idx : Max_Buffer_Size_Type) return Boolean
   is
      This_Isnt : Boolean;
      Right_Neighbor_EmptyChar : Boolean;
   begin
      if Idx = Buf.Size then
         return False;
      else
         This_Isnt := Buf.Get_Char(Idx) = not Buf.EmptyChar;
         Right_Neighbor_EmptyChar := Buf.Get_Char(Idx+1) = Buf.EmptyChar;
      end if;
      
      return Right_Neighbor_EmptyChar and This_Isnt;
      
   end Is_Right_Neighbor_EmptyChar_And_This_Isnt;
   
   function Is_Contiguous(Buf : Measured_Buffer_Type) return Boolean
   is
   begin
      null;
   end Is_Contiguous;
   
end measured_buffer_type;
