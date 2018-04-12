pragma SPARK_Mode(On);

package error is
   --ltj:error types
   type Fileio_Error_Type is (No_Error, Buffer_Full_Error, Not_Found_Error, Conflict_Error, Unexpected_Error);
   
   --ltj:error webpages
   c400_BAD_REQUEST_PAGE : constant String := "400 Bad Request";
   c400_BAD_REQUEST_URI_PAGE : constant String := "400 Bad Request (URI)";
   c403_FORBIDDEN_PAGE : constant String := "403 Forbidden";
   c404_NOT_FOUND_PAGE : constant String := "404 Not Found";
   c409_CONFLICT_PAGE : constant String := "409 Conflict";
   c500_SERVER_ERROR_PAGE : constant String := "500 Internal Server Error";
   c501_NOT_IMPLEMENTED_PAGE : constant String := "501 Not Implemented";

end error;
