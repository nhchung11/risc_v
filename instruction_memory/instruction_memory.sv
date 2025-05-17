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
endmodule