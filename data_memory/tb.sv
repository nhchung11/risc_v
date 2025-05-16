`timescale 1ns/1ps

module tb;

    // Testbench signals
    logic i_clk;
    logic i_rstn;
    logic i_mem_write;
    logic [10:0] i_addr; // 11-bit address
    logic [31:0] i_data; // 32-bit data
    logic [31:0] o_data; // 32-bit output data

    // Instantiate the data_memory module
    data_memory uut (
        .i_clk      (i_clk          ),
        .i_rstn     (i_rstn         ),
        .i_mem_write(i_mem_write    ),
        .i_addr     (i_addr         ),
        .i_data     (i_data         ),
        .o_data     (o_data         )
    );

    // Clock generation
    initial begin
        i_clk = 0;
        forever #5 i_clk = ~i_clk; // 10ns clock period
    end

    // Test procedure
    initial begin
        // Initialize signals
        i_rstn = 0;
        i_mem_write = 0;
        i_addr = 0;
        i_data = 0;

        // Apply reset
        #10;
        i_rstn = 0; // Assert reset
        #10;
        i_rstn = 1; // Deassert reset
        
        // Test 1: Write to address 0 and read back
        #10;
        i_mem_write = 1; // Enable write
        i_addr = 11'd0; // Address 0
        i_data = 32'hA5A5A5A5; // Write data
        #10;
        i_mem_write = 0; // Disable write
        #10;
        if (o_data !== 32'hA5A5A5A5) $display("Test 1 Failed: Expected 0xA5A5A5A5, Got 0x%h", o_data);
        else $display("Test 1 Passed");

        // Test 2: Write to address 1 and read back
        #10;
        i_mem_write = 1; // Enable write
        i_addr = 11'd1; // Address 1
        i_data = 32'h5A5A5A5A; // Write data
        #10;
        i_mem_write = 0; // Disable write
        #10;
        if (o_data !== 32'h5A5A5A5A) $display("Test 2 Failed: Expected 0x5A5A5A5A, Got 0x%h", o_data);
        else $display("Test 2 Passed");

        // Test 3: Write to address 1027 and read back
        #10;
        i_mem_write = 1; // Enable write
        i_addr = 11'd1027; // Address 1027
        i_data = 32'hDEADBEEF; // Write data
        #10;
        i_mem_write = 0; // Disable write
        i_addr = 11'd1027; // Read back from address 1027
        #10;
        if (o_data !== 32'hDEADBEEF) $display("Test 3 Failed: Expected 0xDEADBEEF, Got 0x%h", o_data);
        else $display("Test 3 Passed");

        // End simulation
        #10;
        $stop;
    end

endmodule