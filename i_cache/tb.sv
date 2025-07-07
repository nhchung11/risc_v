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



    // Instantiate the DUT
    i_cache dut (
        .i_clk              (tb_clk             ),
        .i_rst_n            (tb_rst_n           ),
        .i_pc               (tb_pc              ),
        .i_pc_valid         (tb_pc_valid        ),
        .o_instruction      (tb_instruction     ),
        .o_hit              (tb_hit             ),
        .o_ready            (tb_ready           ),
        .i_mem_data_in      (tb_mem_data_in     ),
        .i_mem_data_valid   (tb_mem_data_valid  ),
        .o_mem_read_en      (tb_mem_read_en     )
    );

    // Clock generation
    initial begin
        tb_clk = 0;
        forever #(CLK_PERIOD / 2) tb_clk = ~tb_clk;
    end

    task automatic fetch_pc(input logic [31:0] pc_val, input logic valid_val);
        wait(tb_ready);
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

    task automatic fetch_mem(input logic [31:0] pc_val, input logic valid_val);
        begin
            @(posedge tb_clk);
            #1;
            tb_mem_data_valid = valid_val;
            tb_pc = pc_val;
            $display("[TIME] %t", $time);
            $display("Fetching Memory for PC: %h", tb_pc);
            @(posedge tb_clk);
            #1;
            tb_mem_data_valid = ~valid_val; 
        end
    endtask

    int i = 0;
    always_ff @(posedge tb_clk or tb_rst_n) begin
        if (!tb_rst_n) begin
            i <= 0;
            tb_mem_data_in <= 128'h00000000_00000000_00000000_00000000;
            tb_mem_data_valid <= 1'b0;
        end else if (tb_mem_read_en && i < 32) begin
            // Simulate reading memory data
            tb_mem_data_in <= {i + 4, i + 3, i + 2, i + 1};
            tb_mem_data_valid <= 1'b1;
        end else begin
            tb_mem_data_valid <= 1'b0;
        end
    end

    // Test sequence
    initial begin
        tb_rst_n = 0;
        tb_pc_valid = 0;
        tb_pc = 32'h00000000;
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
        fetch_pc(32'h00000020, 1);
        fetch_pc(32'h00000024, 1);
        fetch_pc(32'h00000028, 1);
        fetch_pc(32'h0000002C, 1);
        fetch_pc(32'h00000030, 1);
        fetch_pc(32'h00000034, 1);
        fetch_pc(32'h00000038, 1);
        fetch_pc(32'h0000003C, 1);
        fetch_pc(32'h00000040, 1);
        fetch_pc(32'h00000044, 1);
        fetch_pc(32'h00000048, 1);
        #200;
        $finish;
    end
endmodule