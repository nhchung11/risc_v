module command_decoder
(
    input logic     i_apb_clk,
    input logic     i_apb_rst_n,

    input logic [31:0]  i_CMD,
    input logic [31:0]  i_DATA_TX,
    input logic [31:0]  i_DATA_RX,
    input logic [31:0]  i_ADDR_COL,
    input logic [31:0]  i_ADDR_ROW,
    input logic [31:0]  i_STATUS,
    input logic [31:0]  i_CONFIG,
    input logic [31:0]  i_INT_EN
);

localparam read_1st                     = 32'h00;
localparam read_2nd                     = 32'h30;
localparam change_read_column_1st       = 32'h05;
localparam change_read_column_2nd       = 32'h35;
localparam block_erase_1st              = 32'h60;
localparam block_erase_2nd              = 32'hD0;
localparam page_program_1st             = 32'h80;
localparam page_program_2nd             = 32'h10;
localparam change_write_column_1st      = 32'h85;
localparam read_ID_1st                  = 32'h90;
localparam read_page_parameters_1st     = 32'hEC;
localparam reset_1st                    = 32'hFF;
localparam read_cache_random_1st        = 32'h00;
localparam read_cache_random_2nd        = 32'h31;
localparam read_cache_sequential_1st    = 32'h31;
localparam read_cache_end_1st           = 32'h3F;

logic read;
logic change_read_column;
logic block_erase;
logic page_program;
logic change_write_column;
logic read_ID;
logic read_page_parameters;
logic reset;
logic read_cache_random;
logic read_cache_sequential;
logic read_cache_end;
logic check_cmd;

always_ff @(posedge i_apb_clk or negedge i_apb_rst_n) begin
    if (!i_apb_rst_n) begin
        read                    <= 1'b0;
        change_read_column      <= 1'b0;
        block_erase             <= 1'b0;
        page_program            <= 1'b0;
        change_write_column     <= 1'b0;
        read_ID                 <= 1'b0;
        read_page_parameters    <= 1'b0;
        reset                   <= 1'b0;
        read_cache_random       <= 1'b0;
        read_cache_sequential   <= 1'b0;
        read_cache_end          <= 1'b0;
        check_cmd               <= 1'b0;
    end else begin
        case (i_CMD)
            read_1st: begin
                read                <= 1'b0;
                check_cmd           <= 1'b1;
            end
            read_2nd: begin
                if (check_cmd) begin
                    read            <= 1'b0;
                end else begin
                    read            <= 1'b1;
                end
                check_cmd           <= 1'b0;
            end
            change_read_column_1st: begin
                change_read_column  <= 1'b0;
                check_cmd           <= 1'b1;
            end
            change_read_column_2nd: begin
                if (check_cmd) begin
                    change_read_column  <= 1'b0;
                end else begin
                    change_read_column  <= 1'b1;
                end
                check_cmd           <= 1'b0;
            end
            block_erase_1st: begin
                block_erase         <= 1'b0;
                check_cmd           <= 1'b1;
            end
            block_erase_2nd: begin
                if (check_cmd) begin
                    block_erase     <= 1'b0;
                end else begin
                    block_erase     <= 1'b1;
                end
                check_cmd           <= 1'b0;
            end
            page_program_1st: begin
                page_program        <= 1'b0;
                check_cmd           <= 1'b1;
            end
            page_program_2nd: begin
                page_program        <= 1'b1;
                check_cmd           <= 1'b0;
            end
            change_write_column_1st: begin
                change_write_column <= 1'b1;
                check_cmd           <= 1'b1;
            end
            read_ID_1st: begin
                read_ID             <= 1'b1;
                check_cmd           <= 1'b0;
            end
            read_page_parameters_1st: begin
                read_page_parameters <= 1'b1;
                check_cmd            <= 1'b0;
            end
            reset_1st: begin
                reset               <= 1'b1;
                check_cmd           <= 1'b0; 
            end
            read_cache_random_1st: begin
                read_cache_random   <= 1'b0;
                check_cmd           <= 1'b1; 
            end
            read_cache_random_2nd: begin
                read_cache_random   <= 1'b0;
                check_cmd           <= 1'b0;
            end
            read_cache_sequential_1st: begin
                read_cache_sequential <= 1'b0; 
                check_cmd <= 1'b0; 
            end
        endcase
    end
end

endmodule