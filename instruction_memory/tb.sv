module tb;
    // Inputs
    logic clk;
    logic rst_n;
    logic [31:0] pc;
    
    // Outputs
    logic [31:0] instruction;
    
    // Instantiate the module under test
    instruction_memory dut (
        .clk(clk),
        .rst_n(rst_n),
        .pc(pc),
        .instruction(instruction)
    );
    
    // Clock generation
    always #5 clk = ~clk;
    
    // Reset generation
    initial begin
        clk = 0;
        rst_n = 0;
        #10;
        rst_n = 1;
    end
    
    // Test stimulus
    initial begin
        // Test case 1
        pc = 0;
        #20;
        
        // Test case 2
        pc = 4;
        #20;
        
        // Test case 3
        pc = 8;
        #20;
        
        // Add more test cases as needed
        
        $finish;
    end
endmodule