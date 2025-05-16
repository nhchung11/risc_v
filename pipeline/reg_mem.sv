module reg_mem
(
    input i_clk, i_rst_n,
    input i_reg_write_EX, i_mem_write_EX,
    input [31:0] i_alu_result_EX, i_datatB_EX,
    input [1:0] i_result_src_EX,
    input [11:7] i_addr_des_EX,
    input [31:0] i_pc_plus4_EX,

    output logic [31:0] o_alu_result_MEM, o_dataB_MEM,
    output logic [11:7] o_addr_des_MEM,
    output logic [31:0] o_pc_plus4_MEM,
    output logic o_reg_write_MEM, o_mem_write_MEM,
    output logic [1:0] o_result_src_MEM
);

register #(.WIDTH(32)) reg_alu_result_EX
(
    .clk    (i_clk),
    .rst    (i_rst_n),
    .en     (1'b1),
    .d      (i_alu_result_EX),
    .q      (o_alu_result_MEM)
);

register #(.WIDTH(32)) reg_dataB_EX
(
    .clk    (i_clk),
    .rst    (i_rst_n),
    .en     (1'b1),
    .d      (i_datatB_EX),
    .q      (o_dataB_MEM)
);

register #(.WIDTH(32)) reg_pc_plus4_EX
(
    .clk    (i_clk),
    .rst    (i_rst_n),
    .en     (1'b1),
    .d      (i_pc_plus4_EX),
    .q      (o_pc_plus4_MEM)
);

register #(.WIDTH(5)) reg_addr_des_EX
(
    .clk    (i_clk),
    .rst    (i_rst_n),
    .en     (1'b1),
    .d      (i_addr_des_EX),
    .q      (o_addr_des_MEM)
);

register #(.WIDTH(1)) reg_reg_write_EX
(
    .clk    (i_clk),
    .rst    (i_rst_n),
    .en     (1'b1),
    .d      (i_reg_write_EX),
    .q      (o_reg_write_MEM)
);

register #(.WIDTH(1)) reg_mem_write_EX
(
    .clk    (i_clk),
    .rst    (i_rst_n),
    .en     (1'b1),
    .d      (i_mem_write_EX),
    .q      (o_mem_write_MEM)
);

register #(.WIDTH(2)) reg_result_src_EX
(
    .clk    (i_clk),
    .rst    (i_rst_n),
    .en     (1'b1),
    .d      (i_result_src_EX),
    .q      (o_result_src_MEM)
);

endmodule