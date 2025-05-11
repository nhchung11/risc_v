module register_file
(
    input clk, rst_n, wend,
    input [31:0] write_data,
    input [4:0] read_adr1, read_adr2, write_adr,

    output logic [31:0] read_data1, read_data2  
);
reg [31:0] registers [31:0];
integer i;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (i = 0; i < 32; i = i + 1) begin
            registers[i] <= 32'b0;
      end
    end else begin
        if (wend) begin
            registers[write_adr] <= write_data;
        end
    end
end

assign read_data1 = registers[read_adr1];
assign read_data2 = registers[read_adr2];

endmodule