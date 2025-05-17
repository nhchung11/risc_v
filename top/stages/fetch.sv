module fetch 
(
    input logic         i_clk, i_rst_n,
    input               i_pc_src_EX,
    input [31:0]        i_pc_target_EX,

    output logic [31:0] o_pc_F,
    output logic [31:0] o_pc_plus4_F,
    output logic [31:0] o_instr_F
);

// Wires
wire [31:0] w_pc_F0;
wire [31:0] w_pc_F;

// Sub-modules
mux2to1 mux_pc0
(
    .a          (i_pc_target_EX),
    .b          (w_pc_plus4_F),
    .sel        (i_pc_src_EX),
    .y          (w_pc_F0)
);

register #(.WIDTH(32)) reg_pc0
(
    .clk        (i_clk),
    .rst        (i_rst_n),
    .en         (1'b1),
    .d          (w_pc_F0),
    .q          (o_pc_F)
);

adder #(.WIDTH(32)) adder_pc0
(
    .a          (w_pc_F),
    .b          (32'd4),
    .sum        (o_pc_plus4_F)
);

instruction_memory instruction_memory0
(
    .i_clk      (i_clk),
    .i_rst_n    (i_rst_n),
    .i_pc       (w_pc_F),
    .o_instr    (o_instr_F)
);
endmodule