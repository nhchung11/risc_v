module tb;

    // Parameters
    parameter WIDTH     = 32;
    parameter ENTRY_NUM = WIDTH; 

    // Signals
    logic i_clk;
    logic i_rst_n;
    logic i_jump_ID;
    logic i_pc_src_EX;
    logic i_btb_update_en_ID;
    logic [WIDTH-1:0] i_pc_target_ID;
    logic [WIDTH-1:0] i_pc_plus4_F;
    logic o_flush_PC;
    logic [WIDTH-1:0] o_pc_F0;
    logic [31:0] reg_pc;
    logic [WIDTH-1:0] i_pc_F;

    assign i_pc_F = reg_pc; // Connect reg_pc to i_pc_F
    // Instantiate the DUT
    btb #(
        .WIDTH(WIDTH),
        .ENTRY_NUM(ENTRY_NUM)
    ) dut (
        .i_clk(i_clk),
        .i_rst_n(i_rst_n),
        .i_jump_ID(i_jump_ID),
        .i_pc_src_EX(i_pc_src_EX),
        .i_btb_update_en_ID(i_btb_update_en_ID),
        .i_pc_F(reg_pc),
        .i_pc_target_ID(i_pc_target_ID),
        .i_pc_plus4_F(i_pc_plus4_F),
        .o_flush_PC(o_flush_PC),
        .o_pc_F0(o_pc_F0)
    );
    always_ff @(posedge i_clk or negedge i_rst_n) begin
        if (~i_rst_n) begin
            reg_pc <= 32'h00000000; // Reset PC to zero
        end else begin
            reg_pc <= o_pc_F0; // Update PC with the output from the DUT
        end
    end

    // Clock generation
    initial begin
        i_clk = 0;
        forever #5 i_clk = ~i_clk; // 10 time units clock period
    end

    // Test sequence
    initial begin
        // Initialize inputs
        i_rst_n = 0;
        i_jump_ID = 0;
        i_pc_src_EX = 0;
        i_btb_update_en_ID = 0;
        i_pc_target_ID = 0;
        i_pc_plus4_F = 0;
    
        for (int i = 0; i < 32; i++) begin
            dut.btb_array[i].tag = 0; // Set all entries to zero
            dut.btb_array[i].target = 32'h00000000; // Set all entries to zero
            dut.btb_array[i].predicted = 2'b00; // Set all entries to zero
        end

        // Reset the DUT
        #15;
        i_rst_n = 1;

        // Wait for reset to complete
        @(posedge i_clk);
        #1;
        i_pc_plus4_F = 32'h00000004; 
        @(posedge i_clk);
        #1;
        i_pc_plus4_F = 32'h00000008; 
        @(posedge i_clk);
        #1;
        i_pc_plus4_F = 32'h0000000C;
        i_btb_update_en_ID = 1; 
        i_jump_ID = 1; 
        #0.5;
        i_pc_target_ID = 32'h00000028;
        $display("Update at index: %0d", dut.w_index);
        $display("Updating BTB with target: %h", i_pc_target_ID);

        @(posedge i_clk);
        #1;
        i_jump_ID = 1; 
        i_btb_update_en_ID = 0;
        
        #200;
        // Finish simulation
        $finish;
    end
endmodule