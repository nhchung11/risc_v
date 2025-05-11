module fsm
(
  input i_clk, i_rstn, i_zero,
  input [6:0] i_opcode,

  output logic o_RegWrite, o_MemWrite, o_IRWrite, o_AdSrc,
  output logic [1:0] o_ResultSrc, o_ALUSrcA, o_ALUSrcB,  
);
endmodule