pragma Warnings (Off);
pragma Ada_95;
pragma Source_File_Name (ada_main, Spec_File_Name => "b__main.ads");
pragma Source_File_Name (ada_main, Body_File_Name => "b__main.adb");
pragma Suppress (Overflow_Check);
with Ada.Exceptions;

package body ada_main is

   E071 : Short_Integer; pragma Import (Ada, E071, "system__os_lib_E");
   E016 : Short_Integer; pragma Import (Ada, E016, "system__soft_links_E");
   E026 : Short_Integer; pragma Import (Ada, E026, "system__exception_table_E");
   E067 : Short_Integer; pragma Import (Ada, E067, "ada__io_exceptions_E");
   E051 : Short_Integer; pragma Import (Ada, E051, "ada__strings_E");
   E041 : Short_Integer; pragma Import (Ada, E041, "ada__containers_E");
   E028 : Short_Integer; pragma Import (Ada, E028, "system__exceptions_E");
   E020 : Short_Integer; pragma Import (Ada, E020, "system__secondary_stack_E");
   E077 : Short_Integer; pragma Import (Ada, E077, "interfaces__c_E");
   E053 : Short_Integer; pragma Import (Ada, E053, "ada__strings__maps_E");
   E057 : Short_Integer; pragma Import (Ada, E057, "ada__strings__maps__constants_E");
   E079 : Short_Integer; pragma Import (Ada, E079, "system__object_reader_E");
   E048 : Short_Integer; pragma Import (Ada, E048, "system__dwarf_lines_E");
   E040 : Short_Integer; pragma Import (Ada, E040, "system__traceback__symbolic_E");
   E114 : Short_Integer; pragma Import (Ada, E114, "interfaces__c__strings_E");
   E101 : Short_Integer; pragma Import (Ada, E101, "ada__tags_E");
   E099 : Short_Integer; pragma Import (Ada, E099, "ada__streams_E");
   E150 : Short_Integer; pragma Import (Ada, E150, "system__file_control_block_E");
   E109 : Short_Integer; pragma Import (Ada, E109, "system__finalization_root_E");
   E097 : Short_Integer; pragma Import (Ada, E097, "ada__finalization_E");
   E149 : Short_Integer; pragma Import (Ada, E149, "system__file_io_E");
   E145 : Short_Integer; pragma Import (Ada, E145, "ada__streams__stream_io_E");
   E124 : Short_Integer; pragma Import (Ada, E124, "system__storage_pools_E");
   E132 : Short_Integer; pragma Import (Ada, E132, "system__finalization_masters_E");
   E154 : Short_Integer; pragma Import (Ada, E154, "ada__text_io_E");
   E120 : Short_Integer; pragma Import (Ada, E120, "system__pool_global_E");
   E126 : Short_Integer; pragma Import (Ada, E126, "system__pool_size_E");
   E009 : Short_Integer; pragma Import (Ada, E009, "gnat__sockets_E");
   E116 : Short_Integer; pragma Import (Ada, E116, "gnat__sockets__thin_common_E");
   E112 : Short_Integer; pragma Import (Ada, E112, "gnat__sockets__thin_E");
   E155 : Short_Integer; pragma Import (Ada, E155, "network_types_E");
   E157 : Short_Integer; pragma Import (Ada, E157, "utils_E");
   E137 : Short_Integer; pragma Import (Ada, E137, "network_ns_E");
   E162 : Short_Integer; pragma Import (Ada, E162, "spark__text_io_E");
   E159 : Short_Integer; pragma Import (Ada, E159, "parsing_E");

   Local_Priority_Specific_Dispatching : constant String := "";
   Local_Interrupt_States : constant String := "";

   Is_Elaborated : Boolean := False;

   procedure finalize_library is
   begin
      declare
         procedure F1;
         pragma Import (Ada, F1, "gnat__sockets__finalize_body");
      begin
         E009 := E009 - 1;
         F1;
      end;
      declare
         procedure F2;
         pragma Import (Ada, F2, "gnat__sockets__finalize_spec");
      begin
         F2;
      end;
      E126 := E126 - 1;
      declare
         procedure F3;
         pragma Import (Ada, F3, "system__pool_size__finalize_spec");
      begin
         F3;
      end;
      E120 := E120 - 1;
      declare
         procedure F4;
         pragma Import (Ada, F4, "system__pool_global__finalize_spec");
      begin
         F4;
      end;
      E154 := E154 - 1;
      declare
         procedure F5;
         pragma Import (Ada, F5, "ada__text_io__finalize_spec");
      begin
         F5;
      end;
      E132 := E132 - 1;
      declare
         procedure F6;
         pragma Import (Ada, F6, "system__finalization_masters__finalize_spec");
      begin
         F6;
      end;
      E145 := E145 - 1;
      declare
         procedure F7;
         pragma Import (Ada, F7, "ada__streams__stream_io__finalize_spec");
      begin
         F7;
      end;
      declare
         procedure F8;
         pragma Import (Ada, F8, "system__file_io__finalize_body");
      begin
         E149 := E149 - 1;
         F8;
      end;
      declare
         procedure Reraise_Library_Exception_If_Any;
            pragma Import (Ada, Reraise_Library_Exception_If_Any, "__gnat_reraise_library_exception_if_any");
      begin
         Reraise_Library_Exception_If_Any;
      end;
   end finalize_library;

   procedure adafinal is
      procedure s_stalib_adafinal;
      pragma Import (C, s_stalib_adafinal, "system__standard_library__adafinal");

      procedure Runtime_Finalize;
      pragma Import (C, Runtime_Finalize, "__gnat_runtime_finalize");

   begin
      if not Is_Elaborated then
         return;
      end if;
      Is_Elaborated := False;
      Runtime_Finalize;
      s_stalib_adafinal;
   end adafinal;

   type No_Param_Proc is access procedure;

   procedure adainit is
      Main_Priority : Integer;
      pragma Import (C, Main_Priority, "__gl_main_priority");
      Time_Slice_Value : Integer;
      pragma Import (C, Time_Slice_Value, "__gl_time_slice_val");
      WC_Encoding : Character;
      pragma Import (C, WC_Encoding, "__gl_wc_encoding");
      Locking_Policy : Character;
      pragma Import (C, Locking_Policy, "__gl_locking_policy");
      Queuing_Policy : Character;
      pragma Import (C, Queuing_Policy, "__gl_queuing_policy");
      Task_Dispatching_Policy : Character;
      pragma Import (C, Task_Dispatching_Policy, "__gl_task_dispatching_policy");
      Priority_Specific_Dispatching : System.Address;
      pragma Import (C, Priority_Specific_Dispatching, "__gl_priority_specific_dispatching");
      Num_Specific_Dispatching : Integer;
      pragma Import (C, Num_Specific_Dispatching, "__gl_num_specific_dispatching");
      Main_CPU : Integer;
      pragma Import (C, Main_CPU, "__gl_main_cpu");
      Interrupt_States : System.Address;
      pragma Import (C, Interrupt_States, "__gl_interrupt_states");
      Num_Interrupt_States : Integer;
      pragma Import (C, Num_Interrupt_States, "__gl_num_interrupt_states");
      Unreserve_All_Interrupts : Integer;
      pragma Import (C, Unreserve_All_Interrupts, "__gl_unreserve_all_interrupts");
      Detect_Blocking : Integer;
      pragma Import (C, Detect_Blocking, "__gl_detect_blocking");
      Default_Stack_Size : Integer;
      pragma Import (C, Default_Stack_Size, "__gl_default_stack_size");
      Leap_Seconds_Support : Integer;
      pragma Import (C, Leap_Seconds_Support, "__gl_leap_seconds_support");
      Bind_Env_Addr : System.Address;
      pragma Import (C, Bind_Env_Addr, "__gl_bind_env_addr");

      procedure Runtime_Initialize (Install_Handler : Integer);
      pragma Import (C, Runtime_Initialize, "__gnat_runtime_initialize");

      Finalize_Library_Objects : No_Param_Proc;
      pragma Import (C, Finalize_Library_Objects, "__gnat_finalize_library_objects");
   begin
      if Is_Elaborated then
         return;
      end if;
      Is_Elaborated := True;
      Main_Priority := -1;
      Time_Slice_Value := -1;
      WC_Encoding := 'b';
      Locking_Policy := ' ';
      Queuing_Policy := ' ';
      Task_Dispatching_Policy := ' ';
      Priority_Specific_Dispatching :=
        Local_Priority_Specific_Dispatching'Address;
      Num_Specific_Dispatching := 0;
      Main_CPU := -1;
      Interrupt_States := Local_Interrupt_States'Address;
      Num_Interrupt_States := 0;
      Unreserve_All_Interrupts := 0;
      Detect_Blocking := 0;
      Default_Stack_Size := -1;
      Leap_Seconds_Support := 0;

      Runtime_Initialize (1);

      Finalize_Library_Objects := finalize_library'access;

      System.Soft_Links'Elab_Spec;
      System.Exception_Table'Elab_Body;
      E026 := E026 + 1;
      Ada.Io_Exceptions'Elab_Spec;
      E067 := E067 + 1;
      Ada.Strings'Elab_Spec;
      E051 := E051 + 1;
      Ada.Containers'Elab_Spec;
      E041 := E041 + 1;
      System.Exceptions'Elab_Spec;
      E028 := E028 + 1;
      System.Soft_Links'Elab_Body;
      E016 := E016 + 1;
      Interfaces.C'Elab_Spec;
      System.Os_Lib'Elab_Body;
      E071 := E071 + 1;
      Ada.Strings.Maps'Elab_Spec;
      Ada.Strings.Maps.Constants'Elab_Spec;
      E057 := E057 + 1;
      System.Secondary_Stack'Elab_Body;
      E020 := E020 + 1;
      System.Object_Reader'Elab_Spec;
      System.Dwarf_Lines'Elab_Spec;
      E048 := E048 + 1;
      E077 := E077 + 1;
      E053 := E053 + 1;
      System.Traceback.Symbolic'Elab_Body;
      E040 := E040 + 1;
      E079 := E079 + 1;
      Interfaces.C.Strings'Elab_Spec;
      E114 := E114 + 1;
      Ada.Tags'Elab_Spec;
      Ada.Tags'Elab_Body;
      E101 := E101 + 1;
      Ada.Streams'Elab_Spec;
      E099 := E099 + 1;
      System.File_Control_Block'Elab_Spec;
      E150 := E150 + 1;
      System.Finalization_Root'Elab_Spec;
      E109 := E109 + 1;
      Ada.Finalization'Elab_Spec;
      E097 := E097 + 1;
      System.File_Io'Elab_Body;
      E149 := E149 + 1;
      Ada.Streams.Stream_Io'Elab_Spec;
      E145 := E145 + 1;
      System.Storage_Pools'Elab_Spec;
      E124 := E124 + 1;
      System.Finalization_Masters'Elab_Spec;
      System.Finalization_Masters'Elab_Body;
      E132 := E132 + 1;
      Ada.Text_Io'Elab_Spec;
      Ada.Text_Io'Elab_Body;
      E154 := E154 + 1;
      System.Pool_Global'Elab_Spec;
      E120 := E120 + 1;
      System.Pool_Size'Elab_Spec;
      E126 := E126 + 1;
      Gnat.Sockets'Elab_Spec;
      Gnat.Sockets.Thin_Common'Elab_Spec;
      E116 := E116 + 1;
      Gnat.Sockets.Thin'Elab_Body;
      E112 := E112 + 1;
      Gnat.Sockets'Elab_Body;
      E009 := E009 + 1;
      Network_Types'Elab_Spec;
      E155 := E155 + 1;
      E157 := E157 + 1;
      E137 := E137 + 1;
      SPARK.TEXT_IO'ELAB_SPEC;
      SPARK.TEXT_IO'ELAB_BODY;
      E162 := E162 + 1;
      E159 := E159 + 1;
   end adainit;

   procedure Ada_Main_Program;
   pragma Import (Ada, Ada_Main_Program, "_ada_main");

   function main
     (argc : Integer;
      argv : System.Address;
      envp : System.Address)
      return Integer
   is
      procedure Initialize (Addr : System.Address);
      pragma Import (C, Initialize, "__gnat_initialize");

      procedure Finalize;
      pragma Import (C, Finalize, "__gnat_finalize");
      SEH : aliased array (1 .. 2) of Integer;

      Ensure_Reference : aliased System.Address := Ada_Main_Program_Name'Address;
      pragma Volatile (Ensure_Reference);

   begin
      gnat_argc := argc;
      gnat_argv := argv;
      gnat_envp := envp;

      Initialize (SEH'Address);
      adainit;
      Ada_Main_Program;
      adafinal;
      Finalize;
      return (gnat_exit_status);
   end;

--  BEGIN Object file/option list
   --   D:\OneDrive\OneDrive\ChthonianCyberServices\ada\ironwebs\obj\network_types.o
   --   D:\OneDrive\OneDrive\ChthonianCyberServices\ada\ironwebs\obj\spark.o
   --   D:\OneDrive\OneDrive\ChthonianCyberServices\ada\ironwebs\obj\utils.o
   --   D:\OneDrive\OneDrive\ChthonianCyberServices\ada\ironwebs\obj\network_ns.o
   --   D:\OneDrive\OneDrive\ChthonianCyberServices\ada\ironwebs\obj\spark-text_io.o
   --   D:\OneDrive\OneDrive\ChthonianCyberServices\ada\ironwebs\obj\parsing.o
   --   D:\OneDrive\OneDrive\ChthonianCyberServices\ada\ironwebs\obj\main.o
   --   -LD:\OneDrive\OneDrive\ChthonianCyberServices\ada\ironwebs\obj\
   --   -LD:\OneDrive\OneDrive\ChthonianCyberServices\ada\ironwebs\obj\
   --   -LC:/gnat/2017/lib/gcc/i686-pc-mingw32/6.3.1/adalib/
   --   -static
   --   -lgnat
   --   -lws2_32
   --   -Wl,--stack=0x2000000
--  END Object file/option list   

end ada_main;
