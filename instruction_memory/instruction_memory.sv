module instruction_memory
(
    input logic clk, rst_n,
    input logic [31:0] pc,
    output logic [31:0] instruction
);
    // Memory array
    logic [31:0] instruction_memory [0:255];

    
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            instruction <= 32'b0; 
        end else begin
            instruction <= instruction_memory[pc[31:0]]; 
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