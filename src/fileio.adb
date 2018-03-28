pragma SPARK_Mode(On);

package body fileio is

   procedure Read_File_To_MFB(
       MFT : Measured_Filename_Type;
       MFB : out Measured_File_Buffer)
   is
      Trimmed_Name : String(1 .. Get_MFT_Length(MFT));
      Read_File : File_Type;
      Read_File_Status : File_Status;
      C : Character_Result;
   begin
      MFB.Length := 1;
      MFB.Buffer := (others=>NUL);
      
      Trim_Filename(MFT, Trimmed_Name);
      
      Debug_Print_Ln("Filename trimmed:" & Trimmed_Name);

      if not Is_Open(Read_File) then
         Open(Read_File, In_File, Trimmed_Name);
         --check status of file
         Read_File_Status := Status(Read_File);
         --print status, send back NOT_FOUND MFB if file not found.
         case Read_File_Status is
         when Success =>
            Debug_Print_Ln("fileio.adb:Read_File_To_MFB: on Open(Read_File...) Success");
         when Name_Error =>
            Debug_Print_Ln("fileio.adb:Read_File_To_MFB: on Open(Read_File...) Name Error");
            MFB.Length := NOT_FOUND_LENGTH;
            MFB.Buffer := NOT_FOUND_PAGE;
            return;
         when others =>
            Debug_Print("fileio.adb:Read_File_To_MFB: on Open(Read_File...)");
            Print_File_Status(Read_File_Status);
         end case;
      
         --read all of it that can fit in MFB
         loop
            if Is_Readable(Read_File) and then not End_Of_File(Read_File) then
               if MFB.Length = 0 then
                  --ltj: buffer is full, but there is more in the file, send 413 page
                  Debug_Print_Ln("File too big for our buffer size! Send 413_Payload_Too_Big");
                  MFB.Length := c413_PAYLOAD_TOO_LARGE_LENGTH;
                  MFB.Buffer := c413_PAYLOAD_TOO_LARGE_PAGE;
                  return;
               end if;
               
               Get(Read_File, C);
               
               case C.Status is
               when Success =>
                  MFB.Buffer(MFB.Length) := C.Item;
                  
                  if MFB.Length = ContentSize'Last then
                     MFB.Length := 0;
                  else
                     MFB.Length := MFB.Length + 1;
                  end if;
               when others =>
                  Debug_Print("In reading file loop:");
                  Print_File_Status(C.Status);
                  return;
               end case;
            else
               Debug_Print_Ln("End_of_File on Read_File");
               if Is_Open (Read_File) then --and not Is_Standard_File (Read_File) then
                  Close(Read_File);
                  Read_File_Status := Status(Read_File);
                  Debug_Print("On closing file:");
                  Print_File_Status(Read_File_Status);
                  return;
               else
                  Debug_Print_Ln("Close(Read_File) not necessary");
                  return; --ltj: was an infinite loop until this return placed here. Should SPARK have caught this?
               end if;
            end if;
         end loop;
      else
         Debug_Print_Ln("File in question already open! Send 409_Conflict");
         MFB.Buffer := CONFLICT_PAGE;
         MFB.Length := CONFLICT_LENGTH;
      end if;
   end Read_File_To_MFB;
   
   function Get_MFT_Length(
      MFT : Measured_Filename_Type) return MFT_First_Empty_Index_Type
   is
   begin
      if MFT.Length = 0 then
         return MFT.Name'Length;
      else
         return MFT.Length - 1;
      end if;
   end Get_MFT_Length;
   
   procedure Trim_Filename(
      Pre_Filename : Measured_Filename_Type;
      Post_Filename : out String)
   is
   begin
      Post_Filename := Pre_Filename.Name(Pre_Filename.Name'First .. Get_MFT_Length(Pre_Filename));
   end Trim_Filename;
   
   procedure Print_File_Status(
      My_File_Status : File_Status)
   is
   begin
      case My_File_Status is
         when Success =>
            Debug_Print_Ln("File_Status: Success");
            return;
         when Unopened =>
            Debug_Print_Ln("File_Status: Unopened");
            return;
         when Std_File_Error =>
            Debug_Print_Ln("File_Status: Std_File_Error"); 
            return;
         when Status_Error =>
            Debug_Print_Ln("File_Status: Status_Error");
            return;
         when Mode_Error =>
            Debug_Print_Ln("File_Status: Mode_Error");
            return;
         when Name_Error =>
            Debug_Print_Ln("File_Status: Name Error");
            return;
         when Use_Error =>
            Debug_Print_Ln("File_Status: Use Error");
            return;
         when Device_Error =>
            Debug_Print_Ln("File_Status: Device Error");
            return;
         when End_Error =>
            Debug_Print_Ln("File_Status: End Error");
            return;
         when Data_Error =>
            Debug_Print_Ln("File_Status: Data Error");
            return;
         when Layout_Error =>
            Debug_Print_Ln("File_Status: Layout_Error");
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
