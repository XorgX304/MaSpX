pragma SPARK_Mode(On);

package body server is

   procedure Canonicalize_HTTP_Request(
      Parsed_Request : Simple_HTTP_Request;
      Canonicalized_Request : out Simple_HTTP_Request)
   is
      Intermediary_Buf : Measured_Buffer_Type(MAX_PARSED_URI_BYTE_CT, NUL);
   begin
      pragma Assert( Intermediary_Buf.Size = Parsed_Request.RequestURI.Size );
      Intermediary_Buf := Parsed_Request.RequestURI;
      
      pragma Assert( Intermediary_Buf.Length = Parsed_Request.RequestURI.Length and
                     Intermediary_Buf.Length <= Intermediary_Buf.Size );
   
      --ltj: relevant: https://wiki.sei.cmu.edu/confluence/display/java/FIO16-J.+Canonicalize+path+names+before+validating+them
      --ltj: ignoring special files like links for now (not even sure if SPARK.Text_IO.Open deals with those...check impl)
      --ltj: convert all slashes to backslashes
      Replace_Char(Intermediary_Buf, '/', '\');
      --TODO:ltj: resolving ..'s and .'s (use get token with \ as delimit...)
      
      --ltj: copy intermediary_string to Canonicalized_Request
      Canonicalized_Request.Method := Parsed_Request.Method;
      Canonicalized_Request.RequestURI := Intermediary_Buf;
   end Canonicalize_HTTP_Request;
   
--------------------------------------------------------------------------------
   procedure Sanitize_HTTP_Request(
      Canonicalized_Request : Simple_HTTP_Request;
      Clean_Request : out Simple_HTTP_Request)
   is
   begin
      --TODO:ltj: check that web root prefix is present in canonicalized request uri, otherwise reject as forbidden
      Clean_Request.Method := Canonicalized_Request.Method;
      Clean_Request.RequestURI := Canonicalized_Request.RequestURI;
   end Sanitize_HTTP_Request;
   
--------------------------------------------------------------------------------
   procedure Fulfill_HTTP_Request(
      Client_Socket : Socket_Type;
      Clean_Request : Simple_HTTP_Request)
   is
      Response : Simple_HTTP_Response;
      --MFT : Measured_Filename_Type;
      Filename : Measured_Buffer_Type(MAX_FS_PATH_BYTE_CT, NUL);
      MFB : Measured_File_Buffer;
   begin
      case Clean_Request.Method is
         when Http_Message.UNKNOWN =>
            Response := Construct_Simple_HTTP_Response(c400_BAD_REQUEST_PAGE);
            
         when Http_Message.GET =>
            --get document from server:
            
            --construct name from web root and request uri
            --MFT := Construct_Measured_Filename(Clean_Request.RequestURI);
            Filename := Construct_Measured_Buffer(Filename.Size, Filename.EmptyChar, WEB_ROOT);
            Append_Str(Filename, Get_String(Clean_Request.RequestURI)); --TODO:ltj:might need if-guard for this
            Debug_Print_Ln("Filename: " & Get_String(Filename));
            
            Read_File_To_MFB(Get_String(Filename), MFB);
            
            Response := Construct_Simple_HTTP_Response(MFB);
      end case;
      
      Send_Simple_Response(Client_Socket, Response);
      
   end Fulfill_HTTP_Request;
   
end server;
