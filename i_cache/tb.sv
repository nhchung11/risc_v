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
    logic         tb_hit;
    logic         tb_ready;


    logic [3:0] tag0;
    logic [3:0] tag1;
    logic valid0;
    logic valid1;

    assign tag0 = dut.cache[tb_pc[7:3]][0].tag;
    assign valid0 = dut.cache[tb_pc[7:3]][0].valid;
    assign tag1 = dut.cache[tb_pc[7:3]][1].tag;
    assign valid1 = dut.cache[tb_pc[7:3]][1].valid;

    // Instantiate the DUT
    i_cache dut (
        .i_clk(tb_clk),
        .i_rst_n(tb_rst_n),
        .i_pc(tb_pc),
        .i_pc_valid(tb_pc_valid),
        .o_instruction(tb_instruction),
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
            $display("[TIME] %t", $time);
            $display("Fetching PC: %h, offset: %b, set: %b, tag: %b",tb_pc, tb_pc[2:0], tb_pc[7:3], tb_pc[11:8]);
            $display("\tCache tag0: %h", dut.cache[tb_pc[7:3]][0].tag);
            $display("\tCache tag1: %h", dut.cache[tb_pc[7:3]][1].tag);
            @(posedge tb_clk);
            #1;
            tb_pc_valid = ~valid_val; 
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
        fetch_pc(32'h00000008, 1); 
        fetch_pc(32'h0000000C, 1); 
        fetch_pc(32'h00000010, 1); 
        fetch_pc(32'h00000014, 1); 
        fetch_pc(32'h00000018, 1); 
        fetch_pc(32'h0000001C, 1); 
        fetch_pc(32'h00000020, 1);
        #200;
        $finish;
    end
endmodule