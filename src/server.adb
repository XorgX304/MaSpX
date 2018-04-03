pragma SPARK_Mode(On);

package body server is

   procedure Canonicalize_HTTP_Request(
      Parsed_Request : Simple_HTTP_Request;
      Canonicalized_Request : out Simple_HTTP_Request)
   is
      Filename : Measured_Buffer_Type(MAX_FS_PATH_BYTE_CT, NUL);
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
      Resolve_Special_Directories(Filename);
      
      --ltj: copy intermediary_buf to Canonicalized_Request
      Canonicalized_Request.Method := Parsed_Request.Method;
      Canonicalized_Request.Path := Filename;
   end Canonicalize_HTTP_Request;
   
--------------------------------------------------------------------------------
   procedure Sanitize_HTTP_Request(
      Client_Socket : Socket_Type;
      Canonicalized_Request : Simple_HTTP_Request;
      Clean_Request : out Simple_HTTP_Request;
      Unsanitary_Request : out Boolean)
   is
      Response : Simple_HTTP_Response;
   begin
      Unsanitary_Request := False;
   
      --ltj: check that web root prefix is present in canonicalized request uri, otherwise reject as forbidden
      if Is_Prefixed(Canonicalized_Request.Path, WEB_ROOT) then
         Clean_Request.Method := Canonicalized_Request.Method;
         Clean_Request.Path := Canonicalized_Request.Path;
      else
         Response := Construct_Simple_HTTP_Response(c403_FORBIDDEN_PAGE);
         Send_Simple_Response(Client_Socket, Response);
         Unsanitary_Request := True;
      end if;
   end Sanitize_HTTP_Request;
   
--------------------------------------------------------------------------------
   procedure Fulfill_HTTP_Request(
      Client_Socket : Socket_Type;
      Clean_Request : Simple_HTTP_Request)
   is
      Response : Simple_HTTP_Response;
      MFB : Measured_File_Buffer; --TODO:ltj: convert to Measured_Buffer_Type
      JPEG : Boolean;
   begin
      case Clean_Request.Method is
         when Http_Message.UNKNOWN =>
            Response := Construct_Simple_HTTP_Response(c400_BAD_REQUEST_PAGE);
            
         when Http_Message.GET =>
            --get document from server:
            Read_File_To_MFB(Get_String(Clean_Request.Path), MFB, JPEG);
            
            Response := Construct_Simple_HTTP_Response(MFB);
            if JPEG then
               Response.Content_Type := JPG;
            else
               Response.Content_Type := HTML;
            end if;
      end case;
      
      Send_Simple_Response(Client_Socket, Response);
      
   end Fulfill_HTTP_Request;
   
end server;
