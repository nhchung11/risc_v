package command_pkg;
    // COMMANDS 
    localparam int READ_PAGE_1ST_CMD            = 32'h00;
    localparam int READ_PAGE_2ND_CMD            = 32'h30;
    localparam int CHANGE_READ_COLUMN_1ST_CMD   = 32'h05;
    localparam int CHANGE_READ_COLUMN_2ND_CMD   = 32'h35;
    localparam int BLOCK_ERASE_1ST_CMD          = 32'h60;
    localparam int BLOCK_ERASE_2ND_CMD          = 32'hD0;
    localparam int READ_STATUS_CMD              = 32'h70;
    localparam int PAGE_PROGRAM_1ST_CMD         = 32'h80;
    localparam int PAGE_PROGRAM_2ND_CMD         = 32'h10;
    localparam int CHANGE_WRITE_COLUMN_CMD      = 32'h85;
    localparam int READ_ID_CMD                  = 32'h90;
    localparam int READ_PARAMETER_PAGE_CMD      = 32'hEC;
    localparam int RESET_CMD                    = 32'hFF;
    localparam int READ_CACHE_RANDOM_1ST_CMD    = 32'h00;
    localparam int READ_CACHE_RANDOM_2ND_CMD    = 32'h31;
    localparam int READ_CACHE_SEQUENTIAL_CMD    = 32'h31;
    localparam int READ_CACHE_END_CMD           = 32'h3F;

    // FSM
    typedef enum logic [3:0] {
        IDLE                    = 4'b0000,
        READ_PAGE               = 4'b0001,
        CHANGE_READ_COLUMN      = 4'b0011,
        BLOCK_ERASE             = 4'b0010,
        READ_STATUS             = 4'b0110,
        PAGE_PROGRAM            = 4'b0111,
        CHANGE_WRITE_COLUMN     = 4'b0101,
        READ_ID                 = 4'b0100,
        READ_PARAMETER_PAGE     = 4'b1100,
        RESET                   = 4'b1101,
        READ_CACHE_RANDOM       = 4'b1111,
        READ_CACHE_SEQUENTIAL   = 4'b1110,
        READ_CACHE_END          = 4'b1010,
        TIME_OUT                = 4'b1011
    } fsm_t;

    // READ PAGE FSM
    typedef enum logic [2:0]{
        RP_IDLE                 = 3'b000,
        RP_CMD1                 = 3'b001,
        RP_ADDR                 = 3'b011,
        RP_CMD2                 = 3'b010,
        RP_PAGE_LOADING         = 3'b110,
        RP_CHECK_DATA           = 3'b111,
        RP_DATA_OUTPUT          = 3'b100
    } fsm_read_page_t;

    // CHANGE READ COLUMN FSM
    typedef enum logic [2:0]{
        CRC_IDLE                = 3'b000,
        CRC_CMD1                = 3'b001,
        CRC_ADDR                = 3'b011,
        CRC_CMD2                = 3'b010,
        CRC_DATA_OUTPUT         = 3'b110
    } fsm_change_read_column_t;

    // BLOCK ERASE FSM
    typedef enum logic [2:0]{
        BE_IDLE                 = 3'b000,
        BE_CMD1                 = 3'b001,
        BE_ADDR                 = 3'b011,
        BE_CMD2                 = 3'b010,
        BE_CHECK                = 3'b110
    } fsm_block_erase_t;

    // READ STATUS FSM
    typedef enum logic [2:0]{
        RS_IDLE                 = 3'b000,
        RS_CMD1                 = 3'b001,
        RS_DATA_OUTPUT          = 3'b011
    } fsm_read_status_t;

    // PAGE PROGRAM FSM
    typedef enum logic [2:0]{
        PP_IDLE                 = 3'b000,
        PP_CMD1                 = 3'b001,
        PP_ADDR                 = 3'b011,
        PP_DATA_INPUT           = 3'b010,
        PP_CWC_CMD              = 3'b110,
        PP_CWC_ADDR             = 3'b111,
        PP_CMD2                 = 3'b101,
        PP_PROGRAMMING          = 3'b100
    } fsm_page_program_t;
endpackage
