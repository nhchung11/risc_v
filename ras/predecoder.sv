module predecoder
(
    input logic [6:0]   i_opcode    ,
    output logic        o_push      ,
    output logic        o_pop       
);
always_comb begin
    case(i_opcode)
        7'b1100111: begin   // JALR instruction
            o_push   = 1'b0; 
            o_pop    = 1'b1; 
        end

        7'b1101111: begin   // JAL instruction
            o_push   = 1'b1; 
            o_pop    = 1'b0; 
        end

        default: begin
            o_push   = 1'b0; 
            o_pop    = 1'b0; 
        end
    endcase
end
endmodule