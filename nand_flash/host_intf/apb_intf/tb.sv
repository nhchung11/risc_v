module tb;

    // Testbench signals
    logic i_apb_clk;
    logic i_apb_rst_n;
    logic i_apb_psel;
    logic i_apb_penable;
    logic i_apb_pwrite;
    logic [31:0] i_apb_paddr;
    logic [31:0] i_apb_pwdata;
    logic [3:0] i_apb_pstrb;
    logic [31:0] i_DATA_RX;
    logic [31:0] i_STATUS;
    logic [31:0] i_FIFO_STATUS;
    logic [31:0] i_ECC_STATUS;
    logic [31:0] i_INT_STATUS;
    logic [31:0] i_BAD_BLOCK_REG;

    // Outputs
    logic o_apb_pready;
    logic [31:0] o_apb_prdata;
    logic o_apb_pslverr;
    logic [31:0] o_CMD;
    logic [31:0] o_COMMAND;
    logic [31:0] o_ADDR0;
    logic [31:0] o_ADDR1;
    logic [31:0] o_ADDR2;
    logic [31:0] o_DATA_TX;
    logic [31:0] o_ECC_CTR;
    logic [31:0] o_TIMING_CFG;
    logic [31:0] o_DMA_CTRL;
    logic [31:0] o_INT_MASK;
    logic [31:0] o_CFG;

    // Instantiate the DUT
    apb dut (
        .i_apb_clk(i_apb_clk),
        .i_apb_rst_n(i_apb_rst_n),
        .i_apb_psel(i_apb_psel),
        .i_apb_penable(i_apb_penable),
        .i_apb_pwrite(i_apb_pwrite),
        .i_apb_paddr(i_apb_paddr),
        .i_apb_pwdata(i_apb_pwdata),
        .i_apb_pstrb(i_apb_pstrb),
        .i_apb_pprot(3'b000), 
        .i_DATA_RX(i_DATA_RX),
        .i_STATUS(i_STATUS),
        .i_FIFO_STATUS(i_FIFO_STATUS),
        .i_ECC_STATUS(i_ECC_STATUS),
        .i_INT_STATUS(i_INT_STATUS),
        .i_BAD_BLOCK_REG(i_BAD_BLOCK_REG),
        .o_apb_pready(o_apb_pready),
        .o_apb_prdata(o_apb_prdata),
        .o_apb_pslverr(o_apb_pslverr),
        .o_CMD(o_CMD),
        .o_COMMAND(o_COMMAND),
        .o_ADDR0(o_ADDR0),
        .o_ADDR1(o_ADDR1),
        .o_ADDR2(o_ADDR2),
        .o_DATA_TX(o_DATA_TX),
        .o_ECC_CTR(o_ECC_CTR),
        .o_TIMING_CFG(o_TIMING_CFG),
        .o_DMA_CTRL(o_DMA_CTRL),
        .o_INT_MASK(o_INT_MASK),
        .o_CFG(o_CFG)
    );

    // Clock generation
    initial begin
        i_apb_clk = 0;
        forever #5 i_apb_clk = ~i_apb_clk; // 100MHz clock
    end

    // Test sequence
    initial begin
        // Initialize inputs
        i_apb_rst_n = 0;
        i_apb_psel = 0;
        i_apb_penable = 0;
        i_apb_pwrite = 0;
        i_apb_paddr = 0;
        i_apb_pwdata = 0;
        i_apb_pstrb = 4'b1111;
        i_DATA_RX = 32'hDEADBEEF;
        i_STATUS = 32'h00000000;
        i_FIFO_STATUS = 32'h00000000;
        i_ECC_STATUS = 32'h00000000;
        i_INT_STATUS = 32'h00000000;
        i_BAD_BLOCK_REG = 32'h00000000;

        // Reset the DUT
        #10;
        i_apb_rst_n = 1;

        // Test write operation
        i_apb_psel = 1;
        i_apb_penable = 1;
        i_apb_pwrite = 1;
        i_apb_paddr = 32'h00; // Write to CMD
        i_apb_pwdata = 32'h12345678;
        #10;

        // Test read operation
        i_apb_pwrite = 0;
        i_apb_paddr = 32'h00; // Read CMD
        #10;

        // Check output
        if (o_apb_prdata !== 32'h12345678) begin
            $display("Error: Read data mismatch!");
        end else begin
            $display("Read data matched: %h", o_apb_prdata);
        end

        // Finish simulation
        #100;
        $finish;
    end

endmodule