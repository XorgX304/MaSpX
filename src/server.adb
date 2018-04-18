pragma SPARK_Mode(On);

package body server is

   procedure Canonicalize_HTTP_Request(
      Parsed_Request : Parsed_HTTP_Request_Type;
      Canonicalized_Request : out Translated_HTTP_Request_Type)
   is
      Filename : Measured_Buffer_Type(MAX_FS_PATH_BYTE_CT, MEASURED_BUFFER_EMPTY_CHAR);
      Resolved_Filename : Measured_Buffer_Type(MAX_FS_PATH_BYTE_CT, MEASURED_BUFFER_EMPTY_CHAR);
   begin
      --construct name from web root and request uri
      Filename := Construct_Measured_Buffer(Filename.Size, Filename.EmptyChar, WEB_ROOT);
      Append_Str(Filename, Get_String(Parsed_Request.URI));
      Debug_Print_Ln("Filename: " & Get_String(Filename));
   
      --ltj: relevant: https://wiki.sei.cmu.edu/confluence/display/java/FIO16-J.+Canonicalize+path+names+before+validating+them
      --ltj: ignoring special files like links for now (not even sure if SPARK.Text_IO.Open deals with those...check impl)
      --ltj: convert all slashes to backslashes
      Replace_Char(Filename, '/', '\');
      --ltj: resolving ..'s and .'s 
      if Is_Delimits_Well_Formed(Filename, '\') and not Is_Empty(Filename) then
         Resolve_Special_Directories(Filename, Resolved_Filename);
         Canonicalized_Request.Path := Resolved_Filename;
         Canonicalized_Request.Canonicalized := True;
      else
         Canonicalized_Request.Path := Filename;
         Canonicalized_Request.Canonicalized := False;
      end if;
      
      Canonicalized_Request.Method := Parsed_Request.Method;
      Canonicalized_Request.Version := Parsed_Request.Version;
      Canonicalized_Request.Header_Values := Parsed_Request.Header_Values;
      Canonicalized_Request.Entity := Parsed_Request.Entity;
      Canonicalized_Request.Sanitary := False;
   end Canonicalize_HTTP_Request;
   
--------------------------------------------------------------------------------
   procedure Sanitize_HTTP_Request(
      Client_Socket : Socket_Type;
      Canonicalized_Request : Translated_HTTP_Request_Type;
      Clean_Request : out Translated_HTTP_Request_Type)
   is
      Response : HTTP_Response_Type;
   begin
      --ltj: check that web root prefix is present in canonicalized request uri, otherwise reject as forbidden
      if Canonicalized_Request.Canonicalized and then Has_Prefix(Canonicalized_Request.Path, WEB_ROOT) then
         Clean_Request.Method := Canonicalized_Request.Method;
         Clean_Request.Path := Canonicalized_Request.Path;
         Clean_Request.Version := Canonicalized_Request.Version;
         Clean_Request.Header_Values := Canonicalized_Request.Header_Values;
         Clean_Request.Entity := Canonicalized_Request.Entity;
         Clean_Request.Canonicalized := Canonicalized_Request.Canonicalized;
         Clean_Request.Sanitary := True;
      else
         Response := Construct_Simple_HTTP_Response(c403_FORBIDDEN_PAGE);
         Response.Status_Code := c403_FORBIDDEN;
         Send_HTTP_Response(Client_Socket, Response);
         
         Clean_Request.Method := Http_Message.UNKNOWN;
         Clear(Clean_Request.Path);
         Clean_Request.Version := HTTP_UNKNOWN;
         Init(Clean_Request.Header_Values);
         Clear(Clean_Request.Entity);
         Clean_Request.Canonicalized := False;
         Clean_Request.Sanitary := False;
      end if;
   end Sanitize_HTTP_Request;
   
--------------------------------------------------------------------------------
   procedure Fulfill_HTTP_Request(
      Client_Socket : Socket_Type;
      Clean_Request : Translated_HTTP_Request_Type)
   is
      Response : HTTP_Response_Type;
   begin
      Response.Version := HTTP_10;
      Set_Str(Response.Header_Values(SERVER_HEADER), "MaSp1.0 Development Version");
   
      case Clean_Request.Method is
      when Http_Message.UNKNOWN =>
         Response.Status_Code := c501_NOT_IMPLEMENTED;
         
      when Http_Message.GET =>            
         --ltj:get document from server:
         Read_File_To_Response(Get_String(Clean_Request.Path), Get_Extension(Clean_Request.Path), Response);
         
      when Http_Message.HEAD =>
         Measure_File_To_Response(Get_String(Clean_Request.Path), Get_Extension(Clean_Request.Path), Response);
         
      when Http_Message.POST =>
         null; --TODO:ltj: do something complex with request entity here
      end case;
      
      Send_HTTP_Response(Client_Socket, Response);
      
   end Fulfill_HTTP_Request;
   
end server;
