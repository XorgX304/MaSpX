pragma SPARK_Mode(On);

with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;

package config is

   DEBUG_PRINT_ON : constant Boolean := True;
   
   --TODO:ltj: move this to a config file
   HTTP_PORT : constant Natural := 80;
   MAX_CXNS : constant Natural := 16; --ltj: arbitrary   
   WEB_ROOT : constant String := "D:\OneDrive\OneDrive\ChthonianCyberServices\ada\masp\test-web-root";--ltj: 1. no trailing slash (we concatenate the Request-URI to this directly) 2. must be absolute path
   FS_ROOT : constant String := "D:";
   DEFAULT_PAGE : constant String := "index.html";
   
   STATUS_LINE_200_10 : constant String := "HTTP/1.0 200 OK";
   CRLF : constant String := CR & LF;
   LINE_ENDING_LENGTH : constant Natural := 2;
   --header strings
   --ACCEPT_RANGES_HEADER : constant String := "Accept-Ranges: bytes";
   CONTENT_LENGTH_HEADER : constant String := "Content-Length:";
   CONTENT_TYPE_HEADER : constant String := "Content-Type:";
   CONTENT_TYPE_IMAGE_JPEG : constant String := " image/jpeg";
   CONTENT_TYPE_TEXT_HTML : constant String := " text/html";
   CONTENT_TYPE_APPLICATION_OCTET_STREAM : constant String := " application/octet-stream";
   
   MAX_STATUS_AND_HEADERS_LENGTH : constant Natural := 
      STATUS_LINE_200_10'Length + 
      CONTENT_LENGTH_HEADER'Length + Natural'Image(Natural'Last)'Length + LINE_ENDING_LENGTH + --ltj: not exact since we are using natural instead of the max file size
      CONTENT_TYPE_HEADER'Length + CONTENT_TYPE_APPLICATION_OCTET_STREAM'Length + LINE_ENDING_LENGTH + --ltj: note that we use the longest of the content type values
      LINE_ENDING_LENGTH;
      
                             

end config;
