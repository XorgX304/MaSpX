pragma SPARK_Mode(On);

package body http_message is

   function Construct_Simple_HTTP_Response(Page : String) return Simple_HTTP_Response
   is
      Response : Simple_HTTP_Response;
   begin
      Append_Str(Response.Entity, Page);
      
      return Response;
   end Construct_Simple_HTTP_Response;
   
   function Construct_Simple_HTTP_Response(Buf : Measured_Buffer_Type) return Simple_HTTP_Response
   is
      Response : Simple_HTTP_Response;
   begin
      Response.Entity := Buf;
      
      return Response;
   end Construct_Simple_HTTP_Response;
   
end http_message;
