module instruction_memory
(
    input logic             i_clk, i_rst_n,
    input logic [31:0]      i_pc,
    output logic [31:0]     o_instr
);
    // Memory array
    logic [31:0] instruction_memory [0:1023];

    
    always_ff @(posedge i_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            o_instr <= 32'b0; 
        end else begin
            o_instr <= instruction_memory[i_pc[9:2]]; 
        end
    end     

    initial begin
        $readmemh("E:/RTL/risc_v/instruction_memory/program.hex", instruction_memory);
    end

    initial begin
        int i;
        for (i = 0; i < 10; i++) begin
            $display("instr_mem[%0d] = %h", i, instruction_memory[i]);
    end
end
endmodule