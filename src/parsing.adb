pragma SPARK_Mode(On);

package body parsing is

   procedure Get_First_Token_In_Range(
      Source : String;
      Delimit : Character;
      Start : Positive;
      Finish : Positive;
      Token_String : out String;
      Token_First_Empty_Index : out Natural)
      --TODO:ltj: add Success : out Boolean?
   is
   begin
      Token_String := (others=>' ');
      Token_First_Empty_Index := 1;
   
      for I in Integer range Start .. Finish loop
         --TODO:ltj: this isn't the best solution to leading delimiters possible... think of something more robust
         if Source(I) = Delimit then
            exit;
         end if;
         
         if Token_First_Empty_Index = 0 then
            exit;
         elsif Token_First_Empty_Index <= Token_String'Last and Token_First_Empty_Index >= Token_String'First then
            Token_String(Token_First_Empty_Index) := Source(I);
            
            if Token_First_Empty_Index /= Token_String'Last then
               Token_First_Empty_Index := Token_First_Empty_Index + 1;
            else
               Token_First_Empty_Index := 0;
            end if;
         end if;
      end loop;
   end Get_First_Token_In_Range;
   
--------------------------------------------------------------------------------
   procedure Get_First_Token_In_Range_COPY_ALT(
      Source : String;
      Delimit : Character;
      Start : Positive;
      Finish : Positive;
      Token_String : out String;
      Token_First_Empty_Index : out Natural)
   is
      First_Delimit_Index : Natural;
      Length : Natural;
   begin
      Token_String := (others=>Delimit);
      
      First_Delimit_Index := Get_First_Delimit_Index_In_Range(Source, Delimit, Start, Finish);
      Debug_Print_Ln("Debugging: First_Delimit_Index: " & Natural'Image(First_Delimit_Index));
      
      --TODO:ltj: make functions that make this understandable Get_Len(Start, Finish), Get_Finish(Start, Len)
      if First_Delimit_Index = 0 then
         Debug_Print_Ln("Debugging: In First_Delimit_Index case 0");
         Length := Finish - Start + 1;
         Token_String(Token_String'First .. Token_String'First + Length - 1) := Source(Start .. Finish);
         --Assert(Is_Substring(Source(Start .. Finish), Source);
      else
         Debug_Print_Ln("Debugging: In First_Delimit_Index case other");
         Length := First_Delimit_Index - 1 - Start + 1;
         Token_String(Token_String'First .. Token_String'First + Length - 1) := Source (Start .. First_Delimit_Index - 1);
      end if;
      
      Token_First_Empty_Index := Token_String'First + Length;
      
      if Token_First_Empty_Index > Token_String'Last then
         Token_First_Empty_Index := 0;
      end if;
   end Get_First_Token_In_Range_COPY_ALT;

--------------------------------------------------------------------------------
   function Get_First_Delimit_Index_In_Range(
      Source : String;
      Delimit : Character;
      Start : Positive;
      Finish : Positive) return Natural
   is
   begin
      for I in Natural range Start .. Finish loop
         if Source(I) = Delimit then
            return I;
         end if;
      end loop;
      
      return 0;
   end Get_First_Delimit_Index_In_Range;

--------------------------------------------------------------------------------
   function Is_Substring(
      Substring : String;
      Source : String) return Boolean
   is
   begin
      for I in Source'Range loop
         if Check_Substring(Substring, I, Source) then
            return True;
         end if;
         
         pragma Loop_Invariant( for all J in Source'First .. I => not Check_Substring(Substring, J, Source) );
      end loop;
      
      return False;
   end Is_Substring;

--------------------------------------------------------------------------------
   function Check_Substring(
      Substring : String;
      Start : Positive;
      Source : String) return Boolean
   is
   begin
      --for I in Substring'Range loop
      --   if Substring(I) /= Source(I + Start - 1) then
      --      return False;
      --   end if;
      --end loop;
      
      --return True;
      
      if Source'Last < Positive'Last - Substring'Length - 1 then
         if Start + Substring'Length - 1 <= Source'Last then
            return Substring = Source(Start .. Start + Substring'Length - 1);
         else
            return False;
         end if;
      else
         Check_Print_Ln("BOUNDS WARNING:parsing.adb:Check_Substring!");
         return False;
      end if;
   end Check_Substring;

--------------------------------------------------------------------------------
   procedure Parse_HTTP_Request(
      Client_Socket : GNAT.Sockets.Socket_Type;
      Raw_Request : Measured_Request_Buffer;
      Parsed_Request : out Simple_HTTP_Request;
      Exception_Raised : out Boolean)
   is
      Token_String : Simple_Request_Line;
      Token_First_Empty_Index : Natural;
      Response : Simple_HTTP_Response;
   begin
      Exception_Raised := False;
      Parsed_Request.RequestURI := (others=>' ');
      Parsed_Request.Method := Http_Message.UNKNOWN;
   
      --tokenize what should be the http METHOD
      Get_First_Token_In_Range_COPY_ALT(
         Raw_Request.Buffer,
         ' ',
         Raw_Request.Buffer'First,
         Raw_Request.Length - 1,
         Token_String,
         Token_First_Empty_Index
      );
      Debug_Print_Ln("Debugging: Tokenized METHOD:" & Token_String);
      
      if Token_First_Empty_Index = 0 or Token_First_Empty_Index >= Raw_Request.Buffer'Last - 2 then
         Check_Print_Ln("MaSpX: First token in request too big for a second token! Sending 400 Bad Request.");
         Response := Construct_Simple_HTTP_Response(c400_BAD_REQUEST_URI_PAGE);
         Send_Simple_Response(Client_Socket, Response);
         Exception_Raised := True;
         return;
      end if;
      
      --parse to "GET" or "UNKNOWN" in http message
      if Token_String = GET_TOKEN_REQUEST_LINE then
         Parsed_Request.Method := Http_Message.GET;
         
         --tokenize what should be http REQUEST-URI
         Get_First_Token_In_Range_COPY_ALT(
            Raw_Request.Buffer,
            ' ',
            Token_First_Empty_Index + 1,  --First_Empty_Index is the delimiter between tokens. Add one to get first character of new token.
            Raw_Request.Length - 1,
            Token_String,
            Token_First_Empty_Index
         );
         Debug_Print_Ln("Debugging: Tokenized URI:" & Token_String);
      
         --ltj: if tokenized uri is larger than possible space in request URI, throw error
         if Token_First_Empty_Index - 1 > RequestURIStringType'Last then
            Check_Print_Ln("MaSpX: Tokenized URI is larger than space possible to fit it! Sending 400 Bad Request (URI).");
            Response := Construct_Simple_HTTP_Response(c400_BAD_REQUEST_URI_PAGE);
            Send_Simple_Response(Client_Socket, Response);
            Exception_Raised := True;
            return;
         end if;
         
         --ltj: stick URI in parsed_request, sanitize at later stage. This only doesn't cut stuff off because we make sure of it in the last bit of code.
         Parsed_Request.RequestURI(RequestURIStringType'First .. RequestURIStringType'Last) := Token_String(RequestURIStringType'First .. RequestURIStringType'Last);
         --ltj: Add DEFAULT_PAGE if request is for directory.
         if Token_First_Empty_Index > 1 then
            if Parsed_Request.RequestURI(Token_First_Empty_Index - 1) = '/' or Parsed_Request.RequestURI(Token_First_Empty_Index - 1) = '\' then
               Parsed_Request.RequestURI(Token_First_Empty_Index .. Token_First_Empty_Index + DEFAULT_PAGE'Length - 1) := DEFAULT_PAGE;
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
