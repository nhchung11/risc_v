package register_offset_pkg;
    // REGISTER OFFSETS
    localparam int CONTROL_OFFSET       = 32'h100;
    localparam int STATUS_OFFSET        = 32'h104;
    localparam int COMMAND_OFFSET       = 32'h108;
    localparam int ADDR0_OFFSET         = 32'h10C;
    localparam int ADDR1_OFFSET         = 32'h110;
    localparam int ADDR2_OFFSET         = 32'h114;
    localparam int DATA_TX_OFFSET       = 32'h118;
    localparam int DATA_RX_OFFSET       = 32'h11C;
    localparam int FIFO_STATUS_OFFSET   = 32'h120;
    localparam int ECC_CTRL_OFFSET      = 32'h124;
    localparam int ECC_STATUS_OFFSET    = 32'h128;
    localparam int TIMING_CFG_OFFSET    = 32'h12C;
    localparam int DMA_CTRL_OFFSET      = 32'h130;
    localparam int INT_STATUS_OFFSET    = 32'h134;
    localparam int INT_MASK_OFFSET      = 32'h138;
    localparam int BAD_BLOCK_REG_OFFSET = 32'h13C;
    localparam int CFG_OFFSET           = 32'h140;
endpackage: register_offset_pkg