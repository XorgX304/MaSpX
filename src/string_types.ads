with config; use config;
with measured_buffer; use measured_buffer;

PACKAGE String_Types IS
   SUBTYPE String4 IS String(1..4);
   SUBTYPE String8 IS String(1..8);
   SUBTYPE String16 IS String(1..16);
   SUBTYPE String32 IS String(1..32);
   SUBTYPE String64 IS String(1..64);
   SUBTYPE String128 IS String(1..128);
   SUBTYPE String255 is String(1..255);
   SUBTYPE String256 IS String(1..256);
   SUBTYPE String512 IS String(1..512);
   SUBTYPE String1024 IS String(1..1024);
   SUBTYPE String2048 IS String(1..2048);
   SUBTYPE String32K IS String(1..32*1024);

   subtype FirstLineStringType is String128;
   subtype HeaderNameStringType IS String32;
   subtype HeaderValueStringType IS String128;
   subtype EntityBodyStringType IS String32K;
   subTYPE HttpVersionStringType IS String8;
   subTYPE MethodStringType is String8;
   subTYPE RequestURIStringType IS String(1 .. MAX_URI_BYTE_CT); -- RFC 2616:3.2.1 - a warning note that servers should be careful with URI's longer than 255 bytes which some older browsers may not handle.
   subtype ParsedRequestURIStringType is String(1 .. MAX_PARSED_URI_BYTE_CT); --     ^-- this warning probably is not applicable in the year 2018, but for MaspClassic let's honor it.
   subTYPE StatusCodeStringType IS String4;
   subTYPE ReasonPhraseStringType IS String32;
END String_Types;

