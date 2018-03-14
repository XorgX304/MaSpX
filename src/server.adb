pragma SPARK_Mode(On);

package body server is
   
--     procedure Sanitize_HTTP_Request(
--        Unclean_Request : Simple_HTTP_Request;
--        Clean_Request : out Simple_HTTP_Request)
--     is
--     begin
--        null;
--     end Sanitize_HTTP_Request;
   
--------------------------------------------------------------------------------
   procedure Fulfill_HTTP_Request(
      Client_Socket : Socket_Type;
      Request : Simple_HTTP_Request)
   is
      Response : Simple_HTTP_Response;
      MFT : Measured_Filename_Type;
      MFB : Measured_File_Buffer;
   begin
      case Request.Method is
         when Http_Message.UNKNOWN =>
            Response := Construct_Simple_HTTP_Response(STATIC_UNKNOWN_METHOD_RESPONSE_09);
            
         when Http_Message.GET =>
            --get document from server:
            
            --construct name from web root and request uri
            MFT := Construct_Measured_Filename(Request.RequestURI);
            Debug_Print_Ln("Filename: " & MFT.Name);
            
            Read_File_To_MFB(MFT, MFB);
            
            Response := Construct_Simple_HTTP_Response(MFB);
      end case;
      
      Send_Simple_Response(Client_Socket, Response);
      
   end Fulfill_HTTP_Request;
   
end server;
