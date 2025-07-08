module tb;

    // Testbench signals
    logic         tb_apb_clk;
    logic         tb_apb_rst_n;
    logic         tb_apb_psel;
    logic         tb_apb_penable;
    logic         tb_apb_pwrite;
    logic [31:0]  tb_apb_paddr;
    logic [31:0]  tb_apb_pwdata;
    logic [3:0]   tb_apb_pstrb;
    logic [2:0]   tb_apb_pprot;
    
    logic         tb_apb_pready;
    logic [31:0]  tb_apb_prdata;
    logic         tb_apb_pslverr;

    // Instantiate the DUT
    apb dut (
        .i_apb_clk(tb_apb_clk),
        .i_apb_rst_n(tb_apb_rst_n),
        .i_apb_psel(tb_apb_psel),
        .i_apb_penable(tb_apb_penable),
        .i_apb_pwrite(tb_apb_pwrite),
        .i_apb_paddr(tb_apb_paddr),
        .i_apb_pwdata(tb_apb_pwdata),
        .i_apb_pstrb(tb_apb_pstrb),
        .i_apb_pprot(tb_apb_pprot),
        .o_apb_pready(tb_apb_pready),
        .o_apb_prdata(tb_apb_prdata),
        .o_apb_pslverr(tb_apb_pslverr),
        .o_CMD(),
        .o_DATA_TX(),
        .o_DATA_RX(),
        .o_ADDR_COL(),
        .o_ADDR_ROW(),
        .o_STATUS(),
        .o_CONFIG(),
        .o_INT_EN()
    );

    // Clock
    initial begin
        tb_apb_clk = 0;
        forever #5 tb_apb_clk = ~tb_apb_clk; 
    end

    // Write task
    task write_apb(input logic [31:0] addr, input logic [31:0] data);
        begin
            @(posedge tb_apb_clk);
            tb_apb_psel = 1;
            tb_apb_penable = 1;
            tb_apb_pwrite = 1;
            tb_apb_paddr = addr;
            tb_apb_pwdata = data;
            @(posedge tb_apb_clk); 
            tb_apb_psel = 0;
            tb_apb_penable = 0;
            tb_apb_pwrite = 0;
        end
    endtask

    // Read task
    task read_apb(input logic [31:0] addr);
        begin
            @(posedge tb_apb_clk); 
            tb_apb_psel = 1;
            tb_apb_penable = 1;
            tb_apb_pwrite = 0;
            tb_apb_paddr = addr;
            @(posedge tb_apb_clk);
            tb_apb_psel = 0;
            tb_apb_penable = 0;
        end
    endtask

    // Testbench 
    initial begin
        tb_apb_rst_n = 0;
        tb_apb_psel = 0;
        tb_apb_penable = 0;
        tb_apb_pwrite = 0;
        tb_apb_paddr = 0;
        tb_apb_pwdata = 0;
        tb_apb_pstrb = 4'b1111;
        tb_apb_pprot = 3'b000;

        // Release reset
        #10;
        tb_apb_rst_n = 1;

        // Write few times
        write_apb(32'h0000_0000, 32'hDEADBEEF);
        write_apb(32'h0000_0004, 32'hCAFEBABE);
        write_apb(32'h0000_0008, 32'h12345678);
        write_apb(32'h0000_000C, 32'h87654321);
        write_apb(32'h0000_0010, 32'hAABBCCDD);
        write_apb(32'h0000_0014, 32'h11223344);
        write_apb(32'h0000_0018, 32'h55667788);
        write_apb(32'h0000_001C, 32'h99AABBCC);
        write_apb(32'h0000_0020, 32'hFFFFFFFF);

        // Read few times
        read_apb(32'h0000_0000);
        read_apb(32'h0000_0004);
        read_apb(32'h0000_0008);
        read_apb(32'h0000_000C);
        read_apb(32'h0000_0010);
        read_apb(32'h0000_0014);
        read_apb(32'h0000_0018);
        read_apb(32'h0000_001C);
        read_apb(32'h0000_0020);
        #200;
        $finish;
    end

endmodule