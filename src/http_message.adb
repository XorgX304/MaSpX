pragma SPARK_Mode(On);

package body http_message is

--------------------------------------------------------------------------------
   function Construct_Simple_HTTP_Response(Page : String) return Simple_HTTP_Response
   is
      Response : Simple_HTTP_Response;
   begin
      Append_Str(Response.Entity, Page);
      
      return Response;
   end Construct_Simple_HTTP_Response;

--------------------------------------------------------------------------------
   function Construct_Simple_HTTP_Response(Buf : Measured_Buffer_Type) return Simple_HTTP_Response
   is
      Response : Simple_HTTP_Response;
   begin
      Response.Entity := Buf;
      
      return Response;
   end Construct_Simple_HTTP_Response;

--------------------------------------------------------------------------------
   procedure Init(Header_Values : out Header_Values_Array_Type)
   is
   begin
      for Header in Header_Type'First .. Header_Type'Last loop
         Header_Values(Header).Buffer := (others => MEASURED_BUFFER_EMPTY_CHAR);
         Header_values(Header).Length := EMPTY_BUFFER_LENGTH;
      end loop;
   end Init;

--------------------------------------------------------------------------------
   procedure Craft_Status_Line(Buf : out Measured_Buffer_Type; Response : Simple_HTTP_Response)
   is
   begin
   
      case Response.Version is
      when HTTP_09 =>
         Set_Str(Buf, HTTP_VERSION_09_STR);
      when HTTP_10 =>
         Set_Str(Buf, HTTP_VERSION_10_STR);
      when HTTP_11 =>
         Set_Str(Buf, HTTP_VERSION_11_STR);
      when HTTP_2 =>
         Set_Str(Buf, HTTP_VERSION_2_STR);
      when others =>
         Set_Str(Buf, HTTP_VERSION_UNKNOWN_STR);
      end case;
      
      case Response.Status_Code is
      when c200_OK =>
         Append_Str(Buf, STATUS_LINE_200_STR);
      when c201_CREATED =>
         Append_Str(Buf, STATUS_LINE_201_STR);
      when c202_ACCEPTED =>
         Append_Str(Buf, STATUS_LINE_202_STR);
      when c204_NO_CONTENT =>
         Append_Str(Buf, STATUS_LINE_204_STR);
      when c300_MULTIPLE_CHOICES =>
         Append_Str(Buf, STATUS_LINE_300_STR);
      when c301_MOVED_PERMANENTLY =>
         Append_Str(Buf, STATUS_LINE_301_STR);
      when c302_MOVED_TEMPORARILY =>
         Append_Str(Buf, STATUS_LINE_302_STR);
      when c304_NOT_MODIFIED =>
         Append_Str(Buf, STATUS_LINE_304_STR);
      when c400_BAD_REQUEST =>
         Append_Str(Buf, STATUS_LINE_400_STR);
      when c401_UNAUTHORIZED =>
         Append_Str(Buf, STATUS_LINE_401_STR);
      when c403_FORBIDDEN =>
         Append_Str(Buf, STATUS_LINE_403_STR);
      when c404_NOT_FOUND =>
         Append_Str(Buf, STATUS_LINE_404_STR);
      when c500_INTERNAL_SERVER_ERROR =>
         Append_Str(Buf, STATUS_LINE_500_STR);
      when c501_NOT_IMPLEMENTED =>
         Append_Str(Buf, STATUS_LINE_501_STR);
      when c502_BAD_GATEWAY =>
         Append_Str(Buf, STATUS_LINE_502_STR);
      when c503_SERVICE_UNAVAILABLE =>
         Append_Str(Buf, STATUS_LINE_503_STR);
      end case;
      
      Append_Str(Buf, CRLF);
   end Craft_Status_Line;
   
--------------------------------------------------------------------------------
   procedure Craft_Headers(Buf: in out Measured_Buffer_Type; Response : Simple_HTTP_Response)
   is
   begin
      for Header in Response.Header_Values'First .. Response.Header_Values'Last loop
         pragma Loop_Invariant( Buf.Length <= HTTP_VERSION_10_STR'Length + STATUS_LINE_500_STR'Length + CRLF'Length +
                                              Header_Type'Pos(Header) * (IF_MODIFIED_SINCE_HEADER_STR'Length + COLON_SPACE'Length + MAX_HEADER_VALUE_BYTE_CT + CRLF'Length) );
         
         if not Is_Empty(Response.Header_Values(Header)) then
            pragma Assert( Response.Header_Values(Header).Length > EMPTY_BUFFER_LENGTH );
         
            case Header is
            when ALLOW_HEADER => 
               Append_Str(Buf, ALLOW_HEADER_STR);
            when AUTHORIZATION_HEADER =>
               Append_Str(Buf, AUTHORIZATION_HEADER_STR);
            when CONTENT_ENCODING_HEADER =>
               Append_Str(Buf, CONTENT_ENCODING_HEADER_STR);
            when CONTENT_LENGTH_HEADER =>
               Append_Str(Buf, CONTENT_LENGTH_HEADER_STR);
            when CONTENT_TYPE_HEADER =>
               Append_Str(Buf, CONTENT_TYPE_HEADER_STR);
            when DATE_HEADER =>
               Append_Str(Buf, DATE_HEADER_STR);
            when EXPIRES_HEADER =>
               Append_Str(Buf, EXPIRES_HEADER_STR);
            when FROM_HEADER =>
               Append_Str(Buf, FROM_HEADER_STR);
            when IF_MODIFIED_SINCE_HEADER =>
               Append_Str(Buf, IF_MODIFIED_SINCE_HEADER_STR);
            when LAST_MODIFIED_HEADER =>
               Append_Str(Buf, LAST_MODIFIED_HEADER_STR);
            when LOCATION_HEADER =>
               Append_Str(Buf, LOCATION_HEADER_STR);
            when PRAGMA_HEADER =>
               Append_Str(Buf, PRAGMA_HEADER_STR);
            when REFERER_HEADER =>
               Append_Str(Buf, REFERER_HEADER_STR);
            when SERVER_HEADER =>
               Append_Str(Buf, SERVER_HEADER_STR);
            when USER_AGENT_HEADER =>
               Append_Str(Buf, USER_AGENT_HEADER_STR);
            when WWW_AUTHENTICATE_HEADER =>
               Append_Str(Buf, WWW_AUTHENTICATE_HEADER_STR);
            when ACCEPT_HEADER =>
               Append_Str(Buf, ACCEPT_HEADER_STR);
            when ACCEPT_CHARSET_HEADER =>
               Append_Str(Buf, ACCEPT_CHARSET_HEADER_STR);
            when ACCEPT_ENCODING_HEADER =>
               Append_Str(Buf, ACCEPT_ENCODING_HEADER_STR);
            when ACCEPT_LANGUAGE_HEADER =>
               Append_Str(Buf, ACCEPT_LANGUAGE_HEADER_STR);
            when CONTENT_LANGUAGE_HEADER =>
               Append_Str(Buf, CONTENT_LANGUAGE_HEADER_STR);
            when LINK_HEADER =>
               Append_Str(Buf, LINK_HEADER_STR);
            when MIME_VERSION_HEADER =>
               Append_Str(Buf, MIME_VERSION_HEADER_STR);
            when RETRY_AFTER_HEADER =>
               Append_Str(Buf, RETRY_AFTER_HEADER_STR);
            when TITLE_HEADER =>
               Append_Str(Buf, TITLE_HEADER_STR);
            when URI_HEADER =>
               Append_Str(Buf, URI_HEADER_STR);
            end case;
            
            Append_Str(Buf, ": ");
            --ltj: print the value. should be same for all headers
            Append_Str(Buf, Get_String_Trunc(Response.Header_Values(Header)));
            Append_Str(Buf, CRLF);
         end if;
      end loop;
   end Craft_Headers;
   
end http_message;
