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
      Length : Max_Buffer_Size_Type := 1;
   begin
      if Buf.Is_Full then
         return Buf.Size;
      elsif Buf.Is_Empty then
         return 0;
      else
         for I in Positive'First + 1 .. Buf.Size - 1 loop --ltj: we can do Buf.Size - 1 because we know that the Buf is not empty, or full and it is filled from the left.
            if Buf.Get_Char(I) = Buf.EmptyChar then       --     we start Length at 1 and start at Positive'First +1 because we essentially count one by saying it's not empty
               exit;
            end if;
         
            Length := Length + 1;
            
            pragma Loop_Invariant( Length = I );
         end loop;
      
         return Length;
      end if;
   end Calc_Length;

--------------------------------------------------------------------------------
   function Get_Length(Buf : Measured_Buffer_Type) return Max_Buffer_Size_Type
   is
   begin
      if Buf.Length >= Buf.Size then
         return Buf.Size;
      end if;
         
      return Buf.Length;
   end Get_Length;

--------------------------------------------------------------------------------
   procedure Set_Length(Buf : in out Measured_Buffer_Type; New_Length : Max_Buffer_Size_Type)
   is
   begin
      Buf.Length := New_Length;
   end Set_Length;

--------------------------------------------------------------------------------
   procedure Update_Length(Buf : in out Measured_Buffer_Type)
   is
   begin
      Buf.Length := Buf.Calc_Length;
      pragma Assume( Buf.Is_Filled_From_Left );
   end Update_Length;

--------------------------------------------------------------------------------
   function Is_Empty(Buf : Measured_Buffer_Type) return Boolean
   is
   begin
      for I in Positive'First .. Buf.Size loop
         if Buf.Get_Char(I) /= Buf.EmptyChar then
            return False;
         end if;
         
         pragma Loop_Invariant( for all J in Positive'First .. I => Buf.Get_Char(J) = Buf.EmptyChar );
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
         
         pragma Loop_Invariant( for all J in Positive'First .. I => Buf.Get_Char(J) /= Buf.EmptyChar );
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
--     function Is_Right_Neighbor_EmptyChar_And_This_Isnt(Buf : Measured_Buffer_Type; Idx : Max_Buffer_Size_Type) return Boolean
--     is
--        This_Isnt : Boolean;
--        Right_Neighbor_EmptyChar : Boolean;
--     begin
--        if Idx = Buf.Size then
--           return False;
--        else
--           This_Isnt := Buf.Get_Char(Idx) /= Buf.EmptyChar;
--           Right_Neighbor_EmptyChar := Buf.Get_Char(Idx+1) = Buf.EmptyChar;
--        end if;
--        
--        return Right_Neighbor_EmptyChar and This_Isnt;
--        
--     end Is_Right_Neighbor_EmptyChar_And_This_Isnt;
   
--------------------------------------------------------------------------------
--     function Is_One_Left_Edge(Buf : Measured_Buffer_Type) return Boolean
--     is
--        Left_Edge_Sum : Max_Buffer_Size_Type := 0;
--     begin
--        for I in Positive'First .. Buf.Size loop
--           if Buf.Is_Left_Neighbor_EmptyChar_And_This_Isnt(I) then
--              Left_Edge_Sum := Left_Edge_Sum + 1;
--           end if;
--           
--           pragma Loop_Invariant(Left_Edge_Sum <= I);
--        end loop;
--        
--        if Left_Edge_Sum = 1 then
--           return True;
--        else
--           return False;
--        end if;
--     end Is_One_Left_Edge;

--------------------------------------------------------------------------------
--     function Is_One_Right_Edge(Buf : Measured_Buffer_Type) return Boolean
--     is
--        Right_Edge_Sum : Max_Buffer_Size_Type := 0;
--     begin
--        for I in Positive'First .. Buf.Size loop
--           if Buf.Is_Right_Neighbor_EmptyChar_And_This_Isnt(I) then
--              Right_Edge_Sum := Right_Edge_Sum + 1;
--           end if;
--           
--           pragma Loop_Invariant(Right_Edge_Sum <= I);
--        end loop;
--        
--        if Right_Edge_Sum = 1 then
--           return True;
--        else
--           return False;
--        end if;
--     end Is_One_Right_Edge;

--------------------------------------------------------------------------------
   function Is_Filled_From_Left(Buf : Measured_Buffer_Type) return Boolean
   is
   begin
      if Buf.Is_Empty or Buf.Is_Full then
         pragma Assert(Buf.Is_Empty or Buf.Is_Full);
         return True;
      end if;
   
      for I in Positive'First .. Buf.Size loop
         if Buf.Is_Left_Neighbor_EmptyChar_And_This_Isnt(I) then
            return False;
         end if;
         
         pragma Loop_Invariant( for all J in Positive'First .. I => not Buf.Is_Left_Neighbor_EmptyChar_And_This_Isnt(J) );
      end loop;
      
      return True;
   end Is_Filled_From_Left;
--------------------------------------------------------------------------------
--     function Is_Contiguous(Buf : Measured_Buffer_Type) return Boolean
--     is
--     begin
--        return Buf.Is_Empty or Buf.Is_Full or Buf.Is_One_Left_Edge or Buf.Is_One_Right_Edge;
--     end Is_Contiguous;
--     
--  --------------------------------------------------------------------------------
--     function Is_Aligned(Buf : Measured_Buffer_Type) return Boolean
--     is
--     begin
--        if not Buf.Is_Empty then
--           return (Buf.Get_Char(Positive'First) /= Buf.EmptyChar);
--        else
--           return True;
--        end if;
--     end Is_Aligned;

   procedure Append(Buf : in out Measured_Buffer_Type; C : Character)
   is
      Append_Idx : Max_Buffer_Size_Type := Buf.Calc_Length + 1;
   begin
      Buf.Buffer(Append_Idx) := C;
      Buf.Set_Length(Append_Idx);
   end Append;
   
end measured_buffer_type;
