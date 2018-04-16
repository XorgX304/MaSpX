with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;

with config; use config;

package response_strs is

   --http versions
   HTTP_VERSION_09_STR : constant String := "HTTP/0.9";
   HTTP_VERSION_10_STR : constant String := "HTTP/1.0";
   HTTP_VERSION_11_STR : constant String := "HTTP/1.1";
   HTTP_VERSION_2_STR : constant String := "HTTP/2";
   HTTP_VERSION_UNKNOWN_STR : constant String := "HTTP/0.0";
   
   --statuses
   STATUS_LINE_200_STR : constant String := " 200 OK";
   STATUS_LINE_201_STR : constant String := " 201 Created";
   STATUS_LINE_202_STR : constant String := " 202 Accepted";
   STATUS_LINE_204_STR : constant String := " 204 No Content";
   STATUS_LINE_300_STR : constant String := " 300 Multiple Choices";
   STATUS_LINE_301_STR : constant String := " 301 Moved Permanently";
   STATUS_LINE_302_STR : constant String := " 302 Moved Temporarily";
   STATUS_LINE_304_STR : constant String := " 304 Not Modified";
   STATUS_LINE_400_STR : constant String := " 400 Bad Request";
   STATUS_LINE_401_STR : constant String := " 401 Unauthorized";
   STATUS_LINE_403_STR : constant String := " 403 Forbidden";
   STATUS_LINE_404_STR : constant String := " 404 Not Found";
   STATUS_LINE_500_STR : constant String := " 500 Internal Server Error";
   STATUS_LINE_501_STR : constant String := " 501 Not Implemented";
   STATUS_LINE_502_STR : constant String := " 502 Bad Gateway";
   STATUS_LINE_503_STR : constant String := " 503 Service Unavailable";
   
   --other
   CRLF : constant String := CR & LF;
   
   --headers (colon is added at crafting stage)
   ALLOW_HEADER_STR : constant String := "Allow";
   AUTHORIZATION_HEADER_STR : constant String := "Authorization";
   CONTENT_ENCODING_HEADER_STR : constant String := "Content-Encoding";
   CONTENT_LENGTH_HEADER_STR : constant String := "Content-Length";
   CONTENT_TYPE_HEADER_STR : constant String := "Content-Type";
   DATE_HEADER_STR : constant String := "Date";
   EXPIRES_HEADER_STR : constant String := "Expires";
   FROM_HEADER_STR : constant String := "From";
   IF_MODIFIED_SINCE_HEADER_STR : constant String := "If-Modified-Since";
   LAST_MODIFIED_HEADER_STR : constant String := "Last-Modified";
   LOCATION_HEADER_STR : constant String := "Location";
   PRAGMA_HEADER_STR : constant String := "Pragma";
   REFERER_HEADER_STR : constant String := "Referer";
   SERVER_HEADER_STR : constant String := "Server";
   USER_AGENT_HEADER_STR : constant String := "User-Agent";
   WWW_AUTHENTICATE_HEADER_STR : constant String := "WWW-Authenticate";
   ACCEPT_HEADER_STR : constant String := "Accept";
   ACCEPT_CHARSET_HEADER_STR : constant String := "Accept-Charset";
   ACCEPT_ENCODING_HEADER_STR : constant String := "Accept-Encoding";
   ACCEPT_LANGUAGE_HEADER_STR : constant String := "Accept-Language";
   CONTENT_LANGUAGE_HEADER_STR : constant String := "Content-Language";
   LINK_HEADER_STR : constant String := "Link";
   MIME_VERSION_HEADER_STR : constant String := "MIME-Version";
   RETRY_AFTER_HEADER_STR : constant String := "Retry-After";
   TITLE_HEADER_STR : constant String := "Title";
   URI_HEADER_STR : constant String := "URI";
   
   --static header values
   CONTENT_TYPE_IMAGE_JPEG_STR : constant String := "image/jpeg";
   CONTENT_TYPE_IMAGE_GIF_STR : constant String := "image/gif";
   CONTENT_TYPE_IMAGE_PNG_STR : constant String := "image/png";
   CONTENT_TYPE_IMAGE_BMP_STR : constant String := "image/bmp";
   CONTENT_TYPE_TEXT_HTML_STR : constant String := "text/html";
   CONTENT_TYPE_TEXT_PLAIN_STR : constant String := "text/plain";
   CONTENT_TYPE_TEXT_CSS_STR : constant String := "text/css";
   CONTENT_TYPE_APPLICATION_JS_STR : constant String := "application/javascript";
   CONTENT_TYPE_APPLICATION_OCTET_STREAM_STR : constant String := "application/octet-stream";
   
   --worst case max length of header portion of response
   --ltj: longest status line and every header used. This must be manually updated if more headers are added.
   MAX_STATUS_AND_HEADERS_LENGTH : constant Natural := 
      HTTP_VERSION_10_STR'Length + STATUS_LINE_500_STR'Length + CRLF'Length +
      --http/1.0
      ALLOW_HEADER_STR'Length + 2 + MAX_HEADER_VALUE_BYTE_CT + CRLF'Length +
      AUTHORIZATION_HEADER_STR'Length + 2 + MAX_HEADER_VALUE_BYTE_CT + CRLF'Length +
      CONTENT_ENCODING_HEADER_STR'Length + 2 + MAX_HEADER_VALUE_BYTE_CT + CRLF'Length +
      CONTENT_LENGTH_HEADER_STR'Length + 2 + MAX_HEADER_VALUE_BYTE_CT + CRLF'Length +
      CONTENT_TYPE_HEADER_STR'Length + 2 + MAX_HEADER_VALUE_BYTE_CT + CRLF'Length +
      DATE_HEADER_STR'Length + 2 + MAX_HEADER_VALUE_BYTE_CT + CRLF'Length +
      EXPIRES_HEADER_STR'Length + 2 + MAX_HEADER_VALUE_BYTE_CT + CRLF'Length +
      FROM_HEADER_STR'Length + 2 + MAX_HEADER_VALUE_BYTE_CT + CRLF'Length +
      IF_MODIFIED_SINCE_HEADER_STR'Length + 2 + MAX_HEADER_VALUE_BYTE_CT + CRLF'Length +
      LAST_MODIFIED_HEADER_STR'Length + 2 + MAX_HEADER_VALUE_BYTE_CT + CRLF'Length +
      LOCATION_HEADER_STR'Length + 2 + MAX_HEADER_VALUE_BYTE_CT + CRLF'Length +
      PRAGMA_HEADER_STR'Length + 2 + MAX_HEADER_VALUE_BYTE_CT + CRLF'Length +
      REFERER_HEADER_STR'Length + 2 + MAX_HEADER_VALUE_BYTE_CT + CRLF'Length +
      SERVER_HEADER_STR'Length + 2 + MAX_HEADER_VALUE_BYTE_CT + CRLF'Length +
      USER_AGENT_HEADER_STR'Length + 2 + MAX_HEADER_VALUE_BYTE_CT + CRLF'Length +
      WWW_AUTHENTICATE_HEADER_STR'Length + 2 + MAX_HEADER_VALUE_BYTE_CT + CRLF'Length +
      ACCEPT_HEADER_STR'Length + 2 + MAX_HEADER_VALUE_BYTE_CT + CRLF'Length +
      ACCEPT_CHARSET_HEADER_STR'Length + 2 + MAX_HEADER_VALUE_BYTE_CT + CRLF'Length +
      ACCEPT_ENCODING_HEADER_STR'Length + 2 + MAX_HEADER_VALUE_BYTE_CT + CRLF'Length +
      ACCEPT_LANGUAGE_HEADER_STR'Length + 2 + MAX_HEADER_VALUE_BYTE_CT + CRLF'Length +
      CONTENT_LANGUAGE_HEADER_STR'Length + 2 + MAX_HEADER_VALUE_BYTE_CT + CRLF'Length +
      LINK_HEADER_STR'Length + 2 + MAX_HEADER_VALUE_BYTE_CT + CRLF'Length +
      RETRY_AFTER_HEADER_STR'Length + 2 + MAX_HEADER_VALUE_BYTE_CT + CRLF'Length +
      TITLE_HEADER_STR'Length + 2 + MAX_HEADER_VALUE_BYTE_CT + CRLF'Length +
      URI_HEADER_STR'Length + 2 + MAX_HEADER_VALUE_BYTE_CT + CRLF'Length +
      CRLF'LENGTH; -- 2 

end response_strs;
