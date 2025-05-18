module tb;
    // Inputs
    reg i_clk;
    reg i_rstn;

    // Instantiate DUT
    top dut (
        .i_clk(i_clk),
        .i_rstn(i_rstn)
    );

    // Clock generation
    initial begin
        i_clk = 0;
        forever #5 i_clk = ~i_clk; // 10 time units clock period
    end

    // Reset generation
    initial begin
        i_rstn = 0; // Assert reset
        #20; // Wait for 15 time units
        i_rstn = 1; // Deassert reset
        #200; // Run for 200 time units
        $finish; // Finish simulation
    end
endmodule