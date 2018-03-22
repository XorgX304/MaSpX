with config; use config;
with utils; use utils;

package measured_buffer_type is

   MAX_REQUEST_LINE_BYTE_CT : constant Natural := 270;  -- RFC1945:5.1 3 for Method (always GET) 1 for Space, 255 for request-uri, 2 for proper line ending
   MAX_FILE_READ_BYTE_CT : constant Natural := 10000;
   MAX_URI_BYTE_CT : constant Natural := 255;
   MAX_PARSED_URI_BYTE_CT : constant Natural := MAX_URI_BYTE_CT + DEFAULT_PAGE'Length - 1;
   subtype Max_Buffer_Size_Type is Natural range Natural'First .. Natural'Max(Natural'Max(MAX_REQUEST_LINE_BYTE_CT, MAX_FILE_READ_BYTE_CT), Natural'Max(MAX_URI_BYTE_CT, MAX_PARSED_URI_BYTE_CT)); --ltj:set to the largest of the above constants
   EMPTY_BUFFER_LENGTH : constant Natural := 0;
   type Measured_Buffer_Type(Size : Max_Buffer_Size_Type; EmptyChar : Character) is tagged private;
   
   function Is_Left_Neighbor_EmptyChar_And_This_Isnt(Buf : Measured_Buffer_Type; Idx : Max_Buffer_Size_Type) return Boolean
   with Global => null,
        Pre => Idx >= Positive'First and Idx <= Buf.Size;
        
   function Is_Right_Neighbor_EmptyChar_And_This_Isnt(Buf : Measured_Buffer_Type; Idx : Max_Buffer_Size_Type) return Boolean
   with Global => null,
        Pre => Idx >= Positive'First and Idx <= Buf.Size;
        
   function Is_Contiguous(Buf : Measured_Buffer_Type) return Boolean
   with Global => null,
        Post => (if Is_Contiguous'Result then
                    ((for all I in Positive'First .. Buf.Size => not Buf.Is_Left_Neighbor_EmptyChar_And_This_Isnt(I)) and
                    (for all I in Positive'First .. Buf.Size => not Buf.Is_Right_Neighbor_EmptyChar_And_This_Isnt(I))) or
                    (for some I in Positive'First .. Buf.Size =>
                        (for all J in Positive'First .. Buf.Size => Logical_Equivalence(Buf.Is_Left_Neighbor_EmptyChar_And_This_Isnt(J),  J = I))) or
                    (for some I in Positive'First .. Buf.Size =>
                        (for all J in Positive'First .. Buf.Size => Logical_Equivalence(Buf.Is_Right_Neighbor_EmptyChar_And_This_Isnt(J), J = I))));
   
   function Get_Char(Buf : Measured_Buffer_Type; Idx : Max_Buffer_Size_Type) return Character
   with Global => null,
        Pre => Idx >= Positive'First and Idx <= Buf.Size;
   
   function Is_Aligned(Buf : Measured_Buffer_Type) return Boolean
   with Global => null,
        Pre => Buf.Is_Contiguous;
   
   function Calc_Length(Buf : Measured_Buffer_Type) return Max_Buffer_Size_Type
   with Global => null;
   
   function Get_Length(Buf : Measured_Buffer_Type) return Max_Buffer_Size_Type
   with Global => null,
        Post => Get_Length'Result = Buf.Calc_Length;
   
   function Is_Empty(Buf : Measured_Buffer_Type) return Boolean
   with Global => null,
        Post => (if Is_Empty'Result then
                    Buf.Get_Length = EMPTY_BUFFER_LENGTH
                 else
                    Buf.Get_Length /= EMPTY_BUFFER_LENGTH);
                
                
   
   function Append(Buf : Measured_Buffer_Type; C : Character) return Boolean;
   
   
   private
   
   type Measured_Buffer_Type(Size : Max_Buffer_Size_Type; EmptyChar : Character) is tagged
   record
      Buffer : String(Positive'First .. Size) := (others=>EmptyChar);
      Length : Max_Buffer_Size_Type := EMPTY_BUFFER_LENGTH;
   end record;

end measured_buffer_type;
