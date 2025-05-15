module control 
(
    input i_clk, i_rstn, i_zero,
    input [31:0] i_instr,
    output logic o_RegWrite, o_MemWrite, o_IRWrite, o_AdSrc, 
    output o_PCWrite,
    output logic [1:0] o_ResultSrc, o_ALUSrcA, o_ALUSrcB, o_ALUOp, o_ImmSrc
);

logic Branch, PCUpdate;
assign o_PCWrite = PCUpdate | (Branch & i_zero);

fsm fsm_inst
(
    .i_clk          (i_clk          ),
    .i_rstn         (i_rstn         ),
    .i_zero         (i_zero         ),
    .i_opcode       (i_instr[6:0]   ),    
    .o_RegWrite     (o_RegWrite     ),
    .o_MemWrite     (o_MemWrite     ),
    .o_IRWrite      (o_IRWrite      ),
    .o_AdSrc        (o_AdSrc        ),
    .o_PCUpdate     (PCUpdate       ),
    .o_Branch       (Branch         ),
    .o_ResultSrc    (o_ResultSrc    ),
    .o_ALUSrcA      (o_ALUSrcA      ),
    .o_ALUSrcB      (o_ALUSrcB      ),
    .o_ALUOp        (o_ALUOp        )
);

alu_decoder alu_decoder_inst
(
    .i_ALUOp        (o_ALUOp        ),
    .i_funct3       (i_instr[14:12] ),
    .i_funct7       (i_instr[31:25] ),
    .o_alu_control  (o_ALUOp        )
);

instr_decoder instr_decoder_inst
(
    .i_opcode       (i_opcode       ),
    .o_immsrc       (o_ImmSrc       )
);
endmodule