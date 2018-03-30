pragma SPARK_Mode(On);

package body parsing is

   procedure Get_First_Token_In_Range(
      Source_Buf : Measured_Buffer_Type;
      Delimit : Character;
      Start : Max_Buffer_Size_Type;
      Finish : Max_Buffer_Size_Type;
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
   function Get_All_Request_Tokens(
      Raw_Request : Measured_Buffer_Type;
      Delimit : Character) return Tokens_Request_Array_Type
   is
      Tokens : Tokens_Request_Array_Type(1 .. Get_Token_Ct(Raw_Request, Delimit));
      Token_Buf : Measured_Buffer_Type(MAX_REQUEST_LINE_BYTE_CT, NUL);
      Start : Max_Buffer_Size_Type := Raw_Request.Buffer'First;
      C : Character;
   begin   
      for I in Tokens'Range loop
         Clear(Token_Buf);
         pragma Assert( Token_Buf.Length = 0 );
      
         for J in Start .. Raw_Request.Length loop
            pragma Assert( Start >= Raw_Request.Buffer'First and then
                           J >= Start );
                                      
            C := Raw_Request.Buffer(J);
         
            if C = Delimit then
               if J + 1 <= Raw_Request.Length then
                  Start := J + 1;
                  pragma Assert(Start > Raw_Request.Buffer'First);
               else
                  return Tokens;
               end if;
               
               exit;
            end if;
         
            Append(Token_Buf, C);
            pragma Loop_Invariant( Token_Buf.Length <= J and then
                                   Start >= Raw_Request.Buffer'First and then
                                   J >= Start);
         end loop;
         
         Tokens(I) := Token_Buf;
         
         pragma Loop_Invariant( Start >= Raw_Request.Buffer'First );
      end loop;
      
      return Tokens;
   end Get_All_Request_Tokens;

--------------------------------------------------------------------------------
   function Is_Delimits_Well_Formed(
      Source_Buf : Measured_Buffer_Type;
      Delimit : Character) return Boolean
   is
      C : Character;
      Prev_C : Character := Source_Buf.EmptyChar;
   begin    
      for I in Source_Buf.Buffer'Range loop
         C := Source_Buf.Buffer(I);
         
         if C = Delimit and Prev_C = Delimit then
            return False;
         end if;
         
         Prev_C := C;
      end loop;
      
      return True;
   end Is_Delimits_Well_Formed;

--------------------------------------------------------------------------------
   function Is_Leading_Delimit(
      Source_Buf : Measured_Buffer_Type;
      Delimit : Character) return Boolean
   is
   begin
      if Source_Buf.Length = 0 or Source_Buf.Size = 0 then
         return False;
      end if;
      
      return Source_Buf.Buffer(1) = Delimit;
   end Is_Leading_Delimit;

--------------------------------------------------------------------------------
   function Get_Token_Ct(
      Source_Buf : Measured_Buffer_Type;
      Delimit : Character) return Max_Buffer_Size_Type
   is
      C : Character;
      Is_Delimit : Boolean := True;
      Token_Ct : Max_Buffer_Size_Type := 0;
   begin
      for I in Source_Buf.Buffer'Range loop
         C := Source_Buf.Buffer(I);
         
         if C = Delimit and not Is_Delimit then
            Is_Delimit := True;
         elsif C /= Delimit and Is_Delimit then
            Token_Ct := Token_Ct + 1;
            Is_Delimit := False;
         end if;
         
         pragma Loop_Invariant(Token_Ct <= I);
      end loop;
      
      return Token_Ct;
   end Get_Token_Ct;

--------------------------------------------------------------------------------
   function Tokenize_Request_Buffer( 
      Raw_Request : Measured_Buffer_Type;
      Delimit : Character) return Tokens_Request_Array_Type
   is
      Tokens : Tokens_Request_Array_Type(1 .. Get_Token_Ct(Raw_Request, Delimit));
      Token_Buf : Measured_Buffer_Type(Raw_Request.Size, Raw_Request.EmptyChar);
      Start : Max_Buffer_Size_Type := 1;
      Finish : Max_Buffer_Size_Type := Raw_Request.Length;
   begin
   
      for I in Tokens'Range loop
         Get_First_Token_In_Range(Raw_Request,Delimit,Start,Finish,Token_Buf);
         Tokens(I) := Token_Buf;
         
         Start := Start + Token_Buf.Length + 1; --ltj: plus one for the delimiter           
      end loop;
      
      return Tokens;
   end Tokenize_Request_Buffer;

--------------------------------------------------------------------------------
--     procedure Parse_HTTP_Request(
--        Client_Socket : GNAT.Sockets.Socket_Type;
--        Raw_Request : Measured_Buffer_Type;
--        Parsed_Request : out Simple_HTTP_Request;
--        Exception_Raised : out Boolean)
--     is
--        Token_Buf : Measured_Buffer_Type(Raw_Request.Size, Raw_Request.EmptyChar);
--        Response : Simple_HTTP_Response;
--     begin
--        Exception_Raised := False;
--        Parsed_Request.RequestURI := (others=>' ');
--        Parsed_Request.Method := Http_Message.UNKNOWN;
--        
--        if not Is_Delimits_Well_Formed(Raw_Request, ' ') then
--           Response := Construct_Simple_HTTP_Response(c400_BAD_REQUEST_PAGE);
--           Send_Simple_Response(Client_Socket, Response);
--           Exception_Raised := True;
--           return;
--        end if;
--     
--        --tokenize what should be the http METHOD
--        Get_First_Token_In_Range(
--           Raw_Request,
--           ' ',
--           Raw_Request.Buffer'First,
--           Raw_Request.Length,
--           Token_Buf
--        );
--        Debug_Print_Ln("Debugging: Tokenized METHOD:" & Get_String(Token_Buf));
--        
--        --ltj: not even sure this is possible!
--  --        if Token_First_Empty_Index = 0 or Token_First_Empty_Index >= Raw_Request.Buffer'Last - 2 then
--  --           Check_Print_Ln("MaSpX: First token in request too big for a second token! Sending 400 Bad Request.");
--  --           Response := Construct_Simple_HTTP_Response(c400_BAD_REQUEST_URI_PAGE);
--  --           Send_Simple_Response(Client_Socket, Response);
--  --           Exception_Raised := True;
--  --           return;
--  --        end if;
--        
--        --parse to "GET" or "UNKNOWN" in http message
--        if Get_String(Token_Buf) = GET_TOKEN_STR then
--           Parsed_Request.Method := Http_Message.GET;
--           
--           --tokenize what should be http REQUEST-URI
--           Get_First_Token_In_Range(
--              Raw_Request,
--              ' ',
--              Token_Buf.Length + 2, --ltj:one to skip space and one to get to next char
--              Raw_Request.Length,
--              Token_Buf
--           );
--           Debug_Print_Ln("Debugging: Tokenized URI:" & Get_String(Token_Buf));
--        
--           --ltj: if tokenized uri is larger than possible space in request URI, throw error
--           if Token_Buf.Length > RequestURIStringType'Last then
--              Check_Print_Ln("MaSpX: Tokenized URI is larger than space possible to fit it! Sending 400 Bad Request (URI).");
--              Response := Construct_Simple_HTTP_Response(c400_BAD_REQUEST_URI_PAGE);
--              Send_Simple_Response(Client_Socket, Response);
--              Exception_Raised := True;
--              return;
--           end if;
--           
--           --ltj: stick URI in parsed_request, sanitize at later stage. This only doesn't cut stuff off because we make sure of it in the last bit of code.
--           --Parsed_Request.RequestURI(RequestURIStringType'First .. RequestURIStringType'Last) := Token_Buf.Buffer(RequestURIStringType'First .. RequestURIStringType'Last);
--           Parsed_Request.RequestURI(RequestURIStringType'First .. Token_Buf.Length) := Get_String(Token_Buf);
--           --ltj: Add DEFAULT_PAGE if request is for directory.
--           if not Is_Empty(Token_Buf) then
--              if Parsed_Request.RequestURI(Token_Buf.Length) = '/' or Parsed_Request.RequestURI(Token_Buf.Length) = '\' then
--                 Parsed_Request.RequestURI(Token_Buf.Length + 1 .. Token_Buf.Length + 1 + DEFAULT_PAGE'Length - 1) := DEFAULT_PAGE;
--              end if;
--           else --ltj: Token_First_Empty_Index will never equal 0 here because this path requires that there be a first token and if there is a first token, the second token will not take up the whole string
--              --ltj: throw some error about no URI
--              Check_Print_Ln("MaSpX: missing second token! Sending 400 Bad Request (URI).");
--              Response := Construct_Simple_HTTP_Response(c400_BAD_REQUEST_URI_PAGE);
--              Send_Simple_Response(Client_Socket, Response);
--              Exception_Raised := True;
--              return;
--           end if;
--        else
--           Parsed_Request.Method := Http_Message.UNKNOWN;
--        end if;
--        
--        
--     end Parse_HTTP_Request;

   procedure Parse_HTTP_Request(
      Client_Socket : GNAT.Sockets.Socket_Type; -- pre Open (but network code..)
      Raw_Request : Measured_Buffer_Type;
      Parsed_Request : out Simple_HTTP_Request;
      Exception_Raised : out Boolean)
   is
      Delimit : Character := ' ';
      Tokens : Tokens_Request_Array_Type(1 .. Get_Token_Ct(Raw_Request, ' '));
      Response : Simple_HTTP_Response;
   begin
      Parsed_Request.Method := Http_Message.UNKNOWN;
      Parsed_Request.RequestURI := (others=>Raw_Request.EmptyChar);
      Exception_Raised := False;
      
      if Tokens'Length < 2 or not Is_Delimits_Well_Formed(Raw_Request, Delimit) 
      or Is_Leading_Delimit(Raw_Request, Delimit) then
         Response := Construct_Simple_HTTP_Response(c400_BAD_REQUEST_PAGE);
         Send_Simple_Response(Client_Socket, Response);
         Exception_Raised := True;
         return;
      end if;
      
      Tokens := Get_All_Request_Tokens(Raw_Request, Delimit);
      
      --Get_String(Tokens(1))
   end Parse_HTTP_Request;

end parsing;
