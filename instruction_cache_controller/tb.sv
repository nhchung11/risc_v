module tb;

    // Parameters
    parameter CLK_PERIOD = 10;

    // Testbench signals
    logic         tb_clk;
    logic         tb_rst_n;
    logic [31:0]  tb_pc;
    logic         tb_pc_valid;
    logic [127:0] tb_mem_data_in;
    logic         tb_mem_data_valid;
    logic         tb_mem_read_en;
    logic [31:0]  tb_instruction;
    logic         tb_instruction_valid;
    logic         tb_hit;
    logic         tb_ready;

    // Instantiate the DUT
    instruction_cache_controller dut (
        .i_clk(tb_clk),
        .i_rst_n(tb_rst_n),
        .i_pc(tb_pc),
        .i_pc_valid(tb_pc_valid),
        .o_instruction(tb_instruction),
        .o_instruction_valid(tb_instruction_valid),
        .o_hit(tb_hit),
        .o_ready(tb_ready),
        .i_mem_data_in(tb_mem_data_in),
        .i_mem_data_valid(tb_mem_data_valid),
        .o_mem_read_en(tb_mem_read_en)
    );

    // Clock generation
    initial begin
        tb_clk = 0;
        forever #(CLK_PERIOD / 2) tb_clk = ~tb_clk;
    end

    task automatic fetch_pc(input logic [31:0] pc_val, input logic valid_val);
        begin
            @(posedge tb_clk);
            #1;
            tb_pc_valid = valid_val;
            tb_pc = pc_val;
        end
    endtask

    // Test sequence
    initial begin
        tb_rst_n = 0;
        tb_pc_valid = 0;
        tb_pc = 32'h00000000;
        tb_mem_data_in = 128'h00000000_00000000_00000000_00000000;
        tb_mem_data_valid = 0;
        #10 tb_rst_n = 1; 
        $readmemh("cache.hex", dut.cache);
        #50;
        // fetch_pc(valid, pc, hit)
        fetch_pc(32'h00000004, 1); 
        fetch_pc(32'h00000008, 1); 
        fetch_pc(32'h0000000C, 1); 
        fetch_pc(32'h00000010, 1); 
        fetch_pc(32'h00000014, 1); 
        fetch_pc(32'h00000018, 1); 
        fetch_pc(32'h0000001C, 1); 
        #200;
        $finish;
    end

    // Monitor outputs
    initial begin
        $monitor("Time: %0t | Instruction: %h | Hit: %b | Ready: %b | Read Enable: %b", 
                 $time, tb_instruction, tb_hit, tb_ready, tb_mem_read_en);

        $monitor("valid: %b", dut.cache[0][0].valid);
    end

endmodule