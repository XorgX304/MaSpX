pragma SPARK_Mode(Off);

--ltj: some possible alternatives to the current implementation. Might be faster, but would sacrifice portability to embedded systems:
--https://stackoverflow.com/questions/13957005/how-to-read-a-binary-file-entirely-and-quickly-in-ada

package body fileio_ns is
   
   procedure Read_File_To_Response(
      --MFT : Measured_Filename_Type;
      Abs_Filename : String;
      Extension : String;
      Response : in out HTTP_Response_Type)
   is
      Read_File : Ada.Streams.Stream_IO.File_Type;
      Read_Stream : Stream_Access;
      Item : Character;
      Binary_File : Boolean := False;
   begin
      Response.Status_Code := c200_OK;
      
      Open(Read_File, In_File, Abs_Filename);
      Read_Stream := Stream(Read_File);
      
      while not End_Of_File(Read_File) loop
         if Is_Full(Response.Entity) then
            Put_Line("MaSpX: fileio_ns.adb: Read_File_To_Buffer: buffer full!");
            Response.Status_Code := c500_INTERNAL_SERVER_ERROR;
            return;
         end if;
         
         Character'Read(Read_Stream, Item);
         Append(Response.Entity, Item);
         
         --ltj: Check if falls in normal US-ASCII range. Mark stream as binary if it doesn't
         if not Is_Standard_Printable(Item) and not Binary_File then
            Put_Line("Not Standard,Printable, code: " & Integer'Image(Character'Pos(Item)));
            Binary_File := True;
         end if;
        
      end loop;
      
      Close(Read_File);
      
      --ltj: set Content-Length header
      Set_Str(Response.Header_Values(CONTENT_LENGTH_HEADER), Buffer_Size_Type'Image(Response.Entity.Length));
      
      --ltj: set Content-Type header
      if Binary_File then
         if Has_Prefix(Response.Entity, JPG_MAGIC) then
            Set_Str(Response.Header_Values(CONTENT_TYPE_HEADER), CONTENT_TYPE_IMAGE_JPEG_STR);
         elsif Has_Prefix(Response.Entity, GIF89_MAGIC) or Has_Prefix(Response.Entity, GIF87_MAGIC) then
            Set_Str(Response.Header_Values(CONTENT_TYPE_HEADER), CONTENT_TYPE_IMAGE_GIF_STR);
         elsif Has_Prefix(Response.Entity, PNG_MAGIC) then
            Set_Str(Response.Header_Values(CONTENT_TYPE_HEADER), CONTENT_TYPE_IMAGE_PNG_STR);
         elsif Has_Prefix(Response.Entity, BMP_MAGIC) then
            Set_Str(Response.Header_Values(CONTENT_TYPE_HEADER), CONTENT_TYPE_IMAGE_BMP_STR);
         else
            Set_Str(Response.Header_Values(CONTENT_TYPE_HEADER), CONTENT_TYPE_APPLICATION_OCTET_STREAM_STR);
         end if;
      else --text data
         --ltj: check extension here to determine textual type.
         if Extension = ".html" or Extension = ".htm" then
            Set_Str(Response.Header_Values(CONTENT_TYPE_HEADER), CONTENT_TYPE_TEXT_HTML_STR);
         elsif Extension = ".css" then
            Set_Str(Response.Header_Values(CONTENT_TYPE_HEADER), CONTENT_TYPE_TEXT_CSS_STR);
         elsif Extension = ".js" then
            Set_Str(Response.Header_Values(CONTENT_TYPE_HEADER), CONTENT_TYPE_APPLICATION_JS_STR);
         else
            Set_Str(Response.Header_Values(CONTENT_TYPE_HEADER), CONTENT_TYPE_TEXT_PLAIN_STR);
         end if;
      end if;
      
      exception
      when E : Ada.IO_Exceptions.Name_Error =>
         Put_Line(Ada.Exceptions.Exception_Name(E) & ":  " & Ada.Exceptions.Exception_Message(E));
         Response.Status_Code := c404_NOT_FOUND;
      when E : Ada.IO_Exceptions.Use_Error =>
         Put_Line(Ada.Exceptions.Exception_Name(E) & ":  " & Ada.Exceptions.Exception_Message(E));
         Response.Status_Code := c400_BAD_REQUEST;
      when E : others =>
         Ada.Text_IO.Put_Line("MaSpX: fileio_ns.adb: Read_File_To_Buffer: WARNING, UNEXPECTED TYPE OF EXCEPTION");
         Put_Line(Ada.Exceptions.Exception_Name(E) & ":  " & Ada.Exceptions.Exception_Message(E));
         Response.Status_Code := c500_INTERNAL_SERVER_ERROR;
   end Read_File_To_Response;
   
--------------------------------------------------------------------------------
   procedure Measure_File_To_Response(
      Abs_Filename : String;
      Extension : String;
      Response : in out HTTP_Response_Type)
   is
      Filesize : Ada.Directories.File_Size;
   begin
      Response.Status_Code := c200_OK;
   
      Filesize := Size(Abs_Filename);
      
      Set_Str(Response.Header_Values(CONTENT_LENGTH_HEADER), Ada.Directories.File_Size'Image(Filesize));
      
      exception
      when E : Ada.IO_Exceptions.Name_Error =>
         Put_Line(Ada.Exceptions.Exception_Name(E) & ":  " & Ada.Exceptions.Exception_Message(E));
         Response.Status_Code := c404_NOT_FOUND;
      when E : Ada.IO_Exceptions.Use_Error =>
         Put_Line(Ada.Exceptions.Exception_Name(E) & ":  " & Ada.Exceptions.Exception_Message(E));
         Response.Status_Code := c400_BAD_REQUEST;
      when E : others =>
         Ada.Text_IO.Put_Line("MaSpX: fileio_ns.adb: Read_File_To_Buffer: WARNING, UNEXPECTED TYPE OF EXCEPTION");
         Put_Line(Ada.Exceptions.Exception_Name(E) & ":  " & Ada.Exceptions.Exception_Message(E));
         Response.Status_Code := c500_INTERNAL_SERVER_ERROR;
   end Measure_File_To_Response;
   
end fileio_ns;
