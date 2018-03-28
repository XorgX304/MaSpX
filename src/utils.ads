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

   function Is_Substring(
      Substring : String;
      Source : String
   ) return Boolean
   with Global => null,
        Pre => Substring'Length <= Source'Length and
               Substring'Length >= 1,
        Post => (if Is_Substring'Result then
                    (for some I in Source'Range => Check_Substring(Substring, I, Source))
                 else
                    (for all I in Source'Range => not Check_Substring(Substring, I, Source)));

   function Check_Substring(
      Substring : String;
      Start : Positive;
      Source : String
   ) return Boolean
   with Global => null,
        Pre => Substring'Length <= Source'Length and
               Substring'Length >= 1 and     --we're not in the business of the empty string
               Start >= Source'First and Start <= Source'Last,
        Post => (if Check_Substring'Result then
                    Substring = Source(Start .. Start + Substring'Length - 1)
                 else
                    Substring /= Source(Start .. Start + Substring'Length - 1));

end utils;
