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
   function Get_Wkday_Str(Day : Day_Name) return String
   is
   begin
      case Day is
      when Monday =>
         return "Mon";
      when Tuesday => 
         return "Tue";
      when Wednesday =>
         return "Wed";
      when Thursday =>
         return "Thu";
      when Friday =>
         return "Fri";
      when Saturday =>
         return "Sat";
      when Sunday =>
         return "Sun";
      end case;
   end Get_Wkday_Str;
   
--------------------------------------------------------------------------------
   function Get_Month_Str(Month : Month_Number) return String
   is
   begin
      case Month is
      when 1 =>
         return "Jan";
      when 2 =>
         return "Feb";
      when 3 =>
         return "Mar";
      when 4 => 
         return "Apr";
      when 5 =>
         return "May";
      when 6 =>
         return "Jun";
      when 7 =>
         return "Jul";
      when 8 =>
         return "Aug";
      when 9 =>
         return "Sep";
      when 10 =>
         return "Oct";
      when 11 =>
         return "Nov";
      when 12 =>
         return "Dec";
      end case;
   end Get_Month_Str;
   
--------------------------------------------------------------------------------
   function Trim_Number_Image(Str : String) return String
   is
   begin
      if Str'Last > Str'First then
         if Str(Str'First) = ' ' then
            return Str(Str'First + 1 .. Str'Last);
         end if;
      end if;
      
      return Str;
   end Trim_Number_Image;
   
--------------------------------------------------------------------------------
   function Insert_Leading_Zeroes_2DIGIT(Str : String) return String
   is
   begin
      if Str'Length = 1 then
         return "0" & Str;
      end if;
      
      return Str;
   end Insert_Leading_Zeroes_2DIGIT;
   
--------------------------------------------------------------------------------
   function Insert_Leading_Zeroes_4DIGIT(Str : String) return String
   is
   begin
      if Str'Length = 1 then
         return "000" & Str;
      elsif Str'Length = 2 then
         return "00" & Str;
      elsif Str'Length = 3 then
         return "0" & Str;
      end if;
      
      return Str;
   end Insert_Leading_Zeroes_4DIGIT;

end utils;
