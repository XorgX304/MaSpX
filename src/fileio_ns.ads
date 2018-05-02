pragma SPARK_Mode(On);

with Ada.Streams.Stream_IO; use Ada.Streams.Stream_IO;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.IO_Exceptions;
with Ada.Exceptions;
with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;
with Ada.Directories; use Ada.Directories;
--with Ada.Calendar.Formatting; use Ada.Calendar.Formatting;

with Http_Message; use Http_Message;
with measured_buffer; use measured_buffer;
with error; use error;
with utils; use utils;
with response_strs; use response_strs;
with config; use config;

package fileio_ns is

   JPG_MAGIC : constant String := Character'Val(16#FF#) & Character'Val(16#D8#);
   GIF87_MAGIC : constant String := "GIF87a";
   GIF89_MAGIC : constant String := "GIF89a";
   PNG_MAGIC : constant String := Character'Val(16#89#) & "PNG" & Character'Val(16#0D#) & Character'Val(16#0A#) & Character'Val(16#1A#) & Character'Val(16#0A#);
   BMP_MAGIC : constant String := "BM";

   procedure Read_File_To_Response(
      --MFT : Measured_Filename_Type;
      Abs_Filename : String;
      Extension : String;
      Response : in out HTTP_Response_Type
   )
   with Global => null,
        Pre => Abs_Filename'Length <= MAX_FS_PATH_BYTE_CT;
               
   procedure Measure_File_To_Response(
      Abs_Filename : String;
      Extension : String;
      Response : in out HTTP_Response_Type
   )
   with Global => null;

end fileio_ns;
