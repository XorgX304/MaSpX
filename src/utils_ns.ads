with Network_Types;

package utils_ns
with SPARK_Mode => On
is

   PROCEDURE String_To_Byte_Array(Str : IN String; ByteArray : OUT Network_Types.Byte_Array_Type)
      with Depends => (ByteArray => Str);

end utils_ns;
