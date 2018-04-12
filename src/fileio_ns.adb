pragma SPARK_Mode(Off);

--ltj: some possible alternatives to the current implementation. Might be faster, but would sacrifice portability to embedded systems:
--https://stackoverflow.com/questions/13957005/how-to-read-a-binary-file-entirely-and-quickly-in-ada

package body fileio_ns is
   
   procedure Read_File_To_Buffer(
      --MFT : Measured_Filename_Type;
      Trimmed_Name : String;
      Buf : out Measured_Buffer_Type;
      ContentType : out ContentTypeType;
      Fileio_Error : out Fileio_Error_Type)
   is
      Read_File : Ada.Streams.Stream_IO.File_Type;
      Read_Stream : Stream_Access;
      Item : Character;
   begin
      Fileio_Error := No_Error;
      Clear(Buf);
      ContentType := UNKNOWN_TYPE;
      
      Open(Read_File, In_File, Trimmed_Name);
      Read_Stream := Stream(Read_File);
      
      while not End_Of_File(Read_File) loop
         if Is_Full(Buf) then
            Put_Line("MaSpX: fileio_ns.adb: Read_File_To_Buffer: buffer full!");
            Fileio_Error := Buffer_Full_Error;
            exit;
         end if;
         
         Character'Read(Read_Stream, Item);
         Append(Buf, Item);
         
         --TODO:ltj: Check if falls in normal ASCII range. Mark if it doesn't
        
      end loop;
      
      Close(Read_File);
      
      if Is_Prefixed(Buf, JPG_MAGIC) then
         ContentType := JPG_TYPE;
      elsif Is_Prefixed(Buf, GIF89_MAGIC) or Is_Prefixed(Buf, GIF87_MAGIC) then
         ContentType := GIF_TYPE;
      elsif Is_Prefixed(Buf, PNG_MAGIC) then
         ContentType := PNG_TYPE;
      else
         ContentType := HTML_TYPE;
      end if;
      
      exception
      when E : Ada.IO_Exceptions.Name_Error =>
         Put_Line(Ada.Exceptions.Exception_Name(E) & ":  " & Ada.Exceptions.Exception_Message(E));
         Fileio_Error := Not_Found_Error;
      when E : Ada.IO_Exceptions.Use_Error =>
         Put_Line(Ada.Exceptions.Exception_Name(E) & ":  " & Ada.Exceptions.Exception_Message(E));
         Fileio_Error := Conflict_Error;
      when E : others =>
         Ada.Text_IO.Put_Line("MaSpX: fileio_ns.adb: Read_File_To_Buffer: WARNING, UNEXPECTED TYPE OF EXCEPTION");
         Put_Line(Ada.Exceptions.Exception_Name(E) & ":  " & Ada.Exceptions.Exception_Message(E));
         Fileio_Error := Unexpected_Error;
   end Read_File_To_Buffer;
   
end fileio_ns;
