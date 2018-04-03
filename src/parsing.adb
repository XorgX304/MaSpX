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
                  Start := Raw_Request.Length + 1; --ltj: to skip inner loop
               end if;
               
               exit;
            end if;
         
            Append(Token_Buf, C);
            pragma Loop_Invariant( Token_Buf.Length <= J and then
                                   Start >= Raw_Request.Buffer'First and then
                                   J >= Start and then
                                   Token_Buf.Length <= Token_Buf.Size);
         end loop;
         
         Tokens(I) := Token_Buf;
         
         pragma Loop_Invariant( Start >= Raw_Request.Buffer'First and
                                (for all K in Tokens'First .. I => Tokens(K).Length <= Tokens(K).Size) );
      end loop;
      
      pragma Assert( for all K in Tokens'Range => Tokens(K).Length <= Tokens(K).Size );
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
   procedure Parse_HTTP_Request(
      Client_Socket : GNAT.Sockets.Socket_Type; -- pre Open (but network code..)
      Raw_Request : Measured_Buffer_Type;
      Parsed_Request : out Simple_HTTP_Request;
      Exception_Raised : out Boolean)
   is
      Delimit : Character := ' ';
      Tokens : Tokens_Request_Array_Type(1 .. Get_Token_Ct(Raw_Request, ' '));
      Method_Token : Measured_Buffer_Type(MAX_REQUEST_LINE_BYTE_CT, NUL);
      URI_Token : Measured_Buffer_Type(MAX_REQUEST_LINE_BYTE_CT, NUL);
      Response : Simple_HTTP_Response;
   begin
      Parsed_Request.Method := Http_Message.UNKNOWN;
      Clear(Parsed_Request.RequestURI);
      Exception_Raised := False;
      
      if Tokens'Length < 2 or not Is_Delimits_Well_Formed(Raw_Request, Delimit) 
      or Is_Leading_Delimit(Raw_Request, Delimit) then
         Response := Construct_Simple_HTTP_Response(c400_BAD_REQUEST_PAGE);
         Send_Simple_Response(Client_Socket, Response);
         Exception_Raised := True;
         return;
      end if;
      
      Tokens := Get_All_Request_Tokens(Raw_Request, Delimit);
      pragma Assert( for all I in Tokens'Range => Tokens(I).Length <= Tokens(I).Size );
      
      pragma Assert( Method_Token.Size = Tokens(1).Size and
                     Method_Token.EmptyChar = Tokens(1).EmptyChar and
                     URI_Token.Size = Tokens(2).Size and
                     URI_Token.EmptyChar = Tokens(2).EmptyChar);
                     
      Method_Token := Tokens(1);
      pragma Assert( Tokens(1).Length <= Tokens(1).Size and then
                     Method_Token.Length = Tokens(1).Length and then
                     Method_Token.Length <= Method_Token.Size );
                     
      URI_Token := Tokens(2);
      pragma Assert( Tokens(2).Length <= Tokens(2).Size and then
                     URI_Token.Length = Tokens(2).Length and then
                     URI_Token.Length <= URI_Token.Size );
      
      if Get_String(Method_Token) = GET_TOKEN_STR then
         Parsed_Request.Method := Http_Message.GET;
      else
         Parsed_Request.Method := Http_Message.UNKNOWN;
      end if;
      
      if URI_Token.Length > Parsed_Request.RequestURI.Size - DEFAULT_PAGE'Length or Is_Empty(URI_Token) then
         Response := Construct_Simple_HTTP_Response(c400_BAD_REQUEST_URI_PAGE);
         Send_Simple_Response(Client_Socket, Response);
         Exception_Raised := True;
         return;
      end if;
      
      if Peek(URI_Token) = '/' or Peek(URI_Token) = '\' then
         Append_Str(URI_Token, DEFAULT_PAGE);
      end if;
      
      Copy(Parsed_Request.RequestURI, URI_Token);
   end Parse_HTTP_Request;

end parsing;
