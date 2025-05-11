module alu
(
    input [31:0] i_srcA, i_srcB,
    input [2:0] i_alu_control,

    output logic [31:0] o_ALU,
    output logic o_zero
);

always_comb begin
    case (i_alu_control)
        3'b000: o_ALU = i_srcA + i_srcB;    // ADD
        3'b001: o_ALU = i_srcA - i_srcB;    // SUBTRACT
        3'b010: o_ALU = i_srcA & i_srcB;    // AND
        3'b011: o_ALU = i_srcA | i_srcB;    // OR
        3'b101: o_ALU = (i_srcA < i_srcB) ? 32'd1 : 32'd0; // SLT
        default: o_ALU = 32'd0;
    endcase
    o_zero = (o_ALU == 32'd0) ? 1'b1 : 1'b0; // Zero flag
end
endmodule