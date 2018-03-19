pragma SPARK_Mode(On);

package body server is

   procedure Canonicalize_HTTP_Request(
      Parsed_Request : Simple_HTTP_Request;
      Canonicalized_Request : out Simple_HTTP_Request)
   is
      Intermediary_String : ParsedRequestURIStringType;
   begin
      Canonicalized_Request.Method := Http_Message.UNKNOWN;
      Canonicalized_Request.RequestURI := (others=>' ');
   
      --ltj: relevant: https://wiki.sei.cmu.edu/confluence/display/java/FIO16-J.+Canonicalize+path+names+before+validating+them
      --ltj: ignoring special files like links for now (not even sure if SPARK.Text_IO.Open deals with those...check impl)
      --ltj: convert all slashes to backslashes
      for I in Parsed_Request.RequestURI'Range loop
         if Parsed_Request.RequestURI(I) = '/' then
            Intermediary_String(I) := '\';
         else
            Intermediary_String(I) := Parsed_Request.RequestURI(I);
         end if;
      end loop;
      --TODO:ltj: resolving ..'s and .'s (use get token with \ as delimit...)
      
      --ltj: copy intermediary_string to Canonicalized_Request
      Canonicalized_Request.Method := Parsed_Request.Method;
      Canonicalized_Request.RequestURI := Intermediary_String;
   end Canonicalize_HTTP_Request;
   
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
      MFT : Measured_Filename_Type;
      MFB : Measured_File_Buffer;
   begin
      case Clean_Request.Method is
         when Http_Message.UNKNOWN =>
            Response := Construct_Simple_HTTP_Response(c400_BAD_REQUEST_PAGE);
            
         when Http_Message.GET =>
            --get document from server:
            
            --construct name from web root and request uri
            MFT := Construct_Measured_Filename(Clean_Request.RequestURI);
            Debug_Print_Ln("Filename: " & MFT.Name);
            
            Read_File_To_MFB(MFT, MFB);
            
            Response := Construct_Simple_HTTP_Response(MFB);
      end case;
      
      Send_Simple_Response(Client_Socket, Response);
      
   end Fulfill_HTTP_Request;
   
end server;
