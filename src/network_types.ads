PACKAGE Network_Types IS
   type Byte is mod 255;
   pragma Warnings(GNATprove, Off, "representation clause ok");
   for Byte'Size use 8;
   pragma Warnings(GNATprove, On, "representation clause ok");

   type Unsigned_Short is range 0 .. 2**16 - 1;
   --pragma Assert(Unsigned_Short'Base is Integer);
   pragma Warnings(GNATprove, Off, "representation clause ok");
   for Unsigned_Short'Size use 16;
   pragma Warnings(GNATprove, On, "representation clause ok");

   --max #bytes we can handle in an HTTP message
   LOG_MAX_HTTP_MSG_LENGTH : constant integer := 13;
   MAX_HTTP_MSG_LENGTH : CONSTANT Integer := 2**LOG_MAX_HTTP_MSG_LENGTH;
   type Message_Length_Range is range 1..MAX_HTTP_MSG_LENGTH;
   --pragma Assert(Message_Length_Range'Base is Integer);
   TYPE Byte_Array_Type IS ARRAY(Message_Length_Range) OF Byte;
   BLANK_BYTE_ARRAY : constant Byte_Array_Type := (others => 0);

end network_types;
