pragma SPARK_Mode(On);

with Ada.Streams.Stream_IO; use Ada.Streams.Stream_IO;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.IO_Exceptions;
with Ada.Exceptions;
with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;

with Http_Message; use Http_Message;
with measured_buffer; use measured_buffer;
with error; use error;

package fileio_ns is

  procedure Read_File_To_Buffer(
      --MFT : Measured_Filename_Type;
      Trimmed_Name : String;
      Buf : out Measured_Buffer_Type;
      ContentType : out ContentTypeType;
      Fileio_Error : out Fileio_Error_Type
  )
   with Global => null,
        Pre => Trimmed_Name'Length <= MAX_FS_PATH_BYTE_CT and
               Buf.Size = MAX_FILE_READ_BYTE_CT and
               Buf.EmptyChar = NUL; 

end fileio_ns;
