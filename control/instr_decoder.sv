module instr_decoder 
(
    input [6:0] i_opcode,
    output logic [1:0] o_immsrc,
);

    always_comb begin
        case (i_opcode)
            7'b0000011: o_immsrc = 2'b00; // I-type
            7'b0100011: o_immsrc = 2'b01; // S-type
            7'b1100011: o_immsrc = 2'b10; // B-type
            7'b0110011: o_immsrc = 2'b11; // R-type
            default: o_immsrc = 2'b11;     // Default case
        endcase
    end
endmodule
