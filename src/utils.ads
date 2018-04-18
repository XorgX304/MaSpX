pragma SPARK_Mode(On);

with SPARK.Text_IO; use SPARK.Text_IO;

with config; use config;

package utils is

   --TODO:ltj: add Global contract with Std_Out In_Out
   procedure Debug_Print_Ln(String_To_Print : String);
   procedure Debug_Print(String_To_Print : String);
   procedure Check_Print_Ln(String_To_Print : String);
   procedure Check_Print(String_To_Print : String);

   function Logical_Equivalence(P : Boolean; Q : Boolean) return Boolean
   with Global => null;

   function Is_Standard_Printable(C : Character) return Boolean
   is ( (Character'Pos(C) >= 32 and Character'Pos(C) <= 127)
         or Character'Pos(C) = 13 or Character'Pos(C) = 10
         or Character'Pos(C) = 9 )
   with Global => null;

end utils;
