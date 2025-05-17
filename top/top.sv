module top
(
    input i_clk, i_rstn
);

// Wires
wire [31:0] w_pc_F;
wire [31:0] w_pc_plus4_F;
wire [31:0] w_instr_F;
wire [31:0] w_pc_ID;
wire [31:0] w_pc_plus4_ID;
wire [31:0] w_result_WB;
wire [11:7] w_addr_des_WB;
wire        w_reg_write_WB;
wire        w_reg_write_ID;
wire [31:0] w_dataA_ID;
wire [31:0] w_dataB_ID;
wire [31:0] w_imm_ext_ID;
wire [11:7] w_addr_des_ID;
wire        w_alu_src_ID;
wire        w_branch_ID;
wire        w_jump_ID;
wire        w_mem_write_ID;
wire [1:0]  w_result_src_ID;
wire [2:0]  w_alu_control_ID;
wire        w_reg_write_EX;
wire        w_mem_write_EX;
wire [1:0]  w_result_src_EX;
wire [31:0] w_alu_result_EX;
wire [31:0] w_dataB_EX;
wire [31:0] w_addr_des_EX;
wire [31:0] w_pc_plus4_EX;
wire [31:0] w_pc_target_EX;
wire        w_pc_src_EX;
wire [31:0] w_alu_result_MEM;
wire [31:0] w_data_MEM;
wire [11:7] w_addr_des_MEM;
wire [31:0] w_pc_plus4_MEM;
wire        w_reg_write_MEM;
wire [1:0]  w_result_src_MEM;

// Sub-modules
fetch fetch0
(
    .i_clk              (i_clk              ),
    .i_rst_n            (i_rstn             ),
    .i_pc_src_EX        (w_pc_src_EX        ),
    .i_pc_target_EX     (w_pc_target_EX     ),

    .o_pc_F             (w_pc_F             ),
    .o_pc_plus4_F       (w_pc_plus4_F       ),
    .o_instr_F          (w_instr_F          )
);

id id0
(
    .i_clk              (i_clk              ),
    .i_rst_n            (i_rstn             ),
    .i_instr_F          (w_instr_F          ),
    .i_pc_F             (w_pc_F             ),
    .i_pc_plus4_F       (w_pc_plus4_F       ),
    .i_result_WB        (w_result_WB        ),      
    .i_addr_des_WB      (w_addr_des_WB      ),           
    .i_reg_write_WB     (w_reg_write_WB     ),    

    .o_reg_write_ID     (w_reg_write_ID     ),
    .o_pc_ID            (w_pc_ID            ),
    .o_pc_plus4_ID      (w_pc_plus4_ID      ),
    .o_dataA_ID         (w_dataA_ID         ),
    .o_dataB_ID         (w_dataB_ID         ),
    .o_imm_ext_ID       (w_imm_ext_ID       ),
    .o_addr_des_ID      (w_addr_des_ID      ),
    .o_alu_src_ID       (w_alu_src_ID       ),
    .o_branch_ID        (w_branch_ID        ),
    .o_jump_ID          (w_jump_ID          ),
    .o_mem_write_ID     (w_mem_write_ID     ),
    .o_result_src_ID    (w_result_src_ID    ),
    .o_alu_control_ID   (w_alu_control_ID   )
);

ex ex0
(
    .i_clk              (i_clk              ),
    .i_rst_n            (i_rstn             ),
    .i_reg_write_ID     (w_reg_write_ID     ),
    .i_alu_src_ID       (w_alu_src_ID       ),
    .i_branch_ID        (w_branch_ID        ),
    .i_jump_ID          (w_jump_ID          ),
    .i_mem_write_ID     (w_mem_write_ID     ),
    .i_dataA_ID         (w_dataA_ID         ),
    .i_dataB_ID         (w_dataB_ID         ),
    .i_imm_ext_ID       (w_imm_ext_ID       ),
    .i_addr_des_ID      (w_addr_des_ID      ),
    .i_pc_plus4_ID      (w_pc_plus4_ID      ),
    .i_alu_control_ID   (w_alu_control_ID   ),

    .o_reg_write_EX     (w_reg_write_EX     ),
    .o_mem_write_EX     (w_mem_write_EX     ),
    .o_result_src_EX    (w_result_src_EX    ),
    .o_alu_result_EX    (w_alu_result_EX    ),
    .o_dataB_EX         (w_dataB_EX         ),
    .o_addr_des_EX      (w_addr_des_EX      ),
    .o_pc_plus4_EX      (w_pc_plus4_EX      ),
    .o_pc_target_EX     (w_pc_target_EX      ),
    .o_pc_src_EX        (w_pc_src_EX        )
);

mem mem0
(
    .i_clk              (i_clk              ),
    .i_rst_n            (i_rstn             ),
    .i_reg_write_EX     (w_reg_write_EX     ),
    .i_mem_write_EX     (w_mem_write_EX     ),
    .i_alu_result_EX    (w_alu_result_EX    ),
    .i_datatB_EX        (w_dataB_EX         ),
    .i_result_src_EX    (w_result_src_EX    ),
    .i_addr_des_EX      (w_addr_des_EX      ),
    .i_pc_plus4_EX      (w_pc_plus4_EX      ),

    .o_alu_result_MEM   (w_alu_result_MEM   ),
    .o_data_MEM         (w_data_MEM         ),
    .o_addr_des_MEM     (w_addr_des_MEM     ),
    .o_pc_plus4_MEM     (w_pc_plus4_MEM     ),
    .o_reg_write_MEM    (w_reg_write_MEM    ),
    .o_result_src_MEM   (w_result_src_MEM   )
);

wb wb0
(
    .i_clk              (i_clk              ),
    .i_rst_n            (i_rstn             ),
    .i_reg_write_MEM    (w_reg_write_MEM     ),
    .i_result_src_MEM   (w_result_src_MEM   ),
    .i_alu_result_MEM   (w_alu_result_MEM   ),
    .i_data_MEM         (w_data_MEM         ),
    .i_addr_des_MEM     (w_addr_des_MEM     ),
    .i_pc_plus4_MEM     (w_pc_plus4_MEM     ),

    .o_result_WB        (w_result_WB        ),
    .o_addr_des_WB      (w_addr_des_WB      ),
    .o_reg_write_WB     (w_reg_write_WB     )
);
endmodule