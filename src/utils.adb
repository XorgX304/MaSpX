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
   function Get_HTTP_Time_Str(Time : Ada.Calendar.Time) return String
   is
   begin
      return Day_Name'Image(Day_Of_Week(Time)) & ", " & Day_Number'Image(Ada.Calendar.Formatting.Day(Time)) & "-" & Month_Number'Image(Ada.Calendar.Formatting.Month(Time)) & "-" & Year_Number'Image(Ada.Calendar.Formatting.Year(Time)) & " " & Hour_Number'Image(Ada.Calendar.Formatting.Hour(Time)) & ":" & Minute_Number'Image(Ada.Calendar.Formatting.Minute(Time)) & ":" & Second_Number'Image(Ada.Calendar.Formatting.Second(Time)) & " GMT";
   end Get_HTTP_Time_Str;

end utils;
