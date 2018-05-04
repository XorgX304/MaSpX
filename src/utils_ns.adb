pragma SPARK_Mode(Off);

package body utils_ns is
   
   --------------------------------------------------------------------------------
   function Get_HTTP_Time_Str(Time : Ada.Calendar.Time) return String
   is
   begin
      return Get_Wkday_Str(Day_Of_Week(Time)) & ", " & 
         Insert_Leading_Zeroes_2DIGIT(Trim_Number_Image(Day_Number'Image(Ada.Calendar.Formatting.Day(Time)))) & " " & 
         Get_Month_Str(Ada.Calendar.Formatting.Month(Time)) & " " & 
         Insert_Leading_Zeroes_4DIGIT(Trim_Number_Image(Year_Number'Image(Ada.Calendar.Formatting.Year(Time)))) & " " &
         Insert_Leading_Zeroes_2DIGIT(Trim_Number_Image(Hour_Number'Image(Ada.Calendar.Formatting.Hour(Time)))) & ":" & 
         Insert_Leading_Zeroes_2DIGIT(Trim_Number_Image(Minute_Number'Image(Ada.Calendar.Formatting.Minute(Time)))) & ":" & 
         Insert_Leading_Zeroes_2DIGIT(Trim_Number_Image(Second_Number'Image(Ada.Calendar.Formatting.Second(Time)))) & " GMT";
   end Get_HTTP_Time_Str;
   
end utils_ns;
