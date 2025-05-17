module control 
(
    input logic [6:0]   i_opcode,
    input logic [14:12] i_funct3,
    input logic [31:25] i_funct7,

    output logic        o_reg_write, 
    output logic [1:0]  o_result_src,
    output logic        o_mem_write, 
    output logic        o_jump,
    output logic        o_branch,
    output logic [2:0]  o_alu_control,
    output logic        o_alu_src,
    output logic [1:0]  o_imm_src
);
// Wires
wire [1:0] w_alu_op;

// Sub-modules
main_decoder main_decoder0
(
    .i_opcode       (i_opcode           ),
    .o_alu_op       (w_alu_op           ),
    .o_alu_src      (o_alu_src          ),
    .o_mem_write    (o_mem_write        ),
    .o_reg_write    (o_reg_write        ),
    .o_result_src   (o_result_src       ),
    .o_imm_src      (o_imm_src          ),
    .o_branch       (o_branch           ),
    .o_jump         (o_jump             )
);

alu_decoder alu_decoder0
(
    .i_alu_op       (w_alu_op           ),
    .i_funct3       (i_funct3           ),
    .i_funct7       (i_funct7           ),
    .o_alu_control  (o_alu_control      )
);

endmodule