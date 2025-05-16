module alu_decoder
(
    input [1:0] i_alu_op,
    input [2:0] i_funct3,
    input [6:0] i_funct7,

    output logic [2:0] o_alu_control
);
    always_comb begin
        case (i_alu_op)
            2'b00: o_alu_control = 3'b000; // ADD
            2'b01: o_alu_control = 3'b001; // SUBTRACT
            2'b10: begin
                case (i_funct3)
                    3'b000: o_alu_control = (i_funct7 == 7'b0000011) ? 3'b001 : 3'b000; // SUBTRACT or ADD
                    3'b111: o_alu_control = 3'b010; // AND
                    3'b110: o_alu_control = 3'b011; // OR
                    3'b010: o_alu_control = 3'b101; // SLT
                    default: o_alu_control = 3'b000; // Default case
                endcase
            end
            default: o_alu_control = 3'b000; // Default case
        endcase
    end
endmodule