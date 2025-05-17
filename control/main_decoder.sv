module main_decoder
(
    input  logic [6:0]  i_opcode,

    output logic [1:0]  o_alu_op,
    output logic        o_alu_src,
    output logic        o_mem_write,
    output logic        o_reg_write,
    output logic [1:0]  o_result_src, 
    output logic [1:0]  o_imm_src,   
    output logic        o_branch,
    output logic        o_jump
);

always_comb begin 
    case (i_opcode)
        7'b0000011: begin // I-type (LW)
            o_reg_write     = 1'b1;
            o_imm_src       = 2'b00;  
            o_alu_src       = 1'b1;   
            o_mem_write     = 1'b0;  
            o_result_src    = 2'b01;  
            o_branch        = 1'b0;   
            o_alu_op        = 2'b00; 
            o_jump          = 1'b0;
        end

        7'b0100011: begin // S-type (SW)
            o_reg_write     = 1'b0;
            o_imm_src       = 2'b01;  
            o_alu_src       = 1'b1;   
            o_mem_write     = 1'b1;  
            // o_result_src    = 2'bxx;  
            o_branch        = 1'b0;   
            o_alu_op        = 2'b00; 
            o_jump          = 1'b0;
        end

        7'b0110011: begin // R-type
            o_reg_write     = 1'b1;
            // o_imm_src       = 2'bxx;  
            o_alu_src       = 1'b0;   
            o_mem_write     = 1'b0;  
            o_result_src    = 2'b00;  
            o_branch        = 1'b0;   
            o_alu_op        = 2'b10; 
            o_jump          = 1'b0;
        end

        7'b1100011: begin // B-type (BEQ)
            o_reg_write     = 1'b0;
            o_imm_src       = 2'b10;  
            o_alu_src       = 1'b0;   
            o_mem_write     = 1'b0;  
            // o_result_src    = 2'bxx;  
            o_branch        = 1'b1;   
            o_alu_op        = 2'b01; 
            o_jump          = 1'b0;
        end

        7'b0010011: begin // I-type 
            o_reg_write     = 1'b1;
            o_imm_src       = 2'b00;  
            o_alu_src       = 1'b1;   
            o_mem_write     = 1'b0;  
            o_result_src    = 2'b00;  
            o_branch        = 1'b0;   
            o_alu_op        = 2'b10; 
            o_jump          = 1'b0;
        end

        7'b1101111: begin // J-type (JAL)
            o_reg_write     = 1'b1;
            o_imm_src       = 2'b11;  
            // o_alu_src       = 1'bx;   
            o_mem_write     = 1'b0;   
            o_result_src    = 2'b10;  
            o_branch        = 1'b0;   
            // o_alu_op        = 2'bxx; 
            o_jump          = 1'b1;
        end
        default: begin
            o_reg_write     = 1'b0;
            o_imm_src       = 2'b00;  
            o_alu_src       = 1'b0;   
            o_mem_write     = 1'b0;   
            o_result_src    = 2'b00;  
            o_branch        = 1'b0;   
            o_alu_op        = 2'b00; 
            o_jump          = 1'b0;
        end
    endcase
end
endmodule