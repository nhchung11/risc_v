// `include "command_pkg.sv"
import command_pkg::*;
module control
(
    // clk & rst
    input logic i_core_clk,
    input logic i_rst_n,
    input logic i_soft_reset_n,

    // address input
    input logic i_addr_valid,

    // command input
    input logic i_cmd_start,
    input logic [7:0] i_cmd_cycle,
    input logic [7:0] i_cmd1,
    input logic [7:0] i_cmd2,

    // read page input
    input logic i_page_loaded,
    input logic i_data_valid,
    input logic i_data_output_done,

    // block erase input
    input logic i_block_erase_done,

    // read status input
    input logic i_status_output_done,

    // page program input
    input logic i_data_input_done,
    input logic i_page_program_done
);

// Busy signal
logic read_page_done;
logic read_idle;
logic rp_read_idle;
logic crc_read_idle;
assign read_idle = rp_read_idle || crc_read_idle;

// Check command
logic [3:0] cmd_code;
logic read_page_valid;
logic change_read_column_valid;
logic block_erase_valid;
logic read_status_valid;
logic page_program_valid;
logic change_write_column_valid;
assign read_page_done = i_data_output_done;

always_comb begin
    unique case (1'b1)
        read_page_valid:         cmd_code = 4'b0001;
        change_read_column_valid:cmd_code = 4'b0011;
        block_erase_valid:       cmd_code = 4'b0010;
        read_status_valid:       cmd_code = 4'b0110;
        page_program_valid:      cmd_code = 4'b0111;
        default:                 cmd_code = 4'b0000;
    endcase
end

always_ff @(posedge i_core_clk or negedge i_rst_n or negedge i_soft_reset_n) begin
    if(!i_rst_n || !i_soft_reset_n) begin
        read_page_valid             <= 0;
        change_read_column_valid    <= 0;
        block_erase_valid           <= 0;
        read_status_valid           <= 0;
        page_program_valid          <= 0;
        change_write_column_valid   <= 0;
    end
    else begin
        if (i_cmd_start) begin
            read_page_valid             <= ((i_cmd_cycle == 8'd2) && (i_cmd1 == READ_PAGE_1ST_CMD) && (i_cmd2 == READ_PAGE_2ND_CMD)) ? 1'b1 : 1'b0;
            change_read_column_valid    <= ((i_cmd_cycle == 8'd2) && (i_cmd1 == CHANGE_READ_COLUMN_1ST_CMD) && (i_cmd2 == CHANGE_READ_COLUMN_2ND_CMD)) ? 1'b1 : 1'b0;
            block_erase_valid           <= ((i_cmd_cycle == 8'd2) && (i_cmd1 == BLOCK_ERASE_1ST_CMD) && (i_cmd2 == BLOCK_ERASE_2ND_CMD)) ? 1'b1 : 1'b0;
            read_status_valid           <= ((i_cmd_cycle == 8'd1) && (i_cmd1 == READ_STATUS_CMD)) ? 1'b1 : 1'b0; 
            page_program_valid          <= ((i_cmd_cycle == 8'd2) && (i_cmd1 == PAGE_PROGRAM_1ST_CMD) && (i_cmd2 == PAGE_PROGRAM_2ND_CMD)) ? 1'b1 : 1'b0;  
            change_write_column_valid   <= ((i_cmd_cycle == 8'd1) && (i_cmd1 == CHANGE_WRITE_COLUMN_CMD)) ? 1'b1 : 1'b0; 
        end
        else begin
            read_page_valid             <= 0;
            change_read_column_valid    <= 0;
            block_erase_valid           <= 0;
            read_status_valid           <= 0;
            page_program_valid          <= 0;
            change_write_column_valid   <= 0;
        end
    end
end


// MAIN FSM
fsm_t current_state, next_state;
always_ff @(posedge i_core_clk or negedge i_rst_n or negedge i_soft_reset_n) begin
    if(!i_rst_n || !i_soft_reset_n) begin
        current_state <= IDLE;
    end
    else begin
        current_state <= next_state;
    end
end

always_comb begin
    case (current_state)
        IDLE: begin
            case (cmd_code)
                4'b0001: next_state = READ_PAGE;
                4'b0011: next_state = CHANGE_READ_COLUMN;
                4'b0010: next_state = BLOCK_ERASE;
                4'b0110: next_state = READ_STATUS;
                4'b0111: next_state = PAGE_PROGRAM;
                default: next_state = IDLE;
            endcase
        end
        READ_PAGE: begin
            if (read_page_done) next_state = IDLE;
            else if (change_read_column_valid) next_state = CHANGE_READ_COLUMN;
            else next_state = READ_PAGE;
        end

        CHANGE_READ_COLUMN: begin
            if (read_page_done) next_state = IDLE;
            else next_state = CHANGE_READ_COLUMN;
        end

        BLOCK_ERASE: begin
            if (i_block_erase_done) next_state = IDLE;
            else next_state = BLOCK_ERASE;
        end

        READ_STATUS: begin
            if (i_status_output_done) next_state = IDLE;
            else next_state = READ_STATUS;
        end

        PAGE_PROGRAM: begin
            if (i_page_program_done) next_state = IDLE;
            else next_state = PAGE_PROGRAM;
        end
        default: next_state = IDLE;
    endcase
end

logic read_page;
logic change_read_column;
logic block_erase;
logic read_status;
logic page_program;
logic change_write_column;
logic busy;

assign busy = ((read_page || change_read_column || block_erase || read_status || page_program || change_read_column) && (!read_idle)) ? 1'b1 : 1'b0;
always_comb begin
    case(current_state)
        IDLE: begin
            read_page           = 0;
            change_read_column  = 0;
            block_erase         = 0;
            read_status         = 0;
            page_program        = 0;
        end
        READ_PAGE: begin
            read_page           = 1;
            change_read_column  = 0;
            block_erase         = 0;
            read_status         = 0;
            page_program        = 0;
        end
        CHANGE_READ_COLUMN: begin
            read_page           = 0;
            change_read_column  = 1;
            block_erase         = 0;
            read_status         = 0;
            page_program        = 0;
        end

        BLOCK_ERASE: begin
            read_page           = 0;
            change_read_column  = 0;
            block_erase         = 1;
            read_status         = 0;
            page_program        = 0;
        end

        READ_STATUS: begin
            read_page           = 0;
            change_read_column  = 0;
            block_erase         = 0;
            read_status         = 1;
            page_program        = 0;
        end

        PAGE_PROGRAM: begin
            read_page           = 0;
            change_read_column  = 0;
            block_erase         = 0;
            read_status         = 0;
            page_program        = 1;
        end

        default: begin
            read_page           = 0;
            change_read_column  = 0;
            block_erase         = 0;
            read_status         = 0;
            page_program        = 0;
        end
    endcase
end

// READ PAGE FSM
fsm_read_page_t current_read_page_state, next_read_page_state;
assign rp_read_idle = (current_read_page_state == RP_DATA_OUTPUT) ? 1'b1 : 1'b0;

always_ff @(posedge i_core_clk or negedge i_rst_n or negedge i_soft_reset_n) begin
    if(!i_rst_n || !i_soft_reset_n) begin
        current_read_page_state <= RP_IDLE;
    end
    else begin
        current_read_page_state <= next_read_page_state;
    end
end

always_comb begin
    case (current_read_page_state)
        RP_IDLE: begin
            if (read_page_valid) next_read_page_state = RP_CMD1;
            else next_read_page_state = RP_IDLE;
        end

        RP_CMD1: begin
            next_read_page_state = RP_ADDR;
        end

        RP_ADDR: begin 
            if (i_addr_valid) next_read_page_state = RP_CMD2;
            else next_read_page_state = RP_ADDR;
        end

        RP_CMD2: begin
            next_read_page_state = RP_PAGE_LOADING;
        end

        RP_PAGE_LOADING: begin
            if (i_page_loaded) next_read_page_state = RP_CHECK_DATA;
            else next_read_page_state = RP_PAGE_LOADING;
        end

        RP_CHECK_DATA: begin
            if (i_data_valid) next_read_page_state = RP_DATA_OUTPUT;
            else next_read_page_state = RP_CHECK_DATA;
        end

        RP_DATA_OUTPUT: begin
            if (i_data_output_done || change_read_column) next_read_page_state = RP_IDLE;
            else next_read_page_state = RP_DATA_OUTPUT;
        end

        default: begin
            next_read_page_state = RP_IDLE;
        end
    endcase
end

// Change Read Column FSM
fsm_change_read_column_t current_change_read_column_state, next_change_read_column_state;
assign crc_read_idle = (current_change_read_column_state == CRC_DATA_OUTPUT) ? 1'b1 : 1'b0;

always_ff @(posedge i_core_clk or negedge i_rst_n or negedge i_soft_reset_n) begin
    if(!i_rst_n || !i_soft_reset_n) begin
        current_change_read_column_state <= CRC_IDLE;
    end
    else begin
        current_change_read_column_state <= next_change_read_column_state;
    end
end

always_comb begin
    case (current_change_read_column_state)
        CRC_IDLE: begin
            if (change_read_column) next_change_read_column_state = CRC_CMD1;
            else next_change_read_column_state = CRC_IDLE;
        end

        CRC_CMD1: begin
            next_change_read_column_state = CRC_ADDR;
        end

        CRC_ADDR: begin 
            if (i_addr_valid) next_change_read_column_state = CRC_CMD2;
            else next_change_read_column_state = CRC_ADDR;
        end

        CRC_CMD2: begin
            next_change_read_column_state = CRC_DATA_OUTPUT;
        end

        CRC_DATA_OUTPUT: begin
            if (i_data_output_done) next_change_read_column_state = CRC_IDLE;
            else next_change_read_column_state = CRC_DATA_OUTPUT;
        end

        default: begin
            next_change_read_column_state = CRC_IDLE;
        end
    endcase
end

// Block erase FSM
fsm_block_erase_t current_block_erase_state, next_block_erase_state;
always_ff @(posedge i_core_clk or negedge i_rst_n or negedge i_soft_reset_n) begin
    if(!i_rst_n || !i_soft_reset_n) begin
        current_block_erase_state <= BE_IDLE;
    end
    else begin
        current_block_erase_state <= next_block_erase_state;
    end
end

always_comb begin
    case (current_block_erase_state)
        BE_IDLE: begin
            if (block_erase_valid) next_block_erase_state = BE_CMD1;
            else next_block_erase_state = BE_IDLE;
        end

        BE_CMD1: begin
            next_block_erase_state = BE_ADDR;
        end

        BE_ADDR: begin 
            if (i_addr_valid) next_block_erase_state = BE_CMD2;
            else next_block_erase_state = BE_ADDR;
        end

        BE_CMD2: begin
            next_block_erase_state = BE_CHECK;
        end

        BE_CHECK: begin
            next_block_erase_state = BE_IDLE;
        end

        default: begin
            next_block_erase_state = BE_IDLE;
        end
    endcase
end

// Read Status FSM
fsm_read_status_t current_read_status_state, next_read_status_state;
always_ff @(posedge i_core_clk or negedge i_rst_n or negedge i_soft_reset_n) begin
    if(!i_rst_n || !i_soft_reset_n) begin
        current_read_status_state <= RS_IDLE;
    end
    else begin
        current_read_status_state <= next_read_status_state;
    end
end

always_comb begin
    case (current_read_status_state)
        RS_IDLE: begin
            if (read_status_valid) next_read_status_state = RS_CMD1;
            else next_read_status_state = RS_IDLE;
        end

        RS_CMD1: begin
            next_read_status_state = RS_DATA_OUTPUT;
        end

        RS_DATA_OUTPUT: begin
            if (i_status_output_done) next_read_status_state = RS_IDLE;
            else next_read_status_state = RS_DATA_OUTPUT;
        end

        default: begin
            next_read_status_state = RS_IDLE;
        end
    endcase
end

// Page program FSM
fsm_page_program_t current_page_program_state, next_page_program_state;
always_ff @(posedge i_core_clk or negedge i_rst_n or negedge i_soft_reset_n) begin
    if(!i_rst_n || !i_soft_reset_n) begin
        current_page_program_state <= PP_IDLE;
    end
    else begin
        current_page_program_state <= next_page_program_state;
    end
end

always_comb begin
    case (current_page_program_state)
        PP_IDLE: begin
            if (page_program_valid) next_page_program_state = PP_CMD1;
            else next_page_program_state = PP_IDLE;
        end

        PP_CMD1: begin
            next_page_program_state = PP_ADDR;
        end

        PP_ADDR: begin 
            if (i_addr_valid) next_page_program_state = PP_DATA_INPUT;
            else next_page_program_state = PP_ADDR;
        end

        PP_DATA_INPUT: begin
            if (change_write_column_valid) next_page_program_state = PP_CWC_CMD;
            else if (i_data_input_done) next_page_program_state = PP_CMD2;
            else next_page_program_state = PP_DATA_INPUT;
        end

        PP_CWC_CMD: begin
            next_page_program_state = PP_CWC_ADDR;
        end

        PP_CWC_ADDR: begin 
            if (i_addr_valid) next_page_program_state = PP_DATA_INPUT;
            else next_page_program_state = PP_CWC_ADDR;
        end

        PP_CMD2: begin
            next_page_program_state = PP_PROGRAMMING;
        end

        PP_PROGRAMMING: begin
            if (i_page_program_done) next_page_program_state = PP_IDLE;
            else next_page_program_state = PP_PROGRAMMING;
        end

        default: begin
            next_page_program_state = PP_IDLE;
        end
    endcase
end

always_comb begin
    case (current_page_program_state) 
        PP_CWC_CMD: begin
            change_write_column = 1;
        end

        PP_CWC_ADDR: begin
            change_write_column = 1;
        end

        default: begin
            change_write_column = 0;
        end
    endcase
end
endmodule   
