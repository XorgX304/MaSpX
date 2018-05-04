pragma SPARK_Mode(On);

with Ada.Calendar; use Ada.Calendar;
with Ada.Calendar.Formatting; use Ada.Calendar.Formatting;

with utils; use utils;

package utils_ns is

   function Get_HTTP_Time_Str(Time : Ada.Calendar.Time) return String
   with Global => null;

end utils_ns;
