module wb
(
    input               i_clk, i_rst_n,
    input               i_reg_write_MEM,
    input [1:0]         i_result_src_MEM,
    input [31:0]        i_alu_result_MEM,
    input [31:0]        i_data_MEM,
    input [11:7]        i_addr_des_MEM,
    input [31:0]        i_pc_plus4_MEM,

    output logic [31:0] o_result_WB,
    output logic [11:7] o_addr_des_WB,
    output logic        o_reg_write_WB 
);

// Wires
wire [31:0] w_alu_result_WB;
wire [31:0] w_data_WB;
wire [31:0] w_pc_plus4_WB;
wire [1:0]  w_result_src_WB;

// Sub-modules
reg_wb reg_wb0
(
    .i_clk              (i_clk              ),
    .i_rst_n            (i_rst_n            ),
    .i_reg_write_MEM    (i_reg_write_MEM    ),
    .i_result_src_MEM   (i_result_src_MEM   ),
    .i_alu_result_MEM   (i_alu_result_MEM   ),
    .i_data_MEM         (i_data_MEM         ),
    .i_addr_des_MEM     (i_addr_des_MEM     ),
    .i_pc_plus4_MEM     (i_pc_plus4_MEM     ),

    .o_alu_result_WB    (w_alu_result_WB    ),
    .o_data_WB          (w_data_WB          ),
    .o_addr_des_WB      (o_addr_des_WB      ),
    .o_reg_write_WB     (o_reg_write_WB     ),
    .o_pc_plus4_WB      (w_pc_plus4_WB      ),
    .o_result_src_WB    (w_result_src_WB    )
);

mux4to1 mux_WB0
(
    .a                  (w_alu_result_WB    ),
    .b                  (w_data_WB          ),
    .c                  (w_pc_plus4_WB      ),
    .d                  (32'b0              ),
    .sel                (w_result_src_WB    ),
    .y                  (o_result_WB        )
);
endmodule