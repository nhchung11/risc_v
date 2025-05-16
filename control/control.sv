module control 
(
    input i_clk, i_rstn, i_zero,
    input [31:0] i_instr,
    output logic o_reg_write, o_mem_write, o_ir_write, o_adr_src, 
    output o_pc_write, o_branch, o_pc_update,
    output logic [2:0] o_alu_control,
    output logic [1:0] o_result_src, o_alu_srcA, o_alu_srcB, o_alu_op, o_imms_rc
);

fsm fsm_inst
(
    .i_clk          (i_clk              ),
    .i_rstn         (i_rstn             ),
    .i_zero         (i_zero             ),
    .i_opcode       (i_instr[6:0]       ),    
    .o_reg_write    (o_reg_write        ),
    .o_mem_write    (o_mem_write        ),
    .o_ir_write     (o_ir_write         ),
    .o_adr_src      (o_adr_src          ),
    .o_pc_update    (o_pc_update        ),
    .o_branch       (o_branch           ),
    .o_result_src   (o_result_src       ),
    .o_alu_srcA     (o_alu_srcA         ),
    .o_alu_srcB     (o_alu_srcB         ),
    .o_alu_op       (o_alu_op           )
);

alu_decoder alu_decoder_inst
(
    .i_alu_op       (o_alu_op           ),
    .i_funct3       (i_instr[14:12]     ),
    .i_funct7       (i_instr[31:25]     ),
    .o_alu_control  (o_alu_control      )
);

instr_decoder instr_decoder_inst
(
    .i_opcode       (i_opcode           ),
    .o_imm_src      (o_imm_src          )
);
endmodule