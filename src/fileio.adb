pragma SPARK_Mode(On);

package body fileio is

   procedure Read_File_To_MFB(
       MFT : Measured_Filename_Type;
       MFB : out Measured_File_Buffer)
   is
      Trimmed_Name : String(1 .. MFT.Length - 1);
      Read_File : File_Type;
      Read_File_Status : File_Status;
      C : Character_Result;
   begin
      MFB.Length := 1;
      MFB.Buffer := (others=>NUL);
      
      Trim_Filename(MFT, Trimmed_Name);
      
      Put_Line("Filename trimmed:" & Trimmed_Name);

      Open(Read_File, In_File, Trimmed_Name);
      --check status of file
      Read_File_Status := Status(Read_File);
      --print status, send back NOT_FOUND MFB if file not found.
      case Read_File_Status is
         when Success =>
            Put_Line("fileio.adb:Read_File_To_MFB: on Open(Read_File...) Success");
         when Name_Error =>
            Put_Line("fileio.adb:Read_File_To_MFB: on Open(Read_File...) Name Error");
            MFB.Length := NOT_FOUND_LENGTH;
            MFB.Buffer := NOT_FOUND_PAGE;
            return;
         when others =>
            Put("fileio.adb:Read_File_To_MFB: on Open(Read_File...)");
            Print_File_Status(Read_File_Status);
      end case;
      
      --read all of it that can fit in MFB
      loop
         Get(Read_File, C);
         case C.Status is
            when Success =>
            --TODO:ltj: add if guard to guard against filling MFB too much
               MFB.Buffer(MFB.Length) := C.Item;
               MFB.Length := MFB.Length + 1;
            --TODO: throw error if more than can fit in MFB
            when End_Error =>
               Put_Line("End_Error on C.Status");
               Close(Read_File);
               Read_File_Status := Status(Read_File);
               Put("On closing file:");
               Print_File_Status(Read_File_Status);
               return;
            when others =>
               Put("In reading file loop:");
               Print_File_Status(C.Status);
               return;
         end case;
      end loop;
   end Read_File_To_MFB;
   
   procedure Trim_Filename(
      Pre_Filename : Measured_Filename_Type;
      Post_Filename : out String)
   is
   begin
      Post_Filename := (others=>' ');
      
      --TODO:ltj: add case for First_Empty_Index = 0
      for I in Pre_Filename.Name'First .. Pre_Filename.Length - 1 loop
         Post_Filename(I) := Pre_Filename.Name(I);
      end loop;
   end Trim_Filename;
   
   procedure Print_File_Status(
      My_File_Status : File_Status)
   is
   begin
      case My_File_Status is
         when Success =>
            Put_Line("File_Status: Success");
            return;
         when Unopened =>
            Put_Line("File_Status: Unopened");
            return;
         when Std_File_Error =>
            Put_Line("File_Status: Std_File_Error"); 
            return;
         when Status_Error =>
            Put_Line("File_Status: Status_Error");
            return;
         when Mode_Error =>
            Put_Line("File_Status: Mode_Error");
            return;
         when Name_Error =>
            Put_Line("File_Status: Name Error");
            return;
         when Use_Error =>
            Put_Line("File_Status: Use Error");
            return;
         when Device_Error =>
            Put_Line("File_Status: Device Error");
            return;
         when End_Error =>
            Put_Line("File_Status: End Error");
            return;
         when Data_Error =>
            Put_Line("File_Status: Data Error");
            return;
         when Layout_Error =>
            Put_Line("File_Status: Layout_Error");
            return;
      end case;
   end Print_File_Status;
   
   function Construct_Measured_Filename(URI : ParsedRequestURIStringType) return Measured_Filename_Type
   is
      MFT : Measured_Filename_Type;
   begin
      MFT.Name(WEB_ROOT'Range) := WEB_ROOT;
      MFT.Name(WEB_ROOT'Length + 1 .. WEB_ROOT'Length + URI'Length) := URI;
      
      for I in URI'Range loop
         if URI(I) = ' ' then
            MFT.Length := I + WEB_ROOT'Length;
            return MFT;
         end if;
      end loop;
      MFT.Length := 0;
      return MFT;
   end Construct_Measured_Filename;
   
end fileio;
