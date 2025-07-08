module apb (
    // Inputs
    input logic         i_apb_clk,
    input logic         i_apb_rst_n,
    input logic         i_apb_psel,
    input logic         i_apb_penable,
    input logic         i_apb_pwrite,
    input logic [31:0]  i_apb_paddr,
    input logic [31:0]  i_apb_pwdata,
    input logic [3:0]   i_apb_pstrb,
    input logic [2:0]   i_apb_pprot,
    
    // Outputs
    output logic        o_apb_pready,
    output logic [31:0] o_apb_prdata,
    output logic        o_apb_pslverr,

    // Registers
    output logic [31:0] o_CMD,
    output logic [31:0] o_DATA_TX,
    output logic [31:0] o_DATA_RX,
    output logic [31:0] o_ADDR_COL,
    output logic [31:0] o_ADDR_ROW,
    output logic [31:0] o_STATUS,
    output logic [31:0] o_CONFIG,
    output logic [31:0] o_INT_EN
);

    // Internal registers
    logic [31:0] reg_CMD;
    logic [31:0] reg_DATA_TX;
    logic [31:0] reg_DATA_RX;
    logic [31:0] reg_ADDR_COL;
    logic [31:0] reg_ADDR_ROW;
    logic [31:0] reg_STATUS;
    logic [31:0] reg_CONFIG;
    logic [31:0] reg_INT_EN;

    // Control signals
    logic transfer_en;
    logic write_en;
    logic read_en;
    logic addr_decode_error;

    // Address constants
    localparam CMD_ADDR      = 32'h00;
    localparam DATA_TX_ADDR  = 32'h04;
    localparam DATA_RX_ADDR  = 32'h08;
    localparam ADDR_COL_ADDR = 32'h0C;
    localparam ADDR_ROW_ADDR = 32'h10;
    localparam STATUS_ADDR   = 32'h14;
    localparam CONFIG_ADDR   = 32'h18;
    localparam INT_EN_ADDR   = 32'h1C;


    assign transfer_en = i_apb_psel & i_apb_penable;
    assign write_en = transfer_en & i_apb_pwrite;
    assign read_en = transfer_en & ~i_apb_pwrite;
    assign o_apb_pready = 1'b1;  

    // Connect to outputs
    assign o_CMD = reg_CMD;
    assign o_DATA_TX = reg_DATA_TX;
    assign o_DATA_RX = reg_DATA_RX;
    assign o_ADDR_COL = reg_ADDR_COL;
    assign o_ADDR_ROW = reg_ADDR_ROW;
    assign o_STATUS = reg_STATUS;
    assign o_CONFIG = reg_CONFIG;
    assign o_INT_EN = reg_INT_EN;

    
    // Write operations
    always_ff @(posedge i_apb_clk or negedge i_apb_rst_n) begin
        if (!i_apb_rst_n) begin
            reg_CMD       <= 32'h00000000;
            reg_DATA_TX   <= 32'h00000000;
            reg_DATA_RX   <= 32'h00000000;
            reg_ADDR_COL  <= 32'h00000000;
            reg_ADDR_ROW  <= 32'h00000000;
            reg_STATUS    <= 32'h00000000;
            reg_CONFIG    <= 32'h00000000;
            reg_INT_EN    <= 32'h00000000;
        end else if (write_en) begin
            case (i_apb_paddr)
                CMD_ADDR: begin
                    if (i_apb_pstrb[0]) reg_CMD[7:0]   <= i_apb_pwdata[7:0];
                    if (i_apb_pstrb[1]) reg_CMD[15:8]  <= i_apb_pwdata[15:8];
                    if (i_apb_pstrb[2]) reg_CMD[23:16] <= i_apb_pwdata[23:16];
                    if (i_apb_pstrb[3]) reg_CMD[31:24] <= i_apb_pwdata[31:24];
                end
                DATA_TX_ADDR: begin
                    if (i_apb_pstrb[0]) reg_DATA_TX[7:0]   <= i_apb_pwdata[7:0];
                    if (i_apb_pstrb[1]) reg_DATA_TX[15:8]  <= i_apb_pwdata[15:8];
                    if (i_apb_pstrb[2]) reg_DATA_TX[23:16] <= i_apb_pwdata[23:16];
                    if (i_apb_pstrb[3]) reg_DATA_TX[31:24] <= i_apb_pwdata[31:24];
                end
                DATA_RX_ADDR:    reg_DATA_RX   <= i_apb_pwdata;
                ADDR_COL_ADDR:   reg_ADDR_COL  <= i_apb_pwdata;
                ADDR_ROW_ADDR:   reg_ADDR_ROW  <= i_apb_pwdata;
                STATUS_ADDR:     reg_STATUS    <= i_apb_pwdata;
                CONFIG_ADDR:     reg_CONFIG    <= i_apb_pwdata;
                INT_EN_ADDR:     reg_INT_EN    <= i_apb_pwdata;
                default: ;  
            endcase
        end
    end

    // Read operations
    always_comb begin
        o_apb_prdata = 32'h00000000;
        addr_decode_error = 1'b0;
        
        if (read_en) begin
            case (i_apb_paddr)
                CMD_ADDR:      o_apb_prdata = reg_CMD;
                DATA_TX_ADDR:  o_apb_prdata = reg_DATA_TX;
                DATA_RX_ADDR:  o_apb_prdata = reg_DATA_RX;
                ADDR_COL_ADDR: o_apb_prdata = reg_ADDR_COL;
                ADDR_ROW_ADDR: o_apb_prdata = reg_ADDR_ROW;
                STATUS_ADDR:   o_apb_prdata = reg_STATUS;
                CONFIG_ADDR:   o_apb_prdata = reg_CONFIG;
                INT_EN_ADDR:   o_apb_prdata = reg_INT_EN;
                default: begin
                    o_apb_prdata = 32'h00000000;
                    addr_decode_error = 1'b1;
                end
            endcase
        end
    end

    // Error handling
    assign o_apb_pslverr = addr_decode_error | (i_apb_pprot[0] & (i_apb_paddr[31:28] == 4'hF));
endmodule
