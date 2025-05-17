module data_memory
(
    input logic         i_clk, i_rstn,
    input logic         i_mem_write, 
    input logic [10:0]  i_addr, 
    input logic [31:0]  i_data,
    output logic [31:0] o_data 
);

    // Memory array
    logic [31:0] mem [0:1027];

    // Read operation 
    always_comb begin
        o_data = mem[i_addr];
    end

    // Write operation 
    always_ff @(posedge i_clk or negedge i_rstn) begin
        if (!i_rstn) begin
            for (int i = 0; i < 1028; i++) begin
                mem[i] <= 32'd0;
            end
        end else if (i_mem_write) begin
            mem[i_addr] <= i_data;
        end
    end

endmodule