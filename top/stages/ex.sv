module ex
(
    input logic         i_clk, i_rst_n,
    input logic         i_reg_write_ID,
    input logic         i_mem_write_ID,
    input logic [1:0]   i_result_src_ID,
    input logic         i_jump_ID,
    input logic         i_branch_ID,
    input logic [2:0]   i_alu_control_ID,
    input logic         i_alu_src_ID,
    input logic [31:0]  i_dataA_ID,
    input logic [31:0]  i_dataB_ID,
    input logic [31:0]  i_pc_ID,
    input logic [31:0]  i_imm_ext_ID,
    input logic [11:7]  i_addr_des_ID,
    input logic [31:0]  i_pc_plus4_ID,  

    output logic        o_reg_write_EX,
    output logic        o_mem_write_EX,
    output logic [1:0]  o_result_src_EX,
    output logic [31:0] o_alu_result_EX,
    output logic [31:0] o_dataB_EX,
    output logic [31:0] o_addr_des_EX,
    output logic [31:0] o_pc_plus4_EX,
    output logic [31:0] o_pc_target_EX,
    output logic        o_pc_src_EX
);

// Wires
wire [31:0] w_alu_src_EX;
wire [2:0]  w_alu_control_EX;
wire        w_jump_EX;
wire        w_branch_EX;
wire [31:0] w_dataB_EX;
wire [31:0] w_dataB_mux_EX;
wire [31:0] w_dataA_EX;
wire [31:0] w_pc_EX;
wire [31:0] w_imm_ext_EX;
wire        w_zero_EX;

// Combinational logic
assign o_pc_src_EX = w_jump_EX | (w_branch_EX & w_zero_EX);

// Sub-modules
reg_ex reg_ex0
(
    .i_clk              (i_clk              ),
    .i_rst_n            (i_rst_n            ),
    .i_dataA_ID         (i_dataA_ID         ),
    .i_dataB_ID         (i_dataB_ID         ),
    .i_pc_ID            (i_pc_ID            ),
    .imm_ext_ID         (i_imm_ext_ID       ),
    .i_pc_plus4_ID      (i_pc_plus4_ID      ),
    .i_addr_des_ID      (i_addr_des_ID      ),
    .i_alu_src_ID       (i_alu_src_ID       ),
    .i_branch_ID        (i_branch_ID        ),
    .i_jump_ID          (i_jump_ID          ),
    .i_mem_write_ID     (i_mem_write_ID     ),
    .i_reg_write_ID     (i_reg_write_ID     ),
    .i_alu_control_ID   (i_alu_control_ID   ),

    .o_dataA_EX         (w_dataA_EX         ),
    .o_dataB_EX         (w_dataB_EX         ),
    .o_pc_EX            (w_pc_EX            ),
    .o_pc_plus4_EX      (o_pc_plus4_EX      ),
    .o_imm_ext_EX       (w_imm_ext_EX       ),
    .o_addr_des_EX      (o_addr_des_EX      ),
    .o_alu_src_EX       (w_alu_src_EX       ), 
    .o_branch_EX        (w_branch_EX        ), 
    .o_jump_EX          (w_jump_EX          ), 
    .o_alu_control_EX   (w_alu_control_EX   )
);

mux2to1 mux_B0
(
    .a                  (w_dataB_EX         ),
    .b                  (w_imm_ext_EX       ),
    .sel                (w_alu_src_EX       ),
    .y                  (w_dataB_mux_EX     )
);

adder #(.WIDTH(32)) adder_EX0
(
    .a                  (w_pc_EX            ),
    .b                  (w_imm_ext_EX       ),
    .sum                (o_pc_target_EX     )
);

alu alu0
(
    .i_srcA             (w_dataA_EX         ),
    .i_srcB             (w_dataB_mux_EX     ),
    .i_alu_control      (w_alu_control_EX   ),
    .o_alu              (o_alu_result_EX    ),
    .o_zero             (w_zero_EX          )
);
endmodule