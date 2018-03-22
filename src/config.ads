pragma SPARK_Mode(On);

package config is

   DEBUG_PRINT_ON : constant Boolean := True;
   
   HTTP_PORT : constant Natural := 80;
   MAX_CXNS : constant Natural := 16; --arbitrary
   
   --TODO:ltj: move this to a config file
   WEB_ROOT : constant String := "D:\OneDrive\OneDrive\ChthonianCyberServices\ada\masp\test-web-root"; --ltj: 1. no trailing slash (we concatenate the Request-URI to this directly) 2. must be absolute path
   DEFAULT_PAGE : constant String := "index.html"; 
   
   --error pages
   c400_BAD_REQUEST_PAGE : constant String := "400 Bad Request";
   c400_BAD_REQUEST_URI_PAGE : constant String := "400 Bad Request (URI)";

end config;
