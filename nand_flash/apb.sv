module apb 
import register_offset_pkg::*;
(
    // Inputs
    input logic         i_apb_clk       ,
    input logic         i_apb_rst_n     ,
    input logic         i_apb_psel      ,
    input logic         i_apb_penable   ,
    input logic         i_apb_pwrite    ,
    input logic [31:0]  i_apb_paddr     ,
    input logic [31:0]  i_apb_pwdata    ,
    input logic [3:0]   i_apb_pstrb     ,
    input logic [2:0]   i_apb_pprot     ,
    
    // Outputs
    output logic        o_apb_pready    ,
    output logic [31:0] o_apb_prdata    ,
    output logic        o_apb_pslverr   ,
    output logic        o_cmd_start     ,

    // Registers
    output logic [31:0] o_CONTROL       ,
    input  logic [31:0] i_STATUS        ,
    output logic [31:0] o_COMMAND       ,
    output logic [31:0] o_ADDR0         ,
    output logic [31:0] o_ADDR1         ,
    output logic [31:0] o_ADDR2         ,
    output logic [31:0] o_DATA_TX       ,
    input  logic [31:0] i_DATA_RX       ,
    input  logic [31:0] i_FIFO_STATUS   ,
    output logic [31:0] o_ECC_CTR       ,
    input  logic [31:0] i_ECC_STATUS    ,
    output logic [31:0] o_TIMING_CFG    ,
    output logic [31:0] o_DMA_CTRL      ,
    input  logic [31:0] i_INT_STATUS    ,
    output logic [31:0] o_INT_MASK      ,
    input  logic [31:0] i_BAD_BLOCK_REG ,
    output logic [31:0] o_CFG
);

    // Internal registers
    logic [31:0] CONTROL        ;   // RW
    logic [31:0] STATUS         ;   // RO
    logic [31:0] COMMAND        ;   // RW
    logic [31:0] ADDR0          ;   // RW
    logic [31:0] ADDR1          ;   // RW
    logic [31:0] ADDR2          ;   // RW
    logic [31:0] DATA_TX        ;   // RW
    logic [31:0] DATA_RX        ;   // RO
    logic [31:0] FIFO_STATUS    ;   // RW
    logic [31:0] ECC_CTR        ;   // RW
    logic [31:0] ECC_STATUS     ;   // RO
    logic [31:0] TIMING_CFG     ;   // RW
    logic [31:0] DMA_CTRL       ;   // RW
    logic [31:0] INT_STATUS     ;   // RW
    logic [31:0] INT_MASK       ;   // RW
    logic [31:0] BAD_BLOCK_REG  ;   // RO
    logic [31:0] CFG            ;   // RW

    // Control signals
    logic transfer_en;
    logic write_en;
    logic read_en;
    logic addr_decode_error;
    logic soft_reset;

    assign transfer_en  = i_apb_psel & i_apb_penable;
    assign write_en     = transfer_en & i_apb_pwrite;
    assign read_en      = transfer_en & ~i_apb_pwrite;
    assign o_apb_pready = 1'b1;
    assign soft_reset = CONTROL[0];  
    
    // Error handling
    assign o_apb_pslverr = addr_decode_error | (i_apb_pprot[0] & (i_apb_paddr[31:28] == 4'hF));
    assign o_cmd_start = write_en & (i_apb_paddr == COMMAND_OFFSET);
    
    // Connect to outputs
    assign o_CONTROL        = CONTROL   ;
    assign o_STATUS         = STATUS    ;
    assign o_COMMAND        = COMMAND   ;
    assign o_ADDR0          = ADDR0     ;
    assign o_ADDR1          = ADDR1     ;
    assign o_ADDR2          = ADDR2     ;
    assign o_DATA_TX        = DATA_TX   ;
    assign o_ECC_CTR        = ECC_CTR   ;
    assign o_TIMING_CFG     = TIMING_CFG;
    assign o_DMA_CTRL       = DMA_CTRL  ;
    assign o_INT_MASK       = INT_MASK  ;
    assign o_CFG            = CFG       ;

    
    // Write operations
    always_ff @(posedge i_apb_clk or negedge i_apb_rst_n) begin
        if (!i_apb_rst_n) begin
            CONTROL         <= 32'h00000000;
            STATUS          <= 32'h00000000;
            COMMAND         <= 32'h00000000;
            ADDR0           <= 32'h00000000;
            ADDR1           <= 32'h00000000;
            ADDR2           <= 32'h00000000;
            DATA_TX         <= 32'h00000000;
            FIFO_STATUS     <= 32'h00000000;
            ECC_CTR         <= 32'h00000000;
            ECC_STATUS      <= 32'h00000000;
            TIMING_CFG      <= 32'h00000000;
            DMA_CTRL        <= 32'h00000000;
            INT_STATUS      <= 32'h00000000;
            INT_MASK        <= 32'h00000000;
            BAD_BLOCK_REG   <= 32'h00000000;
            CFG             <= 32'h00000000;
        end else if (soft_reset) begin
            CONTROL         <= 32'h00000000;
            COMMAND         <= 32'h00000000;
            ADDR0           <= 32'h00000000;
            ADDR1           <= 32'h00000000;
            ADDR2           <= 32'h00000000;
            DATA_TX         <= 32'h00000000;
            FIFO_STATUS     <= 32'h00000000;
            ECC_CTR         <= 32'h00000000;
            TIMING_CFG      <= 32'h00000000;
            DMA_CTRL        <= 32'h00000000;
            INT_STATUS      <= 32'h00000000;
            INT_MASK        <= 32'h00000000;
            CFG             <= 32'h00000000;
        end else if (write_en) begin
            case (i_apb_paddr)
                CONTROL_OFFSET: begin
                    if (i_apb_pstrb[0]) CONTROL[7:0]   <= i_apb_pwdata[7:0];
                    if (i_apb_pstrb[1]) CONTROL[15:8]  <= i_apb_pwdata[15:8];
                    if (i_apb_pstrb[2]) CONTROL[23:16] <= i_apb_pwdata[23:16];
                    if (i_apb_pstrb[3]) CONTROL[31:24] <= i_apb_pwdata[31:24];
                end
                COMMAND_OFFSET: begin
                    if (i_apb_pstrb[0]) COMMAND[7:0]   <= i_apb_pwdata[7:0];
                    if (i_apb_pstrb[1]) COMMAND[15:8]  <= i_apb_pwdata[15:8];
                    if (i_apb_pstrb[2]) COMMAND[23:16] <= i_apb_pwdata[23:16];
                    if (i_apb_pstrb[3]) COMMAND[31:24] <= i_apb_pwdata[31:24];
                end
                ADDR0_OFFSET: ADDR0 <= i_apb_pwdata;
                ADDR1_OFFSET: ADDR1 <= i_apb_pwdata;
                ADDR2_OFFSET: ADDR2 <= i_apb_pwdata;
                DATA_TX_OFFSET: DATA_TX <= i_apb_pwdata;
                ECC_CTR_OFFSET: begin
                    if (i_apb_pstrb[0]) ECC_CTR[7:0]   <= i_apb_pwdata[7:0];
                    if (i_apb_pstrb[1]) ECC_CTR[15:8]  <= i_apb_pwdata[15:8];
                    if (i_apb_pstrb[2]) ECC_CTR[23:16] <= i_apb_pwdata[23:16];
                    if (i_apb_pstrb[3]) ECC_CTR[31:24] <= i_apb_pwdata[31:24];
                end
                TIMING_CFG_OFFSET: TIMING_CFG <= i_apb_pwdata;
                DMA_CTRL_OFFSET: begin
                    if (i_apb_pstrb[0]) DMA_CTRL[7:0]   <= i_apb_pwdata[7:0];
                    if (i_apb_pstrb[1]) DMA_CTRL[15:8]  <= i_apb_pwdata[15:8];
                    if (i_apb_pstrb[2]) DMA_CTRL[23:16] <= i_apb_pwdata[23:16];
                    if (i_apb_pstrb[3]) DMA_CTRL[31:24] <= i_apb_pwdata[31:24];
                end
                INT_STATUS_OFFSET: INT_STATUS <= i_apb_pwdata; // Write to clear
                INT_MASK_OFFSET: begin
                    if (i_apb_pstrb[0]) INT_MASK[7:0]   <= i_apb_pwdata[7:0];
                    if (i_apb_pstrb[1]) INT_MASK[15:8]  <= i_apb_pwdata[15:8];
                    if (i_apb_pstrb[2]) INT_MASK[23:16] <= i_apb_pwdata[23:16];
                    if (i_apb_pstrb[3]) INT_MASK[31:24] <= i_apb_pwdata[31:24];
                end
                CFG_OFFSET: begin
                    if (i_apb_pstrb[0]) CFG[7:0]   <= i_apb_pwdata[7:0];
                    if (i_apb_pstrb[1]) CFG[15:8]  <= i_apb_pwdata[15:8];
                    if (i_apb_pstrb[2]) CFG[23:16] <= i_apb_pwdata[23:16];
                    if (i_apb_pstrb[3]) CFG[31:24] <= i_apb_pwdata[31:24];
                end                
                default: ;  
            endcase
        end else begin
            CONTROL[0] <= 1'b0; 
        end
    end

    // Read operations
    always_comb begin
        o_apb_prdata = 32'h00000000;
        addr_decode_error = 1'b0;
        
        if (read_en) begin
            case (i_apb_paddr)
                CONTROL_OFFSET:         o_apb_prdata = CONTROL          ;
                STATUS_OFFSET:          o_apb_prdata = STATUS           ;
                COMMAND_OFFSET:         o_apb_prdata = COMMAND          ; 
                ADDR0_OFFSET:           o_apb_prdata = ADDR0            ;
                ADDR1_OFFSET:           o_apb_prdata = ADDR1            ;
                ADDR2_OFFSET:           o_apb_prdata = ADDR2            ;
                DATA_TX_OFFSET:         o_apb_prdata = DATA_TX          ;
                DATA_RX_OFFSET:         o_apb_prdata = DATA_RX          ;
                FIFO_STATUS_OFFSET:     o_apb_prdata = FIFO_STATUS      ;
                ECC_CTR_OFFSET:         o_apb_prdata = ECC_CTR          ;
                ECC_STATUS_OFFSET:      o_apb_prdata = ECC_STATUS       ;
                TIMING_CFG_OFFSET:      o_apb_prdata = TIMING_CFG       ;
                DMA_CTRL_OFFSET:        o_apb_prdata = DMA_CTRL         ;
                INT_STATUS_OFFSET:      o_apb_prdata = INT_STATUS       ;
                INT_MASK_OFFSET:        o_apb_prdata = INT_MASK         ;
                BAD_BLOCK_REG_OFFSET:   o_apb_prdata = BAD_BLOCK_REG    ;
                CFG_OFFSET:             o_apb_prdata = CFG              ;
                default: begin
                    o_apb_prdata = 32'h00000000;
                    addr_decode_error = 1'b1;
                end
            endcase
        end
    end

    always_ff @(posedge i_apb_clk or negedge i_apb_rst_n) begin
        if (!i_apb_rst_n) begin
            STATUS          <= 32'h00000000     ;
            FIFO_STATUS     <= 32'h00000000     ;
            INT_STATUS      <= 32'h00000000     ;
            DATA_RX         <= 32'h00000000     ;
            ECC_STATUS      <= 32'h00000000     ;
            BAD_BLOCK_REG   <= 32'h00000000     ;
        end else begin
            DATA_RX         <= i_DATA_RX        ;
            FIFO_STATUS     <= i_FIFO_STATUS    ;
            STATUS          <= i_STATUS         ; 
            ECC_STATUS      <= i_ECC_STATUS     ;
            INT_STATUS      <= i_INT_STATUS     ;
            BAD_BLOCK_REG   <= i_BAD_BLOCK_REG  ;
        end
    end
endmodule

