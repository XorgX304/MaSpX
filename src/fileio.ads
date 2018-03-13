pragma SPARK_Mode(On);

with Ada.Characters;
with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;
with SPARK.Text_IO; use SPARK.Text_IO;

with String_Types; use String_Types;
with config; use config;

package fileio is

   MAX_FILE_READ_BYTE_CT : constant Natural := 10000;
   subtype ContentSize is Natural range Natural'First .. MAX_FILE_READ_BYTE_CT; 
   subtype File_Buf is String(Positive'First .. MAX_FILE_READ_BYTE_CT);
   
   type Measured_File_Buffer is
   record
      Length : ContentSize := 1;
      Buffer : File_Buf := (others=>NUL);
   end record;
   
   NOT_FOUND_PAGE : constant File_Buf := ('4','0','4',' ','N','o','t',' ','F','o','u','n','d', others=>' ');
   NOT_FOUND_LENGTH : constant ContentSize := 14;

   MAX_FS_PATH_BYTE_CT : constant Positive := WEB_ROOT'Length + ParsedRequestURIStringType'Length;
   subtype MFT_First_Empty_Index_Type is Natural range Natural'First .. MAX_FS_PATH_BYTE_CT;
   subtype Filename_Type is String(Positive'First .. MAX_FS_PATH_BYTE_CT);
   
   type Measured_Filename_Type is
   record
      Length : MFT_First_Empty_Index_Type := 1;
      Name : Filename_Type := (others=>' ');
   end record;
   
   procedure Trim_Filename(
      Pre_Filename : Measured_Filename_Type;
      Post_Filename : out String
   );
   
   procedure Read_File_To_MFB(
      MFT : Measured_Filename_Type;
      MFB : out Measured_File_Buffer
   );
   
   procedure Print_File_Status(
      My_File_Status : File_Status
   );
   
   --ltj: also prepends the web root to the URI
   function Construct_Measured_Filename(URI : ParsedRequestURIStringType) return Measured_Filename_Type;

end fileio;
