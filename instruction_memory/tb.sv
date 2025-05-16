module tb;
    // Inputs
    logic i_clk;
    logic i_rst_n;
    logic [31:0] i_pc;
    
    // Outputs
    logic [31:0] o_instr;
    
    // Instantiate the module under test
    instruction_memory dut (
        .i_clk      (i_clk),
        .i_rst_n    (i_rst_n),
        .i_pc       (i_pc),
        .o_instr    (o_instr)
    );
    
    // Clock generation
    always #5 i_clk = ~i_clk;
    
    // Reset generation
    initial begin
        i_clk = 0;
        i_rst_n = 0;
        #10;
        i_rst_n = 1;
    end
    
    // Test stimulus
    initial begin
        // Test case 1
        i_pc = 0;
        #20;
        
        // Test case 2
        i_pc = 4;
        #20;
        
        // Test case 3
        i_pc = 8;
        #20;
        
        // Add more test cases as needed
        
        $finish;
    end
endmodule