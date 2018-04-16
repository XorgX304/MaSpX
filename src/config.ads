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
   
   --buffer limits
   MAX_FILE_READ_BYTE_CT : constant Natural := 5_000_000;--ltj: arbitrary
   MAX_RESPONSE_LENGTH : constant Natural := 4000 + MAX_FILE_READ_BYTE_CT;
   MAX_HEADER_VALUE_BYTE_CT : constant Natural := 128; --ltj: arbitrary
   MAX_REQUEST_LINE_BYTE_CT : constant Natural := 270;  --ltj: RFC1945:5.1 3 for Method (always GET) 1 for Space, 255 for request-uri, 2 for proper line ending
   MAX_URI_BYTE_CT : constant Natural := 255;
   MAX_PARSED_URI_BYTE_CT : constant Natural := MAX_URI_BYTE_CT + DEFAULT_PAGE'Length - 1;
   MAX_FS_PATH_BYTE_CT : constant Positive := WEB_ROOT'Length + MAX_PARSED_URI_BYTE_CT;

end config;
