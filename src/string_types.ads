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
END String_Types;

