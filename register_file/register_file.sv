module register_file
(
    input i_clk, i_rst_n, i_reg_write,
    input [31:0] i_data,
    input [4:0] i_addr_srcA, i_addr_srcB, i_addr_des,

    output logic [31:0] o_dataA, o_dataB  
);
reg [31:0] registers [31:0];
integer i;

always @(posedge i_clk or negedge i_rst_n) begin
    if (!i_rst_n) begin
        for (i = 0; i < 32; i = i + 1) begin
            registers[i] <= 32'b0;
      end
    end else begin
        if (i_reg_write) begin
            registers[i_addr_des] <= i_data;
        end
    end
end

assign o_dataA = registers[i_addr_srcA];
assign o_dataB = registers[i_addr_srcB];

endmodule