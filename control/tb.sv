module tb;
  reg i_clk, i_rstn, i_zero;
  reg [6:0] i_opcode;
  wire o_RegWrite, o_MemWrite, o_IRWrite, o_AdSrc, o_PCUpdate, o_Branch;
  wire [1:0] o_ResultSrc, o_ALUSrcA, o_ALUSrcB, o_ALUOp;

  fsm dut (
    .i_clk(i_clk),
    .i_rstn(i_rstn),
    .i_zero(i_zero),
    .i_opcode(i_opcode),
    .o_RegWrite(o_RegWrite),
    .o_MemWrite(o_MemWrite),
    .o_IRWrite(o_IRWrite),
    .o_AdSrc(o_AdSrc),
    .o_PCUpdate(o_PCUpdate),
    .o_Branch(o_Branch),
    .o_ResultSrc(o_ResultSrc),
    .o_ALUSrcA(o_ALUSrcA),
    .o_ALUSrcB(o_ALUSrcB),
    .o_ALUOp(o_ALUOp)
  );

  initial begin
    // Initialize inputs
    i_clk = 0;
    i_rstn = 0;
    i_zero = 0;
    i_opcode = 0;

    // Wait for some time
    #10;

    // Release reset
    i_rstn = 1;

    // Apply test inputs
    i_opcode = 7'b0000011;
    #10;
    i_opcode = 7'b0100011;
    #10;
    i_opcode = 7'b1100011;
    #10;
    i_opcode = 7'b0110011;
    #10;
    i_opcode = 7'b0010011;
    #10;
    i_opcode = 7'b1101111;
    #10;
    i_opcode = 7'b1010;
    #10;
    i_opcode = 7'b0000011;
    #10;
    i_opcode = 7'b0100011;
    #10;

    // Finish simulation
    $finish;
  end

  always #5 i_clk = ~i_clk;

endmodule