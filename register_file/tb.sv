module tb;
    reg clk, rst_n, wend;
    reg [31:0] write_data;
    reg [4:0] read_adr1, read_adr2, write_adr;
    wire [31:0] read_data1, read_data2;

    register_file dut (
        .clk(clk),
        .rst_n(rst_n),
        .wend(wend),
        .write_data(write_data),
        .read_adr1(read_adr1),
        .read_adr2(read_adr2),
        .write_adr(write_adr),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    initial begin
        clk = 0;
        rst_n = 0;
        wend = 0;
        write_data = 0;
        read_adr1 = 0;
        read_adr2 = 0;
        write_adr = 0;

        #10 rst_n = 1;

        // Test case 1
        #20 wend = 1;
        write_data = 32'h12345678;
        write_adr = 0;
        #10;
        wend = 0;

        // Test case 2
        #20 wend = 1;
        write_data = 32'h87654321;
        write_adr = 1;
        #10;
        wend = 0;

        // Test case 3
        #20 wend = 1;
        write_data = 32'hABCDEF01;
        write_adr = 2;
        #10;
        wend = 0;

        // Test case 4
        #20 wend = 1;
        write_data = 32'hAACCEE01;
        write_adr = 3;
        #10;
        wend = 0;

        // Test case 5
        #20 wend = 1;
        write_data = 32'h11223344;
        write_adr = 4;
        #10;
        wend = 0;

        #100 $finish;
    end

    always #5 clk = ~clk;
    // Monitor for write data
    always @(posedge clk) begin
        if (wend) begin
            $display("Write Data at Address %0d: %h", write_adr, write_data);
        end
    end
endmodule