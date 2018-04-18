pragma SPARK_Mode(On);

with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;

with config; use config;
with String_Types;
with measured_buffer; use measured_buffer;
with response_strs; use response_strs;

package Http_Message is
   package ST renames String_Types;

   type ClientServerType is (Client, Server);
   type MethodType is (NONE, GET, UNKNOWN, HEAD, POST,  --only http 1.0 for now
      PUT, DELETE, LINK, UNLINK);   --less common
   subtype Simple_Method_Type is MethodType range GET .. POST;

   type Header_Type is (ALLOW_HEADER, AUTHORIZATION_HEADER, CONTENT_ENCODING_HEADER, CONTENT_LENGTH_HEADER, CONTENT_TYPE_HEADER,
      DATE_HEADER, EXPIRES_HEADER, FROM_HEADER, IF_MODIFIED_SINCE_HEADER, LAST_MODIFIED_HEADER, LOCATION_HEADER, PRAGMA_HEADER, REFERER_HEADER, SERVER_HEADER,
      USER_AGENT_HEADER, WWW_AUTHENTICATE_HEADER,
         --less common
      ACCEPT_HEADER, ACCEPT_CHARSET_HEADER, ACCEPT_ENCODING_HEADER, ACCEPT_LANGUAGE_HEADER, CONTENT_LANGUAGE_HEADER, LINK_HEADER, MIME_VERSION_HEADER, RETRY_AFTER_HEADER, TITLE_HEADER, URI_HEADER);
         --http 1.1
      --ACCEPT_RANGES_HEADER, AGE_HEADER, CACHE_CONTROL_HEADER, CONNECTION_HEADER, CONTENT_LOCATION_HEADER, CONTENT_MD5_HEADER, CONTENT_RANGE_HEADER, ETAG_HEADER, EXPECT_HEADER, HOST_HEADER, IF_MATCH_HEADER,
      --IF_NONE_MATCH_HEADER, IF_RANGE_HEADER, IF_UNMODIFIED_SINCE_HEADER, MAX_FORWARDS_HEADER, PROXY_AUTHENTICATE_HEADER, PROXY_AUTHORIZATION_HEADER, RANG_HEADER, TE_HEADER, TRAILER_HEADER,
      --TRANSFER_ENCODING_HEADER, UPGRADE_HEADER, VARY_HEADER, VIA_HEADER, WARNING_HEADER);

   type Header_Values_Array_Type is array (Header_Type range Header_Type'First .. Header_Type'Last) of Measured_Buffer_Type(MAX_HEADER_VALUE_BYTE_CT, MEASURED_BUFFER_EMPTY_CHAR);

   type HTTP_Version_Type is (HTTP_09, HTTP_10, HTTP_11, HTTP_2, HTTP_0_UNKNOWN, HTTP_1_UNKNOWN, HTTP_2_UNKNOWN, HTTP_UNKNOWN);

   --ltj: Making this a variant record raises some flow issues that are impossible to get around.
   ---    Just creating different types instead.
   type Parsed_HTTP_Request_Type is
   record
      Method : Simple_Method_Type := UNKNOWN;
      URI : Measured_Buffer_Type(MAX_PARSED_URI_BYTE_CT, MEASURED_BUFFER_EMPTY_CHAR);
      Version : HTTP_Version_Type;
      Header_Values : Header_Values_Array_Type;
      Entity : Measured_Buffer_Type(MAX_FILE_READ_BYTE_CT, MEASURED_BUFFER_EMPTY_CHAR);
   end record;

   type Translated_HTTP_Request_Type is
   record
      Method : Simple_Method_Type := UNKNOWN;
      Path : Measured_Buffer_Type(MAX_FS_PATH_BYTE_CT, MEASURED_BUFFER_EMPTY_CHAR);
      Version : HTTP_Version_Type;
      Header_Values : Header_Values_Array_Type;
      Entity : Measured_Buffer_Type(MAX_FILE_READ_BYTE_CT, MEASURED_BUFFER_EMPTY_CHAR);
      Canonicalized : Boolean := False;
      Sanitary : Boolean := False;
   end record;

   type Status_Code_Type is (c200_OK, c201_CREATED, c202_ACCEPTED, c204_NO_CONTENT,
                             c300_MULTIPLE_CHOICES, c301_MOVED_PERMANENTLY, c302_MOVED_TEMPORARILY, c304_NOT_MODIFIED,
                             c400_BAD_REQUEST, c401_UNAUTHORIZED, c403_FORBIDDEN, c404_NOT_FOUND,
                             c500_INTERNAL_SERVER_ERROR, c501_NOT_IMPLEMENTED, c502_BAD_GATEWAY, c503_SERVICE_UNAVAILABLE
                             );

   type HTTP_Response_Type is
   record
      Version : HTTP_Version_Type := HTTP_10;
      Status_Code : Status_Code_Type := c200_OK;
      Header_Values : Header_Values_Array_Type;
      Entity : Measured_Buffer_Type(MAX_FILE_READ_BYTE_CT, MEASURED_BUFFER_EMPTY_CHAR); --ltj:in this case, NUL is a possible legitimate member of the buffer.
   end record;

   function Construct_Simple_HTTP_Response(Page : String) return HTTP_Response_Type
   with Pre => Page'Length <= MAX_FILE_READ_BYTE_CT and
               Page'Length >= 1;

   function Construct_Simple_HTTP_Response(Buf : Measured_Buffer_Type) return HTTP_Response_Type
   with Global => null,
        Pre => Buf.Max_Size = MAX_FILE_READ_BYTE_CT and
               Buf.EmptyChar = MEASURED_BUFFER_EMPTY_CHAR;

   procedure Init(Header_Values : out Header_Values_Array_Type)
   with Global => null;

   procedure Craft_Status_Line(Buf : out Measured_Buffer_Type; Response : HTTP_Response_Type)
   with Global => null,
        Pre => Buf.Max_Size = MAX_RESPONSE_LENGTH,
        Post => Buf.Length <= HTTP_VERSION_10_STR'Length + STATUS_LINE_500_STR'Length + CRLF'Length;

   procedure Craft_Headers(Buf: in out Measured_Buffer_Type; Response : HTTP_Response_Type)
   with Global => null,
        Pre => Buf.Max_Size = MAX_RESPONSE_LENGTH and
               Buf.Length <= HTTP_VERSION_10_STR'Length + STATUS_LINE_500_STR'Length + CRLF'Length;

end Http_Message;

