module register_file
(
    input i_clk, i_rst_n, i_RegWrite,
    input [31:0] i_write_data,
    input [4:0] i_read_adr1, i_read_adr2, i_write_adr,

    output logic [31:0] o_read_data1, o_read_data2  
);
reg [31:0] registers [31:0];
integer i;

always @(posedge i_clk or negedge i_rst_n) begin
    if (!i_rst_n) begin
        for (i = 0; i < 32; i = i + 1) begin
            registers[i] <= 32'b0;
      end
    end else begin
        if (i_RegWrite) begin
            registers[i_write_adr] <= i_write_data;
        end
    end
end

assign o_read_data1 = registers[i_read_adr1];
assign o_read_data2 = registers[i_read_adr2];

endmodule