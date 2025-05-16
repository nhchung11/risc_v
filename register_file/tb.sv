module tb;
    reg i_clk, i_rst_n, i_reg_write;
    reg [31:0] i_data;
    reg [4:0] i_addr_srcA, i_addr_srcB, i_addr_des;
    wire [31:0] o_dataA, o_dataB;

    register_file dut (
        .i_clk          (i_clk),
        .i_rst_n        (i_rst_n),
        .i_reg_write    (i_reg_write),
        .i_data         (i_data),
        .i_addr_srcA    (i_addr_srcA),
        .i_addr_srcB    (i_addr_srcB),
        .i_addr_des     (i_addr_des),
        .o_dataA        (o_dataA),
        .o_dataB        (o_dataB)
    );

    initial begin
        i_clk = 0;
        i_rst_n = 0;
        i_reg_write = 0;
        i_data = 0;
        i_addr_srcA = 0;
        i_addr_srcB = 0;
        i_addr_des = 0;

        #10 i_rst_n = 1;

        // Test case 1
        #20 i_reg_write = 1;
        i_data = 32'h12345678;
        i_addr_des = 0;
        #10;
        i_reg_write = 0;

        // Test case 2
        #20 i_reg_write = 1;
        i_data = 32'h87654321;
        i_addr_des = 1;
        #10;
        i_reg_write = 0;

        // Test case 3
        #20 i_reg_write = 1;
        i_data = 32'hABCDEF01;
        i_addr_des = 2;
        #10;
        i_reg_write = 0;

        // Test case 4
        #20 i_reg_write = 1;
        i_data = 32'hAACCEE01;
        i_addr_des = 3;
        #10;
        i_reg_write = 0;

        // Test case 5
        #20 i_reg_write = 1;
        i_data = 32'h11223344;
        i_addr_des = 4;
        #10;
        i_reg_write = 0;

        #100 $finish;
    end

    always #5 i_clk = ~i_clk;
    // Monitor for write data
    always @(posedge i_clk) begin
        if (i_reg_write) begin
            $display("Write Data at Address %0d: %h", i_addr_des, i_data);
        end
    end
endmodule