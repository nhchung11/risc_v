module instruction_memory
(
    input logic i_clk, i_rst_n,
    input logic [31:0] i_pc,
    output logic [31:0] o_instr
);
    // Memory array
    logic [31:0] instruction_memory [0:255];

    
    always_ff @(posedge i_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            o_instr <= 32'b0; 
        end else begin
            o_instr <= instruction_memory[i_pc[31:0]]; 
        end
    end     
    // Initialize memory with some instructions
    initial begin
        instruction_memory[0] = 32'h00000000; // NOP
        instruction_memory[4] = 32'h00000013; // ADDI x0, x0, 0
        instruction_memory[8] = 32'h0000006F; // JAL x0, 0
        instruction_memory[12] = 32'h00000000; // NOP
        instruction_memory[16] = 32'h00000000; // NOP
        instruction_memory[20] = 32'h00000000; // NOP
        instruction_memory[24] = 32'h00000000; // NOP
        instruction_memory[28] = 32'h00000000; // NOP
    end
endmodule