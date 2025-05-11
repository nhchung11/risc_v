module extend_imm 
(
    input [31:7] i_instr,
    input [1:0] i_immsrc,
    output logic [31:0] o_imm
);
    
    always_comb begin
        case (i_immsrc)
            2'b00: o_imm = {{20{i_instr[31]}}, i_instr[31:20]};                 // I-type
            2'b01: o_imm = {{20{i_instr[31]}}, i_instr[31:25], i_instr[11:7]};  // S-type
            2'b10: o_imm = {{19{i_instr[31]}}, i_instr[31], i_instr[7], 
                            i_instr[30:25], i_instr[11:8], 1'b0};               // B-type
            2'b11: o_imm = {{12{i_instr[31]}}, i_instr[19:12],
                            i_instr[20], i_instr[30:21], 1'b0};                 // J-type
            default: o_imm = 32'b0;                  // Default case
        endcase
    end
endmodule