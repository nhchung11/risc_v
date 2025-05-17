module mem
(
    input               i_clk, i_rst_n,
    input               i_reg_write_EX,
    input               i_mem_write_EX,
    input [31:0]        i_alu_result_EX,
    input [31:0]        i_datatB_EX,
    input [1:0]         i_result_src_EX,
    input [11:7]        i_addr_des_EX,
    input [31:0]        i_pc_plus4_EX,

    output logic [31:0] o_alu_result_MEM,
    output logic [31:0] o_data_MEM,
    output logic [11:7] o_addr_des_MEM,
    output logic [31:0] o_pc_plus4_MEM,
    output logic        o_reg_write_MEM,
    output logic [1:0]  o_result_src_MEM
);

// Wires
wire w_mem_write_MEM;
wire [31:0] w_dataB_MEM;
wire [31:0] w_alu_result_MEM;

// Sub-modules
reg_mem reg_mem0
(
    .i_clk              (i_clk              ),
    .i_rst_n            (i_rst_n            ),
    .i_reg_write_EX     (i_reg_write_EX     ),
    .i_mem_write_EX     (i_mem_write_EX     ),
    .i_alu_result_EX    (i_alu_result_EX    ),
    .i_datatB_EX        (i_datatB_EX        ),
    .i_result_src_EX    (i_result_src_EX    ),
    .i_addr_des_EX      (i_addr_des_EX      ),
    .i_pc_plus4_EX      (i_pc_plus4_EX      ),

    .o_alu_result_MEM   (w_alu_result_MEM   ),
    .o_dataB_MEM        (w_dataB_MEM        ),
    .o_addr_des_MEM     (o_addr_des_MEM     ),
    .o_pc_plus4_MEM     (o_pc_plus4_MEM     ),
    .o_reg_write_MEM    (o_reg_write_MEM    ),
    .o_mem_write_MEM    (w_mem_write_MEM    ),
    .o_result_src_MEM   (o_result_src_MEM   )
);

data_memory data_memory0
(
    .i_clk              (i_clk              ),
    .i_rstn             (i_rst_n            ),
    .i_mem_write        (w_mem_write_MEM    ),
    .i_addr             (w_alu_result_MEM   ),
    .i_data             (w_dataB_MEM        ),
    .o_data             (o_data_MEM         )
);
endmodule