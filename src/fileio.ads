pragma SPARK_Mode(On);

with Ada.Characters;
with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;
with SPARK.Text_IO; use SPARK.Text_IO;

with String_Types; use String_Types;
with config; use config;
with utils; use utils;
with measured_buffer; use measured_buffer;

package fileio is

   subtype ContentSize is Natural range Natural'First .. MAX_FILE_READ_BYTE_CT; 
   subtype File_Buf is String(Positive'First .. MAX_FILE_READ_BYTE_CT);
   
   type Measured_File_Buffer is
   record
      Length : ContentSize := 1;
      Buffer : File_Buf := (others=>NUL);
   end record;
   
   --TODO:ltj: move these pages to config.ads!
   --TODO:ltj: prepend error code to constant name
   NOT_FOUND_PAGE : constant File_Buf := ('4','0','4',' ','N','o','t',' ','F','o','u','n','d', others=>' ');
   NOT_FOUND_LENGTH : constant ContentSize := 14;
   
   --TODO:ltj: prepend error code to constant name
   CONFLICT_PAGE : constant File_Buf := ('4','0','9',' ','C','o','n','f','l','i','c','t', others=>' ');
   CONFLICT_LENGTH : constant ContentSize := 13;
   
   c413_PAYLOAD_TOO_LARGE_PAGE : constant File_Buf := ('4','1','3',' ','P','a','y','l','o','a','d',' ','T','o','o',' ','L','a','r','g','e', others=>' ');
   c413_PAYLOAD_TOO_LARGE_LENGTH : constant ContentSize := 22;
   
   procedure Read_File_To_MFB(
      --MFT : Measured_Filename_Type;
      Trimmed_Name : String;
      MFB : out Measured_File_Buffer
   )
   with Global => (In_Out => Standard_Output),
        Pre => Trimmed_Name'Length <= MAX_FS_PATH_BYTE_CT;
   
   procedure Print_File_Status(
      My_File_Status : File_Status
   );

end fileio;
