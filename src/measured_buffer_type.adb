pragma SPARK_Mode(On);

package body measured_buffer_type is

   function Get_Char(Buf : Measured_Buffer_Type; Idx : Max_Buffer_Size_Type) return Character
   is
   begin
      return Buf.Buffer(Idx);
   end Get_Char;
   
--------------------------------------------------------------------------------
   function Calc_Length(Buf : Measured_Buffer_Type) return Max_Buffer_Size_Type
   is
      Length : Max_Buffer_Size_Type := 0;
   begin
      for I in Positive'First .. Buf.Size loop
         if Buf.Get_Char(I) = Buf.EmptyChar then
            exit;
         end if;
         
         Length := Length + 1;
         pragma Loop_Invariant( Length = I );
      end loop;
      
      return Length;
   end Calc_Length;

--------------------------------------------------------------------------------
   function Get_Length(Buf : Measured_Buffer_Type) return Max_Buffer_Size_Type
   is
   begin
      --ltj: kind of a cheat, but Buf.Length not exceeding Buf.Size is enforced by the functions that change Buf.Length
      --TODO:ltj: is there any way to prove that all of the functions that change Buf.Length do so within the correct bounds? I don't think SPARK is interprocedural...
      if Buf.Length > Buf.Size then
         --SPARK.Text_IO.Put_Line("WARNING:measured_buffer_type.adb:Get_Length: buffer bounds exceeded. Max buffer size returned as a concession"); --ltj:don't want to make this a procedure and thus allow side effects
         return Buf.Size;
      end if;
         
      return Buf.Length;
   end Get_Length;

--------------------------------------------------------------------------------
   function Is_Empty(Buf : Measured_Buffer_Type) return Boolean
   is
   begin
      for I in Positive'First .. Buf.Size loop
         if Buf.Get_Char(I) /= Buf.EmptyChar then
            return False;
         end if;
      end loop;
      
      return True;
   end Is_Empty;

--------------------------------------------------------------------------------
   function Is_Full(Buf : Measured_Buffer_Type) return Boolean
   is
   begin
      for I in Positive'First .. Buf.Size loop
         if Buf.Get_Char(I) = Buf.EmptyChar then
            return False;
         end if;
      end loop;
      
      return True;
   end Is_Full;

--------------------------------------------------------------------------------
   function Is_Left_Neighbor_EmptyChar_And_This_Isnt(Buf : Measured_Buffer_Type; Idx : Max_Buffer_Size_Type) return Boolean
   is
      This_Isnt : Boolean;
      Left_Neighbor_EmptyChar : Boolean;
   begin
      if Idx = Positive'First then
         return False;
      else
         This_Isnt := Buf.Get_Char(Idx) /= Buf.EmptyChar;
         Left_Neighbor_EmptyChar := Buf.Get_Char(Idx-1) = Buf.EmptyChar;
      end if;
      
      return Left_Neighbor_EmptyChar and This_Isnt;
      
   end Is_Left_Neighbor_EmptyChar_And_This_Isnt;
   
--------------------------------------------------------------------------------
   function Is_Right_Neighbor_EmptyChar_And_This_Isnt(Buf : Measured_Buffer_Type; Idx : Max_Buffer_Size_Type) return Boolean
   is
      This_Isnt : Boolean;
      Right_Neighbor_EmptyChar : Boolean;
   begin
      if Idx = Buf.Size then
         return False;
      else
         This_Isnt := Buf.Get_Char(Idx) /= Buf.EmptyChar;
         Right_Neighbor_EmptyChar := Buf.Get_Char(Idx+1) = Buf.EmptyChar;
      end if;
      
      return Right_Neighbor_EmptyChar and This_Isnt;
      
   end Is_Right_Neighbor_EmptyChar_And_This_Isnt;
   
--------------------------------------------------------------------------------
   function Is_One_Left_Edge(Buf : Measured_Buffer_Type) return Boolean
   is
      Left_Edge_Sum : Max_Buffer_Size_Type := 0;
   begin
      for I in Positive'First .. Buf.Size loop
         if Buf.Is_Left_Neighbor_EmptyChar_And_This_Isnt(I) then
            Left_Edge_Sum := Left_Edge_Sum + 1;
         end if;
         
         pragma Loop_Invariant(Left_Edge_Sum <= I);
      end loop;
      
      if Left_Edge_Sum = 1 then
         return True;
      else
         return False;
      end if;
   end Is_One_Left_Edge;

--------------------------------------------------------------------------------
   function Is_One_Right_Edge(Buf : Measured_Buffer_Type) return Boolean
   is
      Right_Edge_Sum : Max_Buffer_Size_Type := 0;
   begin
      for I in Positive'First .. Buf.Size loop
         if Buf.Is_Right_Neighbor_EmptyChar_And_This_Isnt(I) then
            Right_Edge_Sum := Right_Edge_Sum + 1;
         end if;
         
         pragma Loop_Invariant(Right_Edge_Sum <= I);
      end loop;
      
      if Right_Edge_Sum = 1 then
         return True;
      else
         return False;
      end if;
   end Is_One_Right_Edge;

--------------------------------------------------------------------------------
   function Is_Contiguous(Buf : Measured_Buffer_Type) return Boolean
   is
   begin
      return Buf.Is_Empty or Buf.Is_Full or Buf.Is_One_Left_Edge or Buf.Is_One_Right_Edge;
   end Is_Contiguous;
   
--------------------------------------------------------------------------------
   function Is_Aligned(Buf : Measured_Buffer_Type) return Boolean
   is
   begin
      if not Buf.Is_Empty then
         return (Buf.Get_Char(Positive'First) /= Buf.EmptyChar);
      else
         return True;
      end if;
   end Is_Aligned;
   
end measured_buffer_type;
