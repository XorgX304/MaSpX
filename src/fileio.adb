pragma SPARK_Mode(On);

package body fileio is

--------------------------------------------------------------------------------
   procedure Read_File_To_MFB( --TODO:ltj: 
       --MFT : Measured_Filename_Type
       Trimmed_Name : String;
       MFB : out Measured_File_Buffer;
       JPEG : out Boolean)
   is
      --Trimmed_Name : String(1 .. Get_MFT_Length(MFT));
      Read_File : File_Type;
      Read_File_Status : File_Status;
      C : Character_Result := 
         (Status => Status_Error);
      Prev_C : Character_Result;
      FirstByteFlag : Boolean := True;
      FirstByte : Character;
      SecondByteFlag : Boolean := False;
      SecondByte : Character;
      OtherByteFlag : Boolean := False;
   begin
      MFB.Length := 1;
      MFB.Buffer := (others=>NUL);
      JPEG := False;
      
      --Trim_Filename(MFT, Trimmed_Name);
      
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
            MFB.Length := NOT_FOUND_LENGTH;
            MFB.Buffer := NOT_FOUND_PAGE;
            return;
         end case;
         
         pragma Assert( not Is_Standard_File(Read_File) );
      
         --read all of it that can fit in MFB
         loop
            pragma Loop_Invariant( not Is_Standard_File(Read_File) );  
               
            if (JPEG and then (Prev_C.Item /= Character'Val(16#FF#) or C.Item /= Character'Val(16#D9#)))
            or (not JPEG and then Is_Readable(Read_File) and then not End_Of_File(Read_File)) then
               if MFB.Length = 0 then
                  --ltj: buffer is full, but there is more in the file, send 413 page
                  Debug_Print_Ln("File too big for our buffer size! Send 413_Payload_Too_Big");
                  MFB.Length := c413_PAYLOAD_TOO_LARGE_LENGTH;
                  MFB.Buffer := c413_PAYLOAD_TOO_LARGE_PAGE;
                  return;
               end if;
               
               Prev_C := C;
               Get(Read_File, C);
               
               case C.Status is
               when Success =>
                  MFB.Buffer(MFB.Length) := C.Item;
                  
                  if FirstByteFlag then
                     FirstByte := C.Item;
                  elsif SecondByteFlag then
                     SecondByte := C.Item;
                  elsif OtherByteFlag then
                     if FirstByte = Character'Val(16#FF#) and SecondByte = Character'Val(16#D8#) then
                        JPEG := True;
                     end if;
                  end if;
                  
                  if MFB.Length = ContentSize'Last then
                     MFB.Length := 0;
                  else
                     MFB.Length := MFB.Length + 1;
                  end if;
               when others =>
                  --TODO:ltj: close file nicely here.
                  Debug_Print("In reading file loop:");
                  Print_File_Status(C.Status);
                  return;
               end case;
               
               if FirstByteFlag and not SecondByteFlag and not OtherByteFlag then
                  FirstByteFlag := False;
                  SecondByteFlag := True;
                  OtherByteFlag := False;
               elsif not FirstByteFlag and SecondByteFlag and not OtherByteFlag then
                  FirstByteFlag := False;
                  SecondByteFlag := False;
                  OtherByteFlag := True;
               elsif not FirstByteFlag and not SecondByteFlag and OtherByteFlag then
                  FirstByteFlag := False;
                  SecondByteFlag := False;
                  OtherByteFlag := False;
               end if;
            else
               Debug_Print_Ln("End_of_File on Read_File");
               pragma Assert( not Is_Standard_File(Read_File) );
               if Is_Open (Read_File) then
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

--------------------------------------------------------------------------------
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

--------------------------------------------------------------------------------
   
end fileio;
