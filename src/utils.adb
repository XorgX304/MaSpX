pragma SPARK_Mode(Off);

package body utils is

   PROCEDURE String_To_Byte_Array(Str : IN String; ByteArray : OUT Network_Types.Byte_Array_Type) IS
   BEGIN
      --Make uninitialized data warning go away
      --at some point, should check the performance consequences of this
      --might be better to just accept the warning or use a pragma to turn the warning off
      ByteArray := Network_Types.BLANK_BYTE_ARRAY;

      FOR I IN natural RANGE 1..Str'Length LOOP
         ByteArray(Network_Types.Message_Length_Range(I)) := Character'pos(Str(I));
      END LOOP;
   END;
   
end utils;
