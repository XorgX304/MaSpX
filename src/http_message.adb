pragma SPARK_Mode(On);

package body http_message is

   function Construct_Simple_HTTP_Response(Page : String) return Simple_HTTP_Response
   is
      Response : Simple_HTTP_Response;
   begin
      Response.Content_Length := Page'Length;
      Response.Entity_Body(Page'Range) := Page;
      
      return Response;
   end Construct_Simple_HTTP_Response;
   
   function Construct_Simple_HTTP_Response(MFB : Measured_File_Buffer) return Simple_HTTP_Response
   is
      Response : Simple_HTTP_Response;
   begin
      Response.Content_Length := MFB.Length;
      Response.Entity_Body := MFB.Buffer;
      
      return Response;
   end Construct_Simple_HTTP_Response;
   
end http_message;
