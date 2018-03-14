pragma SPARK_Mode(On);

package config is

   DEBUG_PRINT_ON : constant Boolean := True;
   --TODO:ltj: move this to a config file
   WEB_ROOT : constant String := "D:\OneDrive\OneDrive\ChthonianCyberServices\ada\masp\test-web-root"; --ltj: 1. no trailing slash (we concatenate the Request-URI to this directly) 2. must be absolute path
   --WEB_ROOT : constant String := "../test-web-root"; --the above actually works
   DEFAULT_PAGE : constant String := "index.html"; 
   --TODO:ltj: move MAX_..._CTs here?

end config;
