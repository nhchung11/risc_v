module reg_id
(
    input i_clk, i_rst_n,
    input [31:0] i_instr_F, i_pc_F, i_pc_plus4_F,
    output logic [31:0] o_instr_ID, o_pc_ID, o_pc_plus4_ID
);

register #(.WIDTH(32)) reg_instr_F
(
    .clk    (i_clk),
    .rst    (i_rst_n),
    .en     (1'b1),
    .d      (i_instr_F),
    .q      (o_instr_ID)
);

register #(.WIDTH(32)) reg_pc_F
(
    .clk    (i_clk),
    .rst    (i_rst_n),
    .en     (1'b1),
    .d      (i_pc_F),
    .q      (o_pc_ID)
);

register #(.WIDTH(32)) reg_pc_plus4_F
(
    .clk    (i_clk),
    .rst    (i_rst_n),
    .en     (1'b1),
    .d      (i_pc_plus4_F),
    .q      (o_pc_plus4_ID)
);
endmodule