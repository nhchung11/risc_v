module top
(
    input i_clk, i_rstn
);

wire [31:0] w_instr, w_instr_reg;
wire [31:0] w_pc, w_Adr, w_old_pc;
wire [31:0] w_write_data, w_read_data1, w_read_data2;
wire [4:0]  w_write_adr, w_read_adr1, w_read_adr2;
wire        w_RegWrite;
wire [31:0] w_srcA, w_srcB;
wire [2:0]  w_alu_control;
wire        w_zero;
wire [31:0] w_ALU;
wire        w_MemWrite, w_IRWrite, w_AdSrc, w_PCWrite;
wire [1:0]  w_ResultSrc, w_ALUSrcA, w_ALUSrcB, w_ALUOp, w_ImmSrc;
wire [31:0] w_PCNext;
wire [32:0] w_ImmExt;
wire [31:0] w_data1_reg, w_data2_reg;

instruction_memory imem_inst
(
    .i_clk          (i_clk          ),
    .i_rstn         (i_rstn         ),
    .i_pc           (w_Adr          ),   
    .o_instr        (w_instr          )
);

register_file rf_ints
(
    .i_clk          (i_clk          ),
    .i_rst_n        (i_rstn         ),
    .i_RegWrite     (w_RegWrite     ),
    .i_write_data   (w_write_data   ),
    .i_read_adr1    (w_read_adr1    ),
    .i_read_adr2    (w_read_adr2    ),
    .i_write_adr    (w_write_adr    ),
    .o_read_data1   (w_read_data1   ),
    .o_read_data2   (w_read_data2   )
);

alu alu_inst
(
    .i_srcA        (w_srcA        ),
    .i_srcB        (w_srcB        ),
    .i_alu_control (w_alu_control ),
    .o_ALU         (w_ALU         ),
    .o_zero        (w_zero        )
);

control control_ins
(
    .i_clk          (i_clk          ),
    .i_rstn         (i_rstn         ),
    .i_zero         (w_zero         ),
    .i_instr        (w_instr        ),
    .o_RegWrite     (w_RegWrite     ),
    .o_MemWrite     (w_MemWrite     ),
    .o_IRWrite      (w_IRWrite      ),
    .o_AdSrc        (w_AdSrc        ),
    .o_PCUpdate     (w_PCUpdate     ),
    .o_Branch       (w_Branch       ),
    .o_ResultSrc    (w_ResultSrc    ),
    .o_ALUSrcA      (w_ALUSrcA      ),
    .o_ALUSrcB      (w_ALUSrcB      ),
    .o_ALUOp        (w_ALUOp        )
);

extend_immediate ext_immediate_inst
(
    .i_instr        (w_instr        ),
    .i_immsrc       (w_ImmSrc       ),
    .o_imm          (w_ImmExt       )  
);

register #(.WIDTH(32)) pc_reg
(
    .clk            (i_clk          ),
    .rstn           (i_rstn         ),
    .en             (w_PCWrite      ),
    .d              (w_PCNext       ),
    .q              (w_pc           )
);

mux2to1 mux_pc
(
    .i_data0        (w_pc           ),
    .i_data1        (w_ALU          ),
    .i_sel          (w_AdSrc        ),
    .o_data         (w_Adr          )
);

register #(.WIDTH(32)) instr_reg
(
    .clk            (i_clk          ),
    .rstn           (i_rstn         ),
    .en             (w_IRWrite      ),
    .d              (w_instr        ),
    .q              (w_instr_reg    )
);

register #(.WIDTH(32)) read_dataA_reg
(
    .clk            (i_clk          ),
    .rstn           (i_rstn         ),
    .en             (1'b1           ),
    .d              (w_read_data1   ),
    .q              (w_data1_reg    )
);

register #(.WIDTH(32)) read_dataB_reg
(
    .clk            (i_clk          ),
    .rstn           (i_rstn         ),
    .en             (1'b1           ),
    .d              (w_read_data2   ),
    .q              (w_data2_reg    )
);

register #(.WIDTH(32)) old_pc_reg
(
    .clk            (i_clk          ),
    .rstn           (i_rst_n        ),
    .en             (w_IRWrite      ),
    .d              (w_pc           ),
    .q              (w_old_pc       )
)


endmodule