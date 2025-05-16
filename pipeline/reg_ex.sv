module reg_ex
(
    input i_clk, i_rst_n,
    input [31:0] i_dataA_ID, i_dataB_ID, 
    input [31:0] i_pc_ID, imm_ext_ID, i_pc_plus4_ID,
    input [11:7] i_addr_des_ID,
    input i_alu_src_ID, i_branch_ID, i_jump_ID, i_mem_write_ID, i_reg_write_ID,
    input [2:0] i_alu_control_ID,
    input [1:0] i_result_src_ID, 

    output logic [31:0] o_dataA_EX, o_dataB_EX,
    output logic [31:0] o_pc_EX, o_pc_plus4_EX, o_imm_ext_EX,
    output logic [11:7] o_addr_des_EX,
    output logic o_alu_src_EX, o_branch_EX, o_jump_EX, o_mem_write_EX, o_reg_write_EX,
    output logic [2:0] o_alu_control_EX,
    output logic [1:0] o_result_src_EX
);

register #(.WIDTH(32)) reg_dataA_ID
(
    .clk    (i_clk),
    .rst    (i_rst_n),
    .en     (1'b1),
    .d      (i_dataA_ID),
    .q      (o_dataA_EX)
);

register #(.WIDTH(32)) reg_dataB_ID
(
    .clk    (i_clk),
    .rst    (i_rst_n),
    .en     (1'b1),
    .d      (i_dataB_ID),
    .q      (o_dataB_EX)
);

register #(.WIDTH(32)) reg_pc_ID
(
    .clk    (i_clk),
    .rst    (i_rst_n),
    .en     (1'b1),
    .d      (i_pc_ID),
    .q      (o_pc_EX)
);

register #(.WIDTH(32)) reg_pc_plus4_ID
(
    .clk    (i_clk),
    .rst    (i_rst_n),
    .en     (1'b1),
    .d      (i_pc_plus4_ID),
    .q      (o_pc_plus4_EX)
);

register #(.WIDTH(32)) reg_imm_ext_ID
(
    .clk    (i_clk),
    .rst    (i_rst_n),
    .en     (1'b1),
    .d      (imm_ext_ID),
    .q      (o_imm_ext_EX)
);

register #(.WIDTH(5)) reg_addr_des_ID
(
    .clk    (i_clk),
    .rst    (i_rst_n),
    .en     (1'b1),
    .d      (i_addr_des_ID),
    .q      (o_addr_des_EX)
);

register #(.WIDTH(1)) reg_alu_src_ID
(
    .clk    (i_clk),
    .rst    (i_rst_n),
    .en     (1'b1),
    .d      (i_alu_src_ID),
    .q      (o_alu_src_EX)
);
register #(.WIDTH(1)) reg_branch_ID
(
    .clk    (i_clk),
    .rst    (i_rst_n),
    .en     (1'b1),
    .d      (i_branch_ID),
    .q      (o_branch_EX)
);

register #(.WIDTH(1)) reg_jump_ID
(
    .clk    (i_clk),
    .rst    (i_rst_n),
    .en     (1'b1),
    .d      (i_jump_ID),
    .q      (o_jump_EX)
);

register #(.WIDTH(1)) reg_mem_write_ID
(
    .clk    (i_clk),
    .rst    (i_rst_n),
    .en     (1'b1),
    .d      (i_mem_write_ID),
    .q      (o_mem_write_EX)
);

register #(.WIDTH(1)) reg_reg_write_ID
(
    .clk    (i_clk),
    .rst    (i_rst_n),
    .en     (1'b1),
    .d      (i_reg_write_ID),
    .q      (o_reg_write_EX)
);

register #(.WIDTH(3)) reg_alu_control_ID
(
    .clk    (i_clk),
    .rst    (i_rst_n),
    .en     (1'b1),
    .d      (i_alu_control_ID),
    .q      (o_alu_control_EX)
);

register #(.WIDTH(2)) reg_result_src_ID
(
    .clk    (i_clk),
    .rst    (i_rst_n),
    .en     (1'b1),
    .d      (i_result_src_ID),
    .q      (o_result_src_EX)
);
endmodule