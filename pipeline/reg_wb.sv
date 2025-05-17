module reg_wb
(
    input               i_clk, i_rst_n,
    input               i_reg_write_MEM,
    input [1:0]         i_result_src_MEM,
    input [31:0]        i_alu_result_MEM,
    input [31:0]        i_data_MEM,
    input [11:7]        i_addr_des_MEM,
    input [31:0]        i_pc_plus4_MEM,

    output logic [31:0] o_alu_result_WB,
    output logic [31:0] o_data_WB,
    output logic [11:7] o_addr_des_WB,
    output logic        o_reg_write_WB,
    output logic [31:0] o_pc_plus4_WB,
    output logic [1:0]  o_result_src_WB
);

    register #(.WIDTH(32)) reg_alu_result_MEM
    (
        .clk    (i_clk),
        .rst    (i_rst_n),
        .en     (1'b1),
        .d      (i_alu_result_MEM),
        .q      (o_alu_result_WB)
    );

    register #(.WIDTH(32)) reg_data_MEM
    (
        .clk    (i_clk),
        .rst    (i_rst_n),
        .en     (1'b1),
        .d      (i_data_MEM),
        .q      (o_data_WB)
    );

    register #(.WIDTH(5)) reg_addr_des_MEM
    (
        .clk    (i_clk),
        .rst    (i_rst_n),
        .en     (1'b1),
        .d      (i_addr_des_MEM),
        .q      (o_addr_des_WB)
    );
endmodule