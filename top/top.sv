module top
(
    input i_clk, i_rstn
);

// Wires

// FETCH STAGE
mux2to1 mux_pc
(
    .a              (pc_plus4_FETCH             ),
    .b              (pc_target_EX               ),
    .sel            (pc_src_EX                  ),
    .y              (pc_FETCH                   )
);

register reg_pc
(
    .i_clk          (i_clk                      ),
    .i_rstn         (i_rstn                     ),
    .i_data         (pc_FETCH                   ),
    .o_data         (pc_plus4_FETCH             )
);
endmodule