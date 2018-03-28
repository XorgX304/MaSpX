pragma SPARK_Mode(On);

package body utils is

--------------------------------------------------------------------------------
   procedure Debug_Print_Ln(String_To_Print : String)
   is
   begin
      if Status(Standard_Output) = Success and DEBUG_PRINT_ON then
         Put_Line(String_To_Print);
         Flush;
      end if;
   end Debug_Print_Ln;
   
--------------------------------------------------------------------------------
   procedure Debug_Print(String_To_Print : String)
   is
   begin
      if Status(Standard_Output) = Success and DEBUG_PRINT_ON then
         Put(String_To_Print);
         Flush;
      end if;
   end Debug_Print;

--------------------------------------------------------------------------------
   procedure Check_Print_Ln(String_To_Print : String)
   is
   begin
      if Status(Standard_Output) = Success then
         Put_Line(String_To_Print);
         Flush;
      end if;
   end Check_Print_Ln;

--------------------------------------------------------------------------------
   procedure Check_Print(String_To_Print : String)
   is
   begin
      if Status(Standard_Output) = Success then
         Put(String_To_Print);
         Flush;
      end if;
   end Check_Print;

--------------------------------------------------------------------------------
   function Logical_Equivalence(P : Boolean; Q : Boolean) return Boolean
   is
   begin
      return (P and Q) or (not P and not Q);
   end Logical_Equivalence;
   
--------------------------------------------------------------------------------
   function Is_Substring(
      Substring : String;
      Source : String) return Boolean
   is
   begin
      for I in Source'Range loop
         if Check_Substring(Substring, I, Source) then
            return True;
         end if;
         
         pragma Loop_Invariant( for all J in Source'First .. I => not Check_Substring(Substring, J, Source) );
         pragma Loop_Variant( Increases => I );
      end loop;
      
      return False;
   end Is_Substring;

--------------------------------------------------------------------------------
   function Check_Substring(
      Substring : String;
      Start : Positive;
      Source : String) return Boolean
   is
   begin    
      return Substring = Source(Start .. Start + Substring'Length - 1);
   end Check_Substring;

end utils;
