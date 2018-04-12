pragma SPARK_Mode(On);

package body server is

   procedure Canonicalize_HTTP_Request(
      Parsed_Request : Parsed_Simple_Request;
      Canonicalized_Request : out Translated_Simple_Request)
   is
      Filename : Measured_Buffer_Type(MAX_FS_PATH_BYTE_CT, NUL);
      Resolved_Filename : Measured_Buffer_Type(MAX_FS_PATH_BYTE_CT, NUL);
   begin
      --construct name from web root and request uri
      Filename := Construct_Measured_Buffer(Filename.Size, Filename.EmptyChar, WEB_ROOT);
      Append_Str(Filename, Get_String(Parsed_Request.URI));
      Debug_Print_Ln("Filename: " & Get_String(Filename));
   
      --ltj: relevant: https://wiki.sei.cmu.edu/confluence/display/java/FIO16-J.+Canonicalize+path+names+before+validating+them
      --ltj: ignoring special files like links for now (not even sure if SPARK.Text_IO.Open deals with those...check impl)
      --ltj: convert all slashes to backslashes
      Replace_Char(Filename, '/', '\');
      --TODO:ltj: insert guards for precond of Resolve...
      --ltj: resolving ..'s and .'s 
      if Is_Delimits_Well_Formed(Filename, '\') and not Is_Empty(Filename) then
         Resolve_Special_Directories(Filename, Resolved_Filename);
         Canonicalized_Request.Path := Resolved_Filename;
         Canonicalized_Request.Canonicalized := True;
      else
         Canonicalized_Request.Path := Filename;
         Canonicalized_Request.Canonicalized := False;
      end if;
      
      --ltj: copy intermediary_buf to Canonicalized_Request
      Canonicalized_Request.Method := Parsed_Request.Method;
      Canonicalized_Request.Sanitary := False;
   end Canonicalize_HTTP_Request;
   
--------------------------------------------------------------------------------
   procedure Sanitize_HTTP_Request(
      Client_Socket : Socket_Type;
      Canonicalized_Request : Translated_Simple_Request;
      Clean_Request : out Translated_Simple_Request)
   is
      Response : Simple_HTTP_Response;
   begin
      --ltj: check that web root prefix is present in canonicalized request uri, otherwise reject as forbidden
      if Is_Prefixed(Canonicalized_Request.Path, WEB_ROOT) then
         Clean_Request.Method := Canonicalized_Request.Method;
         Clean_Request.Path := Canonicalized_Request.Path;
         Clean_Request.Canonicalized := Canonicalized_Request.Canonicalized;
         Clean_Request.Sanitary := True;
      else
         Response := Construct_Simple_HTTP_Response(c403_FORBIDDEN_PAGE);
         Send_Simple_Response(Client_Socket, Response);
         
         Clean_Request.Method := Http_Message.UNKNOWN;
         Clean_Request.Path.Buffer := (others=>NUL);
         Clean_Request.Path.Length := 0;
         Clean_Request.Canonicalized := False;
         Clean_Request.Sanitary := False;
      end if;
   end Sanitize_HTTP_Request;
   
--------------------------------------------------------------------------------
   procedure Fulfill_HTTP_Request(
      Client_Socket : Socket_Type;
      Clean_Request : Translated_Simple_Request)
   is
      Response : Simple_HTTP_Response;
      Buf : Measured_Buffer_Type(MAX_FILE_READ_BYTE_CT, NUL);
      ContentType : ContentTypeType;
      Fileio_Error : Fileio_Error_Type;
   begin
      case Clean_Request.Method is
         when Http_Message.UNKNOWN =>
            Response := Construct_Simple_HTTP_Response(c501_NOT_IMPLEMENTED_PAGE);
            
         when Http_Message.GET =>
            --get document from server:
            Read_File_To_Buffer(Get_String(Clean_Request.Path), Buf, ContentType, Fileio_Error);
            
            case Fileio_Error is
            when No_Error =>
               Response := Construct_Simple_HTTP_Response(Buf);
               Response.Content_Type := ContentType;
            when Buffer_Full_Error =>
               Response := Construct_Simple_HTTP_Response(c500_SERVER_ERROR_PAGE);
               Response.Content_Type := HTML_TYPE;
            when Not_Found_Error =>
               Response := Construct_Simple_HTTP_Response(c404_NOT_FOUND_PAGE);
               Response.Content_Type := HTML_TYPE;
            when Conflict_Error =>
               Response := Construct_Simple_HTTP_Response(c409_CONFLICT_PAGE);
               Response.Content_Type := HTML_TYPE;
            when Unexpected_Error =>
               Response := Construct_Simple_HTTP_Response(c500_SERVER_ERROR_PAGE);
               Response.Content_Type := HTML_TYPE;
            end case;
      end case;
      
      Send_Simple_Response(Client_Socket, Response);
      
   end Fulfill_HTTP_Request;
   
end server;
