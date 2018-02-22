pragma SPARK_Mode(On);

--TODO: SPARKify
package body parsing is

   procedure Get_First_Token_In_Range(
      Source : Request_Line;
      Delimit : Character;
      Start : Positive;
      Finish : Positive;
      Token : out Measured_Request_Buffer)
   is
   begin
      Token.Buffer := (others=>' ');
      Token.Length := 1;
   
      --check input to function, esp Start and Finish
      if Start > Source'Last or Finish > Source'Last then
         Token.Length := 0;
         return;
      end if;
   
      for I in Integer range Start .. Finish loop
         --TODO:ltj: this isn't the best solution to leading delimiters possible... think of something more robust
         if Source(I) = Delimit then
            exit;
         end if;
         
         if Token.Length <= Token.Buffer'Last and Token.Length /= 0 then
            Token.Buffer(Token.Length) := Source(I);
            Token.Length := Token.Length + 1;
         end if;
      end loop;
   end Get_First_Token_In_Range;

--------------------------------------------------------------------------------
   procedure Parse_HTTP_Request(
      Raw_Request : Measured_Request_Buffer;
      Parsed_Request : out Simple_HTTP_Request)
   is
      Token : Measured_Request_Buffer;
   begin
      Parsed_Request.RequestURI := (others=>' ');
   
      --tokenize what should be the http METHOD
      Get_First_Token_In_Range(
         Raw_Request.Buffer,
         ' ',
         Raw_Request.Buffer'First,
         Raw_Request.Buffer'Last,
         Token
      );
      Put_line("Debugging: Tokenized METHOD:" & Token.Buffer);
      
      --parse to "GET" or "UNKNOWN" in http message
      if Token.Buffer = GET_TOKEN_REQUEST_LINE then
         Parsed_Request.Method := Http_Message.GET;
      else
         Parsed_Request.Method := Http_Message.UNKNOWN;
      end if;
      
      if Token.Length < Http_Message.RequestURIStringType'Last then
         --tokenize what should be http REQUEST-URI
         Get_First_Token_In_Range(
            Raw_Request.Buffer,
            ' ',
            Raw_Request.Buffer'First + Token.Length,
            Raw_Request.Buffer'Last,
            Token
         );
         Put_Line("Debugging: Tokenized URI:" & Token.Buffer);
      
         --stick URI in parsed_request, sanitize at later stage
         --ltj: shouldn't be cutting anything off...
         Parsed_Request.RequestURI := Token.Buffer(Http_Message.RequestURIStringType'First .. Http_Message.RequestURIStringType'Last);
      end if;
   end Parse_HTTP_Request;
   
end parsing;
