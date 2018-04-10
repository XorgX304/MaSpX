pragma SPARK_Mode(On);

package config is

   DEBUG_PRINT_ON : constant Boolean := True;
   
   --TODO:ltj: move this to a config file
   HTTP_PORT : constant Natural := 80;
   MAX_CXNS : constant Natural := 16; --ltj: arbitrary   
   WEB_ROOT : constant String := "D:\OneDrive\OneDrive\ChthonianCyberServices\ada\masp\test-web-root";--ltj: 1. no trailing slash (we concatenate the Request-URI to this directly) 2. must be absolute path
   FS_ROOT : constant String := "D:";
   DEFAULT_PAGE : constant String := "index.html"; 

end config;
