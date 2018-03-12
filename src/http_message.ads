with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;

with fileio; use fileio;
with config; use config;
WITH String_Types;

PACKAGE Http_Message IS
   package ST renames String_Types;

   TYPE ClientServerType IS (Client, Server);
   TYPE MethodType IS (NONE, GET, UNKNOWN, HEAD, POST,  --only http 1.0 for now
      PUT, DELETE, LINK, UNLINK);   --less common
   subtype Simple_Method_Type is MethodType range GET .. UNKNOWN;

   MaxHeaders : constant Natural := 32;

   TYPE HeaderType IS (ALLOW, AUTHORIZATION, CONTENT_ENCODING, CONTENT_LENGTH, CONTENT_TYPE,
      DATE, EXPIRES, FROM, IF_MODIFIED_SINCE, LAST_MODIFIED, LOCATION, PRAGM, REFERER, SERVER,
      USER_AGENT, WWW_AUTHENTICATE, UNKNOWN_HEADER,
         --less common
      ACCEP, ACCEPT_CHARSET, ACCEPT_ENCODING, ACCEPT_LANGUAGE, CONTENT_LANGUAGE, LINK, MIME_VERSION, RETRY_AFTER, TITLE, URI,
         --http 1.1
      ACCEPT_RANGES, AGE, CACHE_CONTROL, CONNECTION, CONTENT_LOCATION, CONTENT_MD5, CONTENT_RANGE, ETAG, EXPECT, HOST, IF_MATCH,
      IF_NONE_MATCH, IF_RANGE, IF_UNMODIFIED_SINCE, MAX_FORWARDS, PROXY_AUTHENTICATE, PROXY_AUTHORIZATION, RANG, TE, TRAILER,
      TRANSFER_ENCODING, UPGRADE, VARY, VIA, WARNING);

   --this must match size of HeaderType
   DistinctHeaders : CONSTANT Natural := HeaderType'Pos(HeaderType'Last)+1;

   TYPE Header IS RECORD
      Name: HeaderType;
      Value: ST.HeaderValueStringType;
   END RECORD;

   SUBTYPE MaxHeadersType IS Integer RANGE 0..MaxHeaders;
   TYPE HeaderArrayType IS ARRAY(1..MaxHeaders) OF Header;

   type Simple_HTTP_Request is
   record
      Method : Simple_Method_Type := UNKNOWN;
      RequestURI : ST.ParsedRequestURIStringType := (others=>' ');
   end record;

   type Simple_HTTP_Response is
   record
      --ltj: don't encode http version or status code because in MaspClassic, this is always HTTP/0.9 200 OK
      Content_Length : ContentSize := 0;
      Entity_Body : File_Buf := (others => NUL);
   end record;

   TYPE Http_Message_Variant_Record(ClientOrServer: ClientServerType) IS RECORD
      NumberOfHeaders: MaxHeadersType;
      Headers: HeaderArrayType;
      EntityBodyString: ST.EntityBodyStringType;
      FirstLineString: ST.FirstLineStringType;
      HttpVersionString: ST.HttpVersionStringType;
      CASE ClientOrServer IS
         WHEN Client =>
            Method: MethodType;
            RequestURIString: ST.RequestURIStringType;
         WHEN Server =>
            StatusCodeString: ST.StatusCodeStringType;
            ReasonPhraseString: ST.ReasonPhraseStringType;
      END CASE;
   END RECORD;

   BLANK_HEADER : CONSTANT Header := (Name => UNKNOWN_HEADER, Value => (OTHERS => ' '));
   BLANK_HTTP_MESSAGE : CONSTANT Http_Message_Variant_Record :=
      (ClientOrServer => Client,
      NumberOfHeaders => 0,
      FirstLineString => (OTHERS => ' '),
      HttpVersionString => (OTHERS => ' '),
      Headers => (OTHERS => BLANK_HEADER),
      EntityBodyString => (OTHERS => ' '),
      Method => NONE,
      RequestURIString => (OTHERS => ' '));

   function Construct_Simple_HTTP_Response(Page : String) return Simple_HTTP_Response
   with Pre => Page'Length <= MAX_FILE_READ_BYTE_CT;

   function Construct_Simple_HTTP_Response(MFB : Measured_File_Buffer) return Simple_HTTP_Response;

END Http_Message;

