import command_pkg::*;
module tb;
    // Parameters
    parameter CLK_PERIOD = 10;

    // Testbench signals
    logic i_core_clk;
    logic i_rst_n;
    logic i_soft_reset_n;
    logic i_addr_valid;
    logic i_cmd_start;
    logic [7:0] i_cmd_cycle;
    logic [7:0] i_cmd1;
    logic [7:0] i_cmd2;
    logic i_page_loaded;
    logic i_data_valid;
    logic i_data_output_done;
    logic i_block_erase_done;
    logic i_status_output_done;
    logic i_data_input_done;
    logic i_page_program_done;

    // Instantiate the control module
    control dut (
        .i_core_clk                 (   i_core_clk              ),
        .i_rst_n                    (   i_rst_n                 ),
        .i_soft_reset_n             (   i_soft_reset_n          ),
        .i_addr_valid               (   i_addr_valid            ),
        .i_cmd_start                (   i_cmd_start             ),
        .i_cmd_cycle                (   i_cmd_cycle             ),
        .i_cmd1                     (   i_cmd1                  ),
        .i_cmd2                     (   i_cmd2                  ),
        .i_page_loaded              (   i_page_loaded           ),
        .i_data_valid               (   i_data_valid            ),
        .i_data_output_done         (   i_data_output_done      ),
        .i_block_erase_done         (   i_block_erase_done      ),
        .i_status_output_done       (   i_status_output_done    ),
        .i_data_input_done          (   i_data_input_done       ),
        .i_page_program_done        (   i_page_program_done     )
    );

    // Clock generation
    initial begin
        i_core_clk = 0;
        forever #(CLK_PERIOD / 2) i_core_clk = ~i_core_clk;
    end

    task init_and_reset();
        // Initialize inputs
        i_rst_n             = 0;
        i_soft_reset_n      = 0;
        i_addr_valid        = 0;
        i_cmd_start         = 0;
        i_cmd_cycle         = 0;
        i_cmd1              = 0;
        i_cmd2              = 0;
        i_page_loaded       = 0;
        i_data_valid        = 0;
        i_data_output_done  = 0;
        i_block_erase_done  = 0;
        i_status_output_done= 0;
        i_data_input_done   = 0;
        i_page_program_done = 0;

        // Release reset
        #20;
        i_rst_n = 1;
        i_soft_reset_n = 1;
    endtask

    task address_valid(logic addr_v);
        @(posedge i_core_clk);
        @(posedge i_core_clk);
        @(posedge i_core_clk);
        @(posedge i_core_clk);
        @(posedge i_core_clk);
        i_addr_valid = addr_v;
        @(posedge i_core_clk);
        i_addr_valid = 0;
    endtask

    task data_valid (logic data_v);
        @(posedge i_core_clk);
        i_data_valid = data_v;
        @(posedge i_core_clk);
        i_data_valid = 0;
        @(posedge i_core_clk);
        i_data_output_done = 1;
        @(posedge i_core_clk);
        i_data_output_done = 0;
    endtask

    task page_load (logic page_l);
        @(posedge i_core_clk);
        i_page_loaded = page_l;
        @(posedge i_core_clk);
        i_page_loaded = 0;
    endtask

    task send_cmd(logic [7:0] cmd1, logic [7:0] cmd2, logic [7:0] cycle);
        @(posedge i_core_clk);
        i_cmd_cycle = cycle;
        i_cmd1 = cmd1;
        i_cmd2 = cmd2;
        @(posedge i_core_clk);
        i_cmd_start = 1;
        @(posedge i_core_clk);
        i_cmd_start = 0;
    endtask

    task read_page(logic addr_v, logic page_l);
        send_cmd(READ_PAGE_1ST_CMD, READ_PAGE_2ND_CMD, 8'd2);
        address_valid(1);
        page_load(1);
    endtask

    task change_read_column(logic addr_v);
        send_cmd(CHANGE_READ_COLUMN_1ST_CMD, CHANGE_READ_COLUMN_2ND_CMD, 8'd2);
        address_valid(1);
    endtask

    task block_erase(logic addr_v, logic block_e);
        send_cmd(BLOCK_ERASE_1ST_CMD, BLOCK_ERASE_2ND_CMD, 8'd2);
        address_valid(1);
        @(posedge i_core_clk);
        i_block_erase_done = block_e;
        @(posedge i_core_clk);
        i_block_erase_done = 0;
    endtask

    task page_program(logic addr_v, logic page_prg, logic cwc);
        send_cmd(PAGE_PROGRAM_1ST_CMD, PAGE_PROGRAM_2ND_CMD, 8'd2);
        address_valid(1);
        @(posedge i_core_clk);
        if (cwc) begin
            send_cmd(CHANGE_WRITE_COLUMN_CMD, 8'd0, 8'd1);
            address_valid(1);
        end
        @(posedge i_core_clk);
        i_data_input_done = 1;
        @(posedge i_core_clk);
        i_data_input_done = 0;
        @(posedge i_core_clk);
        @(posedge i_core_clk);
        @(posedge i_core_clk);
        i_page_program_done = page_prg;
        @(posedge i_core_clk);
        i_page_program_done = 0;
    endtask

    

    initial begin
        init_and_reset();    
        #50;
        read_page(1, 1);
        data_valid(1);
        read_page(1, 1);
        data_valid(1); 
        read_page(1, 1);
        data_valid(1);
        read_page(1, 1);
        change_read_column(1);
        data_valid(1);
        block_erase(1, 1);
        send_cmd(READ_STATUS_CMD, 8'd0, 8'd1);
        @(posedge i_core_clk);
        @(posedge i_core_clk);
        @(posedge i_core_clk);
        @(posedge i_core_clk);
        i_status_output_done = 1;
        @(posedge i_core_clk);
        i_status_output_done = 0;
        page_program(1, 1, 0);
        page_program(1, 1, 1);
        #200;
        $finish;
    end

endmodule