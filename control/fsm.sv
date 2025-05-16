module fsm
(
  input i_clk, i_rstn, i_zero,
  input [6:0] i_opcode,

  output logic o_reg_write, o_mem_write, o_ir_write, o_adr_src, o_pc_update, o_branch,
  output logic [1:0] o_result_src, o_alu_srcA, o_alu_srcB, o_alu_op
);

typedef enum logic [3:0] {
  FETCH     = 4'b0000,
  DECODE    = 4'b0001,
  MEMADR    = 4'b0010,
  MEMREAD   = 4'b0011,
  MEMWB     = 4'b0100,
  MEMWRITE  = 4'b0101,
  EXECUTE_R = 4'b0110,
  ALUWB     = 4'b0111,
  EXECUTE_I = 4'b1000,
  JAL       = 4'b1001,
  BEQ       = 4'b1010
} state_t;

state_t current_state, next_state;

always_ff @(posedge i_clk or negedge i_rstn) begin
  if (!i_rstn)
    current_state <= FETCH;
  else
    current_state <= next_state;
end

always_comb begin
  case (current_state)
    FETCH: begin
      next_state = DECODE;
    end

    DECODE: begin
      case (i_opcode)
        7'b0000011: next_state = MEMADR;    // I-type
        7'b0100011: next_state = MEMADR;    // S-type
        7'b1100011: next_state = BEQ;       // B-type
        7'b0110011: next_state = EXECUTE_R; // R-type
        7'b0010011: next_state = EXECUTE_I; // I-type
        7'b1101111: next_state = JAL;       // J-type
        default:    next_state = FETCH;
      endcase
    end

    MEMADR: begin
      case (i_opcode)
        7'b0000011: next_state = MEMREAD;   // I-type
        7'b0100011: next_state = MEMWRITE;  // S-type
        default:    next_state = FETCH;
      endcase
    end

    MEMREAD: begin
      next_state = MEMWB; 
    end
    
    EXECUTE_R: begin
      next_state = ALUWB;
    end

    EXECUTE_I: begin
      next_state = ALUWB;
    end

    JAL: begin
      next_state = ALUWB;
    end

    BEQ: begin
        next_state = FETCH;
    end

    MEMREAD: begin
      next_state = MEMWB;
    end

    MEMWRITE: begin
      next_state = FETCH;
    end

    ALUWB: begin
      next_state = FETCH;
    end

    MEMWB: begin
      next_state = FETCH;
    end
  endcase
end

always_ff @(posedge i_clk or negedge i_rstn) begin
  if (!i_rstn) begin
    o_adr_src     <= 1'b0;
    o_ir_write    <= 1'b1;  
    o_reg_write   <= 1'b0;
    o_mem_write   <= 1'b0;
    o_result_src  <= 2'b10;
    o_alu_srcA    <= 2'b00;
    o_alu_srcB    <= 2'b00;
    o_alu_op      <= 2'b00;
    o_pc_update   <= 1'b0;
    o_branch      <= 1'b0;
  end
  else begin
    case (current_state)
      DECODE: begin
        o_alu_srcA    <= 2'b01;
        o_alu_srcB    <= 2'b01;
        o_alu_op      <= 2'b00;
        o_ir_write    <= 1'b0;
      end

      MEMADR: begin
        o_alu_srcA    <= 2'b10;
        o_alu_srcB    <= 2'b01;
        o_alu_op      <= 2'b00;
      end

      EXECUTE_R: begin
        o_alu_srcA    <= 2'b10;
        o_alu_srcB    <= 2'b00;
        o_alu_op      <= 2'b10;
        o_branch      <= 1'b0;
      end

      EXECUTE_I: begin
        o_alu_srcA    <= 2'b10;
        o_alu_srcB    <= 2'b01;
        o_alu_op      <= 2'b10;
      end

      JAL: begin
        o_alu_srcA    <= 2'b01;
        o_alu_srcB    <= 2'b10;
        o_alu_op      <= 2'b00;
        o_result_src  <= 2'b00;
        o_pc_update   <= 1'b1; 
      end

      BEQ: begin
        o_alu_srcA    <= 2'b10;
        o_alu_srcB    <= 2'b00;
        o_alu_op      <= 2'b01;
        o_result_src  <= 2'b00;
        o_branch      <= 1'b1;
      end

      MEMREAD: begin
        o_result_src  <= 2'b00;
        o_adr_src     <= 1'b1;
      end

      MEMWRITE: begin
        o_result_src  <= 2'b00;
        o_adr_src     <= 1'b1;  
        o_mem_write   <= 1'b1;
      end

      ALUWB: begin
        o_result_src  <= 2'b00;
        o_reg_write   <= 1'b1;
      end

      MEMWB: begin
        o_result_src  <= 2'b01;
        o_reg_write   <= 1'b1;
      end
    endcase
  end
end
endmodule

