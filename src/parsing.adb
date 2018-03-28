pragma SPARK_Mode(On);

package body parsing is

   procedure Get_First_Token_In_Range(
      Source_Buf : Measured_Buffer_Type;
      Delimit : Character;
      Start : Positive;
      Finish : Positive;
      Token_Buf : out Measured_Buffer_Type)
      --TODO:ltj: add Success : out Boolean?
   is
   begin
      Clear(Token_Buf);
      pragma Assert( Token_Buf.Length = 0 );
      
      for I in Integer range Start .. Finish loop
         --TODO:ltj: this isn't the best solution to leading/multiple-adjacent delimiters possible... think of something more robust
         if Source_Buf.Buffer(I) = Delimit then
            return;
         end if;
         
         Append(Token_Buf, Source_Buf.Buffer(I));
         
         pragma Loop_Invariant( Token_Buf.Length <= I );
      end loop;
   end Get_First_Token_In_Range;
   
--------------------------------------------------------------------------------
--     function Tokenize_Request_Buffer( 
--        Raw_Request : Measured_Buffer_Type;
--        Delimit : Character) return Tokens_Request_Array_Type
--     is
--        
--     begin
--        null;
--     end Tokenize_Request_Buffer;

--------------------------------------------------------------------------------
   procedure Parse_HTTP_Request(
      Client_Socket : GNAT.Sockets.Socket_Type;
      Raw_Request : Measured_Buffer_Type;
      Parsed_Request : out Simple_HTTP_Request;
      Exception_Raised : out Boolean)
   is
      Token_Buf : Measured_Buffer_Type(Raw_Request.Size, Raw_Request.EmptyChar);
      Response : Simple_HTTP_Response;
   begin
      Exception_Raised := False;
      Parsed_Request.RequestURI := (others=>' ');
   
      --tokenize what should be the http METHOD
      Get_First_Token_In_Range(
         Raw_Request,
         ' ',
         Raw_Request.Buffer'First,
         Raw_Request.Length - 1,
         Token_Buf
      );
      Debug_Print_Ln("Debugging: Tokenized METHOD:" & Get_String(Token_Buf));
      
      --ltj: not even sure this is possible!
--        if Token_First_Empty_Index = 0 or Token_First_Empty_Index >= Raw_Request.Buffer'Last - 2 then
--           Check_Print_Ln("MaSpX: First token in request too big for a second token! Sending 400 Bad Request.");
--           Response := Construct_Simple_HTTP_Response(c400_BAD_REQUEST_URI_PAGE);
--           Send_Simple_Response(Client_Socket, Response);
--           Exception_Raised := True;
--           return;
--        end if;
      
      --parse to "GET" or "UNKNOWN" in http message
      if Get_String(Token_Buf) = GET_TOKEN_STR then
         Parsed_Request.Method := Http_Message.GET;
         
         --tokenize what should be http REQUEST-URI
         Get_First_Token_In_Range(
            Raw_Request,
            ' ',
            Token_Buf.Length + 2, --ltj:one to skip space and one to get to next char
            Raw_Request.Length,
            Token_Buf
         );
         Debug_Print_Ln("Debugging: Tokenized URI:" & Get_String(Token_Buf));
      
         --ltj: if tokenized uri is larger than possible space in request URI, throw error
         if Token_Buf.Length > RequestURIStringType'Last then
            Check_Print_Ln("MaSpX: Tokenized URI is larger than space possible to fit it! Sending 400 Bad Request (URI).");
            Response := Construct_Simple_HTTP_Response(c400_BAD_REQUEST_URI_PAGE);
            Send_Simple_Response(Client_Socket, Response);
            Exception_Raised := True;
            return;
         end if;
         
         --ltj: stick URI in parsed_request, sanitize at later stage. This only doesn't cut stuff off because we make sure of it in the last bit of code.
         --Parsed_Request.RequestURI(RequestURIStringType'First .. RequestURIStringType'Last) := Token_Buf.Buffer(RequestURIStringType'First .. RequestURIStringType'Last);
         Parsed_Request.RequestURI(RequestURIStringType'First .. Token_Buf.Length) := Get_String(Token_Buf);
         --ltj: Add DEFAULT_PAGE if request is for directory.
         if not Is_Empty(Token_Buf) then
            if Parsed_Request.RequestURI(Token_Buf.Length) = '/' or Parsed_Request.RequestURI(Token_Buf.Length) = '\' then
               Parsed_Request.RequestURI(Token_Buf.Length + 1 .. Token_Buf.Length + 1 + DEFAULT_PAGE'Length - 1) := DEFAULT_PAGE;
            end if;
         else --ltj: Token_First_Empty_Index will never equal 0 here because this path requires that there be a first token and if there is a first token, the second token will not take up the whole string
            --ltj: throw some error about no URI
            Check_Print_Ln("MaSpX: missing second token! Sending 400 Bad Request (URI).");
            Response := Construct_Simple_HTTP_Response(c400_BAD_REQUEST_URI_PAGE);
            Send_Simple_Response(Client_Socket, Response);
            Exception_Raised := True;
            return;
         end if;
      else
         Parsed_Request.Method := Http_Message.UNKNOWN;
      end if;
      
      
   end Parse_HTTP_Request;
   
end parsing;
