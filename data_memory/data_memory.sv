module data_memory
(
    input logic i_clk, i_rstn,
    input logic i_MemWrite, // Write enable
    input logic [10:0] i_addr, // Address for read/write
    input logic [31:0] i_data, // Data to write
    output logic [31:0] o_data // Data read from memory
);

    // Memory array
    logic [31:0] mem [0:1027];

    // Read operation (combinational)
    always_comb begin
        o_data = mem[i_addr];
    end

    // Write operation (synchronous)
    always_ff @(posedge i_clk or negedge i_rstn) begin
        if (!i_rstn) begin
            for (int i = 0; i < 1028; i++) begin
                mem[i] <= 32'd0;
            end
        end else if (i_MemWrite) begin
            mem[i_addr] <= i_data;
        end
    end

endmodule