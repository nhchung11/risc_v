package parameter_page_pkg;
    // FIXED VALUE
    localparam logic [31:0] ONFI_SIGNATURE_VALUE = 32'h49464E4F; // ASCII "ONFI"

    // REVISION INFORMATION AND FEATURES BLOCK
    typedef struct packed {
        logic [15:3]    reserved0                               ;
        logic           v2_0                                    ;
        logic           v1_0                                    ;
        logic           reserved1                               ;
        logic [15:6]    reserved2                               ;
        logic           sp_source_sync                          ;
        logic           sp_odd_to_even_copyback                 ;
        logic           sp_interleaved_operations               ;
        logic           sp_nonsequential_page_programming       ;
        logic           sp_multiple_LUN_operations              ;
        logic           sp_16bit_data_bus_width                 ;
        logic [15:6]    reserved3                               ;
        logic           sp_read_unique_ID                       ;
        logic           sp_copyback                             ;
        logic           sp_read_status_enhanced                 ;
        logic           sp_get_set_features                     ;
        logic           sp_read_cache_commands                  ;
        logic           sp_page_cache_program_commands          ;
        logic [175:0]   reserved4                               ;
    } revision_info_features_t;

    // MANUFACTURER INFORMATION BLOCK
    typedef struct packed {
        logic [95:0]    device_manufacturer                     ;
        logic [159:0]   device_model                            ;
        logic [7:0]     jedec_manufacturer_id                   ;
        logic [15:0]    date_code                               ;   
        logic [103:0]   reserved                                ;
    } manufacturer_info_t;

    // MEMORY ORGANIZATION BLOCK
    typedef struct packed {
        logic [31:0]    num_data_bytes_per_page                 ;
        logic [15:0]    spare_bytes_per_page                    ;
        logic [31:0]    num_spare_bytes_per_partial_page        ;
        logic [31:0]    num_pages_per_block                     ;
        logic [31:0]    num_blocks_per_LUN                      ;
        logic [7:0]     num_LUNs                                ;
        logic [7:0]     num_address_cycles                      ;
        logic [7:0]     bits_per_cell                           ;       
        logic [15:0]    bad_blocks_maximum_per_LUN              ;
        logic [15:0]    block_endurance                         ;
        logic [7:0]     num_programs_per_page                   ;
        logic [7:0]     partial_programming_attributes          ;
        logic [7:0]     num_bits_ECC_correctability             ;
        logic [7:0]     interleaved_operation_attributes        ;
        logic [103:0]   reserved0                               ;
    } memory_organization_t;

    // ELECTRICAL PARAMETERS BLOCK
    typedef struct packed {
        logic [7:0]     io_pin_capacitance_maximum              ;
        logic [15:6]    reserved0                               ;
        logic           sp_async_timing_mode5                   ;
        logic           sp_async_timing_mode4                   ;
        logic           sp_async_timing_mode3                   ;
        logic           sp_async_timing_mode2                   ;
        logic           sp_async_timing_mode1                   ;
        logic           sp_async_timing_mode0                   ;
        logic [15:6]    reserved1                               ;
        logic           sp_async_program_cache_timing_mode5     ;
        logic           sp_async_program_cache_timing_mode4     ;
        logic           sp_async_program_cache_timing_mode3     ;
        logic           sp_async_program_cache_timing_mode2     ;
        logic           sp_async_program_cache_timing_mode1     ;
        logic           sp_async_program_cache_timing_mode0     ;
        logic [15:0]    tPROG_max                               ;
        logic [15:0]    tBERS_max                               ;
        logic [15:0]    tR_max                                  ;
        logic [15:0]    tCCS_max                                ;
        logic [15:4]    reserved2                               ;
        logic           sp_source_sync_timing_mode3             ;
        logic           sp_source_sync_timing_mode2             ;
        logic           sp_source_sync_timing_mode1             ;
        logic           sp_source_sync_timing_mode0             ;
        logic [55:0]    reserved3                               ;
        logic [7:0]     input_pin_capacitance_maximum           ;
        logic [7:3]     reserved4                               ;
        logic           sp_overdrive2_drive_strength            ;
        logic           sp_overdrive1_drive_strength            ;
        logic [95:0]    reserved5                               ;
    } electrical_params_t;

    // VENDOR BLOCK
    typedef struct packed {
        logic [15:0]    vendor_revision_number                  ;
        logic [703:0]   vendor_specific                         ;
        logic [15:0]    integrity_CRC                           ;
    } vendor_block_t;
endpackage : parameter_page_pkg