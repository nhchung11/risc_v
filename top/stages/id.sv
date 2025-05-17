module id
(
    input logic         i_clk, i_rst_n,
    input logic [31:0]  i_instr_F, 
    input logic [31:0]  i_pc_F, 
    input logic [31:0]  i_pc_plus4_F,
    input logic [31:0]  i_result_WB,
    input logic [11:7]  i_addr_des_WB,
    input logic         i_reg_write_WB,

    output logic        o_reg_write_ID, 
    output logic [1:0]  o_result_src_ID,
    output logic        o_mem_write_ID,
    output logic        o_jump_ID,
    output logic        o_branch_ID,
    output logic        o_alu_src_ID,
    output logic [2:0]  o_alu_control_ID,
    output logic [31:0] o_dataA_ID,
    output logic [31:0] o_dataB_ID,
    output logic [31:0] o_pc_ID,
    output logic [31:0] o_pc_plus4_ID,
    output logic [11:7] o_addr_des_ID,
    output logic [31:0] o_imm_ext_ID
);

// Wires
logic [31:0]    w_instr_ID;
logic [1:0]     w_imm_src_ID;

// Sub-modules
reg_id reg_id0
(
    .i_clk              (i_clk              ),
    .i_rst_n            (i_rst_n            ),
    .i_instr_F          (i_instr_F          ),
    .i_pc_F             (i_pc_F             ),
    .i_pc_plus4_F       (i_pc_plus4_F       ),
    .o_instr_ID         (w_instr_ID         ),
    .o_pc_ID            (o_pc_ID            ),
    .o_pc_plus4_ID      (o_pc_plus4_ID      )
);

register_file register_file0
(
    .i_clk              (i_clk              ),
    .i_rst_n            (i_rst_n            ),
    .i_reg_write        (i_reg_write_WB     ),
    .i_addr_des         (i_addr_des_WB      ),
    .i_data             (i_result_WB        ),
    .i_addr_srcA        (w_instr_ID[19:15]  ),
    .i_addr_srcB        (w_instr_ID[24:20]  ),
    .o_dataA            (o_dataA_ID         ),
    .o_dataB            (o_dataB_ID         )
);

extend_imm extend_imm0
(
    .i_instr            (w_instr_ID[31:7]   ),
    .i_imm_src          (w_imm_src_ID       ),
    .o_imm              (o_imm_ext_ID       )
);

control control0
(
    .i_opcode           (w_instr_ID[6:0]     ),
    .i_funct3           (w_instr_ID[14:12]   ),
    .i_funct7           (w_instr_ID[31:25]   ),
    .o_reg_write        (o_reg_write_ID      ),
    .o_result_src       (o_result_src_ID     ),
    .o_mem_write        (o_mem_write_ID      ),
    .o_jump             (o_jump_ID           ),
    .o_branch           (o_branch_ID         ),
    .o_alu_control      (o_alu_control_ID    ),
    .o_alu_src          (o_alu_src_ID        ),
    .o_imm_src          (w_imm_src_ID        )
);
endmodule