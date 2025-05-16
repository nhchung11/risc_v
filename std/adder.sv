module adder #(parameter ADDER_WIDTH = 32) (
    input logic [ADDER_WIDTH-1:0] a,
    input logic [ADDER_WIDTH-1:0] b,
    output logic [ADDER_WIDTH:0] sum
);

always_comb begin
    sum = a + b;
end

endmodule