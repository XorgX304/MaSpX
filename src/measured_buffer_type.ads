pragma SPARK_Mode(On);

with SPARK.Text_IO;

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
   
   function Get_Char(Buf : Measured_Buffer_Type; Idx : Max_Buffer_Size_Type) return Character
   with Global => null,
        Pre'Class => Idx >= Positive'First and Idx <= Buf.Size;
   
   function Calc_Length(Buf : Measured_Buffer_Type) return Max_Buffer_Size_Type
   with Global => null,
        Pre'Class => Buf.Is_Filled_From_Left,
        Post => (if Buf.Is_Full then 
                    Calc_Length'Result = Buf.Size
                 elsif Buf.Is_Empty then
                    Calc_Length'Result = 0
                 else
                    Calc_Length'Result > 0 and Calc_Length'Result < Buf.Size);
   
   function Get_Length(Buf : Measured_Buffer_Type) return Max_Buffer_Size_Type
   with Global => null,
        Post => Get_Length'Result <= Buf.Size;
        
   procedure Update_Length(Buf : in out Measured_Buffer_Type)
   with Global => null,
        Pre'Class => Buf.Is_Filled_From_Left;
   
   function Is_Empty(Buf : Measured_Buffer_Type) return Boolean
   with Global => null,
        Post => Is_Empty'Result = (for all I in Positive'First .. Buf.Size => Buf.Get_Char(I) = Buf.EmptyChar);
   
   function Is_Full(Buf : Measured_Buffer_Type) return Boolean
   with Global => null,
        Post => Is_Full'Result = (for all I in Positive'First .. Buf.Size => Buf.Get_Char(I) /= Buf.EmptyChar);
   
   function Is_Left_Neighbor_EmptyChar_And_This_Isnt(Buf : Measured_Buffer_Type; Idx : Max_Buffer_Size_Type) return Boolean
   with Global => null,
        Pre'Class => Idx >= Positive'First and Idx <= Buf.Size;
        
--     function Is_Right_Neighbor_EmptyChar_And_This_Isnt(Buf : Measured_Buffer_Type; Idx : Max_Buffer_Size_Type) return Boolean
--     with Global => null,
--          Pre'Class => Idx >= Positive'First and Idx <= Buf.Size;
        
   --function Is_One_Left_Edge(Buf : Measured_Buffer_Type) return Boolean
   --with Global => null;
        --Post => Is_One_Left_Edge'Result = (for some I in Positive'First .. Buf.Size =>
        --                                    (for all J in Positive'First .. Buf.Size => Logical_Equivalence(Buf.Is_Left_Neighbor_EmptyChar_And_This_Isnt(J),  J = I)));
                        
   --function Is_One_Right_Edge(Buf : Measured_Buffer_Type) return Boolean
   --with Global => null;
        --Post => Is_One_Right_Edge'Result = (for some I in Positive'First .. Buf.Size =>
        --                                      (for all J in Positive'First .. Buf.Size => Logical_Equivalence(Buf.Is_Right_Neighbor_EmptyChar_And_This_Isnt(J), J = I)));
        
   function Is_Filled_From_Left(Buf : Measured_Buffer_Type) return Boolean
   with Global => null,
        Post => Is_Filled_From_Left'Result =  Buf.Is_Empty or Buf.Is_Full or
                                            (for all I in Positive'First .. Buf.Size => not Buf.Is_Left_Neighbor_EmptyChar_And_This_Isnt(I));
        
--     function Is_Contiguous(Buf : Measured_Buffer_Type) return Boolean
--     with Global => null,
--          Post => Is_Contiguous'Result = Buf.Is_Empty or Buf.Is_Full or Buf.Is_One_Left_Edge or Buf.Is_One_Right_Edge;
--                      
--     function Is_Aligned(Buf : Measured_Buffer_Type) return Boolean
--     with Global => null,
--          Pre'Class => Buf.Is_Contiguous,
--          Post => (if not Buf.Is_Empty then
--                      Is_Aligned'Result = (Buf.Get_Char(Positive'First) /= Buf.EmptyChar)
--                   else
--                      Is_Aligned'Result = True);            
   
   procedure Append(Buf : in out Measured_Buffer_Type; C : Character)
   with Global => null,
        Pre'Class => C /= Buf.EmptyChar and then
                     not Buf.Is_Full and then
                     Buf.Is_Filled_From_Left,
        Post => Buf'Old.Calc_Length + 1 = Buf.Calc_Length and
                Buf.Get_Char(Buf.Calc_Length) = C and
                not Buf.Is_Empty;
   
   
   private
   
   type Measured_Buffer_Type(Size : Max_Buffer_Size_Type; EmptyChar : Character) is tagged
   record
      Buffer : String(Positive'First .. Size) := (others=>EmptyChar);
      Length : Max_Buffer_Size_Type := EMPTY_BUFFER_LENGTH;
   end record;

end measured_buffer_type;
