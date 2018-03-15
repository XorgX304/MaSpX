pragma SPARK_Mode(On);

with SPARK.Text_IO; use SPARK.Text_IO;

with config; use config;

package utils is

   procedure Debug_Print_Ln(String_To_Print : String);
   procedure Debug_Print(String_To_Print : String);
   procedure Check_Print_Ln(String_To_Print : String);
   procedure Check_Print(String_To_Print : String);

end utils;
