pragma SPARK_Mode(On);

--TODO: SPARKify
package body parsing is

   procedure Get_First_Token_In_Range(
      Source : Simple_Request_Line;
      Delimit : Character;
      Start : Positive;
      Finish : Positive;
      Token : out Measured_Request_Buffer)
      --TODO:ltj: add Success : out Boolean?
   is
   begin
      Token.Buffer := (others=>' ');
      Token.Length := 1;
   
      --TODO:ltj: move to precondition?
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
         
         --TODO:ltj: analyze the implications of this if-guard. Really ought to change .Length to .First_Empty_Index
         if Token.Length < Token.Buffer'Last and Token.Length /= 0 then
            Token.Buffer(Token.Length) := Source(I);
            Token.Length := Token.Length + 1; --ltj: SPARK note: changed if-guard from <= to < to accomodate new Token.Length type
         end if;
      end loop;
   end Get_First_Token_In_Range;

--------------------------------------------------------------------------------
   procedure Parse_HTTP_Request(
      Client_Socket : GNAT.Sockets.Socket_Type;
      Raw_Request : Measured_Request_Buffer;
      Parsed_Request : out Simple_HTTP_Request;
      Exception_Raised : out Boolean)
   is
      Token : Measured_Request_Buffer;
      Response : Simple_HTTP_Response;
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
      Debug_Print_Ln("Debugging: Tokenized METHOD:" & Token.Buffer);
      
      --parse to "GET" or "UNKNOWN" in http message
      if Token.Buffer = GET_TOKEN_REQUEST_LINE then
         Parsed_Request.Method := Http_Message.GET;
      else
         Parsed_Request.Method := Http_Message.UNKNOWN;
      end if;
      
      if Token.Length < String_Types.RequestURIStringType'Last then
         --tokenize what should be http REQUEST-URI
         Get_First_Token_In_Range(
            Raw_Request.Buffer,
            ' ',
            Raw_Request.Buffer'First + Token.Length,
            Raw_Request.Buffer'Last,
            Token
         );
         Debug_Print_Ln("Debugging: Tokenized URI:" & Token.Buffer);
      
         --ltj: if tokenized uri is larger than possible space in request URI, throw error
         if Token.Length - 1 > RequestURIStringType'Last then
            Response := Construct_Simple_HTTP_Response(c400_BAD_REQUEST_URI_PAGE);
            Send_Simple_Response(Client_Socket, Response);
            Exception_Raised := True;
            return;
         end if;
         
         --ltj: stick URI in parsed_request, sanitize at later stage. Add DEFAULT_PAGE if request is for directory.
         Parsed_Request.RequestURI(RequestURIStringType'First .. RequestURIStringType'Last) := Token.Buffer(RequestURIStringType'First .. RequestURIStringType'Last);
         if Token.Length >= 2 then
            if Parsed_Request.RequestURI(Token.Length - 1) = '/' or Parsed_Request.RequestURI(Token.Length - 1) = '\' then
               Parsed_Request.RequestURI(Token.Length .. Token.Length + DEFAULT_PAGE'Length - 1) := DEFAULT_PAGE;
            end if;
         else
            --ltj: throw some error about no URI
            Response := Construct_Simple_HTTP_Response(c400_BAD_REQUEST_URI_PAGE);
            Send_Simple_Response(Client_Socket, Response);
            Exception_Raised := True;
            return;
         end if;
      end if;
   end Parse_HTTP_Request;
   
end parsing;
