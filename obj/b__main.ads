pragma Warnings (Off);
pragma Ada_95;
with System;
package ada_main is

   gnat_argc : Integer;
   gnat_argv : System.Address;
   gnat_envp : System.Address;

   pragma Import (C, gnat_argc);
   pragma Import (C, gnat_argv);
   pragma Import (C, gnat_envp);

   gnat_exit_status : Integer;
   pragma Import (C, gnat_exit_status);

   GNAT_Version : constant String :=
                    "GNAT Version: GPL 2017 (20170515-63)" & ASCII.NUL;
   pragma Export (C, GNAT_Version, "__gnat_version");

   Ada_Main_Program_Name : constant String := "_ada_main" & ASCII.NUL;
   pragma Export (C, Ada_Main_Program_Name, "__gnat_ada_main_program_name");

   procedure adainit;
   pragma Export (C, adainit, "adainit");

   procedure adafinal;
   pragma Export (C, adafinal, "adafinal");

   function main
     (argc : Integer;
      argv : System.Address;
      envp : System.Address)
      return Integer;
   pragma Export (C, main, "main");

   type Version_32 is mod 2 ** 32;
   u00001 : constant Version_32 := 16#d3e3d430#;
   pragma Export (C, u00001, "mainB");
   u00002 : constant Version_32 := 16#b6df930e#;
   pragma Export (C, u00002, "system__standard_libraryB");
   u00003 : constant Version_32 := 16#0a55feef#;
   pragma Export (C, u00003, "system__standard_libraryS");
   u00004 : constant Version_32 := 16#76789da1#;
   pragma Export (C, u00004, "adaS");
   u00005 : constant Version_32 := 16#5b4659fa#;
   pragma Export (C, u00005, "ada__charactersS");
   u00006 : constant Version_32 := 16#4b7bb96a#;
   pragma Export (C, u00006, "ada__characters__latin_1S");
   u00007 : constant Version_32 := 16#fd2ad2f1#;
   pragma Export (C, u00007, "gnatS");
   u00008 : constant Version_32 := 16#dc5a1ac9#;
   pragma Export (C, u00008, "gnat__socketsB");
   u00009 : constant Version_32 := 16#5113cc31#;
   pragma Export (C, u00009, "gnat__socketsS");
   u00010 : constant Version_32 := 16#85a06f66#;
   pragma Export (C, u00010, "ada__exceptionsB");
   u00011 : constant Version_32 := 16#1a0dcc03#;
   pragma Export (C, u00011, "ada__exceptionsS");
   u00012 : constant Version_32 := 16#e947e6a9#;
   pragma Export (C, u00012, "ada__exceptions__last_chance_handlerB");
   u00013 : constant Version_32 := 16#41e5552e#;
   pragma Export (C, u00013, "ada__exceptions__last_chance_handlerS");
   u00014 : constant Version_32 := 16#32a08138#;
   pragma Export (C, u00014, "systemS");
   u00015 : constant Version_32 := 16#4e7785b8#;
   pragma Export (C, u00015, "system__soft_linksB");
   u00016 : constant Version_32 := 16#ac24596d#;
   pragma Export (C, u00016, "system__soft_linksS");
   u00017 : constant Version_32 := 16#b01dad17#;
   pragma Export (C, u00017, "system__parametersB");
   u00018 : constant Version_32 := 16#4c8a8c47#;
   pragma Export (C, u00018, "system__parametersS");
   u00019 : constant Version_32 := 16#30ad09e5#;
   pragma Export (C, u00019, "system__secondary_stackB");
   u00020 : constant Version_32 := 16#88327e42#;
   pragma Export (C, u00020, "system__secondary_stackS");
   u00021 : constant Version_32 := 16#f103f468#;
   pragma Export (C, u00021, "system__storage_elementsB");
   u00022 : constant Version_32 := 16#1f63cb3c#;
   pragma Export (C, u00022, "system__storage_elementsS");
   u00023 : constant Version_32 := 16#41837d1e#;
   pragma Export (C, u00023, "system__stack_checkingB");
   u00024 : constant Version_32 := 16#bc1fead0#;
   pragma Export (C, u00024, "system__stack_checkingS");
   u00025 : constant Version_32 := 16#87a448ff#;
   pragma Export (C, u00025, "system__exception_tableB");
   u00026 : constant Version_32 := 16#6f0ee87a#;
   pragma Export (C, u00026, "system__exception_tableS");
   u00027 : constant Version_32 := 16#ce4af020#;
   pragma Export (C, u00027, "system__exceptionsB");
   u00028 : constant Version_32 := 16#5ac3ecce#;
   pragma Export (C, u00028, "system__exceptionsS");
   u00029 : constant Version_32 := 16#80916427#;
   pragma Export (C, u00029, "system__exceptions__machineB");
   u00030 : constant Version_32 := 16#047ef179#;
   pragma Export (C, u00030, "system__exceptions__machineS");
   u00031 : constant Version_32 := 16#aa0563fc#;
   pragma Export (C, u00031, "system__exceptions_debugB");
   u00032 : constant Version_32 := 16#4c2a78fc#;
   pragma Export (C, u00032, "system__exceptions_debugS");
   u00033 : constant Version_32 := 16#6c2f8802#;
   pragma Export (C, u00033, "system__img_intB");
   u00034 : constant Version_32 := 16#307b61fa#;
   pragma Export (C, u00034, "system__img_intS");
   u00035 : constant Version_32 := 16#39df8c17#;
   pragma Export (C, u00035, "system__tracebackB");
   u00036 : constant Version_32 := 16#6c825ffc#;
   pragma Export (C, u00036, "system__tracebackS");
   u00037 : constant Version_32 := 16#9ed49525#;
   pragma Export (C, u00037, "system__traceback_entriesB");
   u00038 : constant Version_32 := 16#32fb7748#;
   pragma Export (C, u00038, "system__traceback_entriesS");
   u00039 : constant Version_32 := 16#18d5fcc5#;
   pragma Export (C, u00039, "system__traceback__symbolicB");
   u00040 : constant Version_32 := 16#9df1ae6d#;
   pragma Export (C, u00040, "system__traceback__symbolicS");
   u00041 : constant Version_32 := 16#179d7d28#;
   pragma Export (C, u00041, "ada__containersS");
   u00042 : constant Version_32 := 16#701f9d88#;
   pragma Export (C, u00042, "ada__exceptions__tracebackB");
   u00043 : constant Version_32 := 16#20245e75#;
   pragma Export (C, u00043, "ada__exceptions__tracebackS");
   u00044 : constant Version_32 := 16#e865e681#;
   pragma Export (C, u00044, "system__bounded_stringsB");
   u00045 : constant Version_32 := 16#455da021#;
   pragma Export (C, u00045, "system__bounded_stringsS");
   u00046 : constant Version_32 := 16#42315736#;
   pragma Export (C, u00046, "system__crtlS");
   u00047 : constant Version_32 := 16#08e0d717#;
   pragma Export (C, u00047, "system__dwarf_linesB");
   u00048 : constant Version_32 := 16#b1bd2788#;
   pragma Export (C, u00048, "system__dwarf_linesS");
   u00049 : constant Version_32 := 16#8f637df8#;
   pragma Export (C, u00049, "ada__characters__handlingB");
   u00050 : constant Version_32 := 16#3b3f6154#;
   pragma Export (C, u00050, "ada__characters__handlingS");
   u00051 : constant Version_32 := 16#e6d4fa36#;
   pragma Export (C, u00051, "ada__stringsS");
   u00052 : constant Version_32 := 16#e2ea8656#;
   pragma Export (C, u00052, "ada__strings__mapsB");
   u00053 : constant Version_32 := 16#1e526bec#;
   pragma Export (C, u00053, "ada__strings__mapsS");
   u00054 : constant Version_32 := 16#9dc9b435#;
   pragma Export (C, u00054, "system__bit_opsB");
   u00055 : constant Version_32 := 16#0765e3a3#;
   pragma Export (C, u00055, "system__bit_opsS");
   u00056 : constant Version_32 := 16#0626fdbb#;
   pragma Export (C, u00056, "system__unsigned_typesS");
   u00057 : constant Version_32 := 16#92f05f13#;
   pragma Export (C, u00057, "ada__strings__maps__constantsS");
   u00058 : constant Version_32 := 16#5ab55268#;
   pragma Export (C, u00058, "interfacesS");
   u00059 : constant Version_32 := 16#9f00b3d3#;
   pragma Export (C, u00059, "system__address_imageB");
   u00060 : constant Version_32 := 16#934c1c02#;
   pragma Export (C, u00060, "system__address_imageS");
   u00061 : constant Version_32 := 16#ec78c2bf#;
   pragma Export (C, u00061, "system__img_unsB");
   u00062 : constant Version_32 := 16#99d2c14c#;
   pragma Export (C, u00062, "system__img_unsS");
   u00063 : constant Version_32 := 16#d7aac20c#;
   pragma Export (C, u00063, "system__ioB");
   u00064 : constant Version_32 := 16#ace27677#;
   pragma Export (C, u00064, "system__ioS");
   u00065 : constant Version_32 := 16#11faaec1#;
   pragma Export (C, u00065, "system__mmapB");
   u00066 : constant Version_32 := 16#08d13e5f#;
   pragma Export (C, u00066, "system__mmapS");
   u00067 : constant Version_32 := 16#92d882c5#;
   pragma Export (C, u00067, "ada__io_exceptionsS");
   u00068 : constant Version_32 := 16#9d8ecedc#;
   pragma Export (C, u00068, "system__mmap__os_interfaceB");
   u00069 : constant Version_32 := 16#8f4541b8#;
   pragma Export (C, u00069, "system__mmap__os_interfaceS");
   u00070 : constant Version_32 := 16#54632e7c#;
   pragma Export (C, u00070, "system__os_libB");
   u00071 : constant Version_32 := 16#ed466fde#;
   pragma Export (C, u00071, "system__os_libS");
   u00072 : constant Version_32 := 16#d1060688#;
   pragma Export (C, u00072, "system__case_utilB");
   u00073 : constant Version_32 := 16#16a9e8ef#;
   pragma Export (C, u00073, "system__case_utilS");
   u00074 : constant Version_32 := 16#2a8e89ad#;
   pragma Export (C, u00074, "system__stringsB");
   u00075 : constant Version_32 := 16#4c1f905e#;
   pragma Export (C, u00075, "system__stringsS");
   u00076 : constant Version_32 := 16#769e25e6#;
   pragma Export (C, u00076, "interfaces__cB");
   u00077 : constant Version_32 := 16#70be4e8c#;
   pragma Export (C, u00077, "interfaces__cS");
   u00078 : constant Version_32 := 16#d0bc914c#;
   pragma Export (C, u00078, "system__object_readerB");
   u00079 : constant Version_32 := 16#7f932442#;
   pragma Export (C, u00079, "system__object_readerS");
   u00080 : constant Version_32 := 16#1a74a354#;
   pragma Export (C, u00080, "system__val_lliB");
   u00081 : constant Version_32 := 16#a8846798#;
   pragma Export (C, u00081, "system__val_lliS");
   u00082 : constant Version_32 := 16#afdbf393#;
   pragma Export (C, u00082, "system__val_lluB");
   u00083 : constant Version_32 := 16#7cd4aac9#;
   pragma Export (C, u00083, "system__val_lluS");
   u00084 : constant Version_32 := 16#27b600b2#;
   pragma Export (C, u00084, "system__val_utilB");
   u00085 : constant Version_32 := 16#9e0037c6#;
   pragma Export (C, u00085, "system__val_utilS");
   u00086 : constant Version_32 := 16#5bbc3f2f#;
   pragma Export (C, u00086, "system__exception_tracesB");
   u00087 : constant Version_32 := 16#167fa1a2#;
   pragma Export (C, u00087, "system__exception_tracesS");
   u00088 : constant Version_32 := 16#d178f226#;
   pragma Export (C, u00088, "system__win32S");
   u00089 : constant Version_32 := 16#8c33a517#;
   pragma Export (C, u00089, "system__wch_conB");
   u00090 : constant Version_32 := 16#29dda3ea#;
   pragma Export (C, u00090, "system__wch_conS");
   u00091 : constant Version_32 := 16#9721e840#;
   pragma Export (C, u00091, "system__wch_stwB");
   u00092 : constant Version_32 := 16#04cc8feb#;
   pragma Export (C, u00092, "system__wch_stwS");
   u00093 : constant Version_32 := 16#a831679c#;
   pragma Export (C, u00093, "system__wch_cnvB");
   u00094 : constant Version_32 := 16#266a1919#;
   pragma Export (C, u00094, "system__wch_cnvS");
   u00095 : constant Version_32 := 16#ece6fdb6#;
   pragma Export (C, u00095, "system__wch_jisB");
   u00096 : constant Version_32 := 16#a61a0038#;
   pragma Export (C, u00096, "system__wch_jisS");
   u00097 : constant Version_32 := 16#86c56e5a#;
   pragma Export (C, u00097, "ada__finalizationS");
   u00098 : constant Version_32 := 16#10558b11#;
   pragma Export (C, u00098, "ada__streamsB");
   u00099 : constant Version_32 := 16#67e31212#;
   pragma Export (C, u00099, "ada__streamsS");
   u00100 : constant Version_32 := 16#d85792d6#;
   pragma Export (C, u00100, "ada__tagsB");
   u00101 : constant Version_32 := 16#8813468c#;
   pragma Export (C, u00101, "ada__tagsS");
   u00102 : constant Version_32 := 16#c3335bfd#;
   pragma Export (C, u00102, "system__htableB");
   u00103 : constant Version_32 := 16#b66232d2#;
   pragma Export (C, u00103, "system__htableS");
   u00104 : constant Version_32 := 16#089f5cd0#;
   pragma Export (C, u00104, "system__string_hashB");
   u00105 : constant Version_32 := 16#143c59ac#;
   pragma Export (C, u00105, "system__string_hashS");
   u00106 : constant Version_32 := 16#1d9142a4#;
   pragma Export (C, u00106, "system__val_unsB");
   u00107 : constant Version_32 := 16#168e1080#;
   pragma Export (C, u00107, "system__val_unsS");
   u00108 : constant Version_32 := 16#95817ed8#;
   pragma Export (C, u00108, "system__finalization_rootB");
   u00109 : constant Version_32 := 16#7d52f2a8#;
   pragma Export (C, u00109, "system__finalization_rootS");
   u00110 : constant Version_32 := 16#4c415c97#;
   pragma Export (C, u00110, "gnat__sockets__linker_optionsS");
   u00111 : constant Version_32 := 16#1ad2d889#;
   pragma Export (C, u00111, "gnat__sockets__thinB");
   u00112 : constant Version_32 := 16#20e719bf#;
   pragma Export (C, u00112, "gnat__sockets__thinS");
   u00113 : constant Version_32 := 16#22b0e2af#;
   pragma Export (C, u00113, "interfaces__c__stringsB");
   u00114 : constant Version_32 := 16#603c1c44#;
   pragma Export (C, u00114, "interfaces__c__stringsS");
   u00115 : constant Version_32 := 16#24e984d0#;
   pragma Export (C, u00115, "gnat__sockets__thin_commonB");
   u00116 : constant Version_32 := 16#0f77a15c#;
   pragma Export (C, u00116, "gnat__sockets__thin_commonS");
   u00117 : constant Version_32 := 16#5de653db#;
   pragma Export (C, u00117, "system__communicationB");
   u00118 : constant Version_32 := 16#2bc0d4ea#;
   pragma Export (C, u00118, "system__communicationS");
   u00119 : constant Version_32 := 16#5a895de2#;
   pragma Export (C, u00119, "system__pool_globalB");
   u00120 : constant Version_32 := 16#7141203e#;
   pragma Export (C, u00120, "system__pool_globalS");
   u00121 : constant Version_32 := 16#ee101ba4#;
   pragma Export (C, u00121, "system__memoryB");
   u00122 : constant Version_32 := 16#6bdde70c#;
   pragma Export (C, u00122, "system__memoryS");
   u00123 : constant Version_32 := 16#6d4d969a#;
   pragma Export (C, u00123, "system__storage_poolsB");
   u00124 : constant Version_32 := 16#114d1f95#;
   pragma Export (C, u00124, "system__storage_poolsS");
   u00125 : constant Version_32 := 16#ef79b3cf#;
   pragma Export (C, u00125, "system__pool_sizeB");
   u00126 : constant Version_32 := 16#338ec961#;
   pragma Export (C, u00126, "system__pool_sizeS");
   u00127 : constant Version_32 := 16#b6166bc6#;
   pragma Export (C, u00127, "system__task_lockB");
   u00128 : constant Version_32 := 16#532ab656#;
   pragma Export (C, u00128, "system__task_lockS");
   u00129 : constant Version_32 := 16#d763507a#;
   pragma Export (C, u00129, "system__val_intB");
   u00130 : constant Version_32 := 16#7a05ab07#;
   pragma Export (C, u00130, "system__val_intS");
   u00131 : constant Version_32 := 16#6abe5dbe#;
   pragma Export (C, u00131, "system__finalization_mastersB");
   u00132 : constant Version_32 := 16#695cb8f2#;
   pragma Export (C, u00132, "system__finalization_mastersS");
   u00133 : constant Version_32 := 16#7268f812#;
   pragma Export (C, u00133, "system__img_boolB");
   u00134 : constant Version_32 := 16#c779f0d3#;
   pragma Export (C, u00134, "system__img_boolS");
   u00135 : constant Version_32 := 16#a5fd152e#;
   pragma Export (C, u00135, "system__os_constantsS");
   u00136 : constant Version_32 := 16#31f1418a#;
   pragma Export (C, u00136, "network_nsB");
   u00137 : constant Version_32 := 16#29bc0eff#;
   pragma Export (C, u00137, "network_nsS");
   u00138 : constant Version_32 := 16#2b70b149#;
   pragma Export (C, u00138, "system__concat_3B");
   u00139 : constant Version_32 := 16#39d0dd9d#;
   pragma Export (C, u00139, "system__concat_3S");
   u00140 : constant Version_32 := 16#fd83e873#;
   pragma Export (C, u00140, "system__concat_2B");
   u00141 : constant Version_32 := 16#300056e8#;
   pragma Export (C, u00141, "system__concat_2S");
   u00142 : constant Version_32 := 16#0806edc3#;
   pragma Export (C, u00142, "system__strings__stream_opsB");
   u00143 : constant Version_32 := 16#55d4bd57#;
   pragma Export (C, u00143, "system__strings__stream_opsS");
   u00144 : constant Version_32 := 16#17411e58#;
   pragma Export (C, u00144, "ada__streams__stream_ioB");
   u00145 : constant Version_32 := 16#31fc8e02#;
   pragma Export (C, u00145, "ada__streams__stream_ioS");
   u00146 : constant Version_32 := 16#4c01b69c#;
   pragma Export (C, u00146, "interfaces__c_streamsB");
   u00147 : constant Version_32 := 16#b1330297#;
   pragma Export (C, u00147, "interfaces__c_streamsS");
   u00148 : constant Version_32 := 16#6f0d52aa#;
   pragma Export (C, u00148, "system__file_ioB");
   u00149 : constant Version_32 := 16#95d1605d#;
   pragma Export (C, u00149, "system__file_ioS");
   u00150 : constant Version_32 := 16#cf3f1b90#;
   pragma Export (C, u00150, "system__file_control_blockS");
   u00151 : constant Version_32 := 16#3c420900#;
   pragma Export (C, u00151, "system__stream_attributesB");
   u00152 : constant Version_32 := 16#8bc30a4e#;
   pragma Export (C, u00152, "system__stream_attributesS");
   u00153 : constant Version_32 := 16#1d1c6062#;
   pragma Export (C, u00153, "ada__text_ioB");
   u00154 : constant Version_32 := 16#95711eac#;
   pragma Export (C, u00154, "ada__text_ioS");
   u00155 : constant Version_32 := 16#c18a7534#;
   pragma Export (C, u00155, "network_typesS");
   u00156 : constant Version_32 := 16#c2fdde67#;
   pragma Export (C, u00156, "utilsB");
   u00157 : constant Version_32 := 16#32ea56d4#;
   pragma Export (C, u00157, "utilsS");
   u00158 : constant Version_32 := 16#174988eb#;
   pragma Export (C, u00158, "parsingB");
   u00159 : constant Version_32 := 16#b89057e1#;
   pragma Export (C, u00159, "parsingS");
   u00160 : constant Version_32 := 16#be55f851#;
   pragma Export (C, u00160, "sparkS");
   u00161 : constant Version_32 := 16#57ea7e2d#;
   pragma Export (C, u00161, "spark__text_ioB");
   u00162 : constant Version_32 := 16#cd7dd003#;
   pragma Export (C, u00162, "spark__text_ioS");

   --  BEGIN ELABORATION ORDER
   --  ada%s
   --  ada.characters%s
   --  ada.characters.latin_1%s
   --  gnat%s
   --  interfaces%s
   --  system%s
   --  system.case_util%s
   --  system.case_util%b
   --  system.img_bool%s
   --  system.img_bool%b
   --  system.img_int%s
   --  system.img_int%b
   --  system.io%s
   --  system.io%b
   --  system.parameters%s
   --  system.parameters%b
   --  system.crtl%s
   --  interfaces.c_streams%s
   --  interfaces.c_streams%b
   --  system.storage_elements%s
   --  system.storage_elements%b
   --  system.stack_checking%s
   --  system.stack_checking%b
   --  system.string_hash%s
   --  system.string_hash%b
   --  system.htable%s
   --  system.htable%b
   --  system.strings%s
   --  system.strings%b
   --  system.traceback_entries%s
   --  system.traceback_entries%b
   --  system.unsigned_types%s
   --  system.img_uns%s
   --  system.img_uns%b
   --  system.wch_con%s
   --  system.wch_con%b
   --  system.wch_jis%s
   --  system.wch_jis%b
   --  system.wch_cnv%s
   --  system.wch_cnv%b
   --  system.concat_2%s
   --  system.concat_2%b
   --  system.concat_3%s
   --  system.concat_3%b
   --  system.traceback%s
   --  system.traceback%b
   --  system.val_util%s
   --  system.standard_library%s
   --  system.exception_traces%s
   --  ada.exceptions%s
   --  system.wch_stw%s
   --  system.val_util%b
   --  system.val_llu%s
   --  system.val_lli%s
   --  system.os_lib%s
   --  system.bit_ops%s
   --  ada.characters.handling%s
   --  ada.exceptions.traceback%s
   --  system.soft_links%s
   --  system.exception_table%s
   --  system.exception_table%b
   --  ada.io_exceptions%s
   --  ada.strings%s
   --  ada.containers%s
   --  system.exceptions%s
   --  system.exceptions%b
   --  system.secondary_stack%s
   --  system.address_image%s
   --  system.bounded_strings%s
   --  system.soft_links%b
   --  ada.exceptions.last_chance_handler%s
   --  system.exceptions_debug%s
   --  system.exceptions_debug%b
   --  system.exception_traces%b
   --  system.memory%s
   --  system.memory%b
   --  system.wch_stw%b
   --  system.val_llu%b
   --  system.val_lli%b
   --  interfaces.c%s
   --  system.win32%s
   --  system.mmap%s
   --  system.mmap.os_interface%s
   --  system.mmap.os_interface%b
   --  system.mmap%b
   --  system.os_lib%b
   --  system.bit_ops%b
   --  ada.strings.maps%s
   --  ada.strings.maps.constants%s
   --  ada.characters.handling%b
   --  ada.exceptions.traceback%b
   --  system.exceptions.machine%s
   --  system.exceptions.machine%b
   --  system.secondary_stack%b
   --  system.address_image%b
   --  system.bounded_strings%b
   --  ada.exceptions.last_chance_handler%b
   --  system.standard_library%b
   --  system.object_reader%s
   --  system.dwarf_lines%s
   --  system.dwarf_lines%b
   --  interfaces.c%b
   --  ada.strings.maps%b
   --  system.traceback.symbolic%s
   --  system.traceback.symbolic%b
   --  ada.exceptions%b
   --  system.object_reader%b
   --  interfaces.c.strings%s
   --  interfaces.c.strings%b
   --  system.os_constants%s
   --  system.task_lock%s
   --  system.task_lock%b
   --  system.val_uns%s
   --  system.val_uns%b
   --  ada.tags%s
   --  ada.tags%b
   --  ada.streams%s
   --  ada.streams%b
   --  system.communication%s
   --  system.communication%b
   --  system.file_control_block%s
   --  system.finalization_root%s
   --  system.finalization_root%b
   --  ada.finalization%s
   --  system.file_io%s
   --  system.file_io%b
   --  ada.streams.stream_io%s
   --  ada.streams.stream_io%b
   --  system.storage_pools%s
   --  system.storage_pools%b
   --  system.finalization_masters%s
   --  system.finalization_masters%b
   --  system.stream_attributes%s
   --  system.stream_attributes%b
   --  system.val_int%s
   --  system.val_int%b
   --  ada.text_io%s
   --  ada.text_io%b
   --  system.pool_global%s
   --  system.pool_global%b
   --  system.pool_size%s
   --  system.pool_size%b
   --  gnat.sockets%s
   --  gnat.sockets.thin_common%s
   --  gnat.sockets.thin_common%b
   --  gnat.sockets.thin%s
   --  gnat.sockets.thin%b
   --  gnat.sockets.linker_options%s
   --  gnat.sockets%b
   --  system.strings.stream_ops%s
   --  system.strings.stream_ops%b
   --  network_types%s
   --  spark%s
   --  utils%s
   --  utils%b
   --  network_ns%s
   --  network_ns%b
   --  spark.text_io%s
   --  spark.text_io%b
   --  parsing%s
   --  parsing%b
   --  main%b
   --  END ELABORATION ORDER

end ada_main;
