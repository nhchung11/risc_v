module register #(
    parameter WIDTH = 32 // Default width is 32 bits
) (
    input  logic              clk,  // Clock signal
    input  logic              rst,  // Reset signal (active high)
    input  logic              en,   // Enable signal
    input  logic [WIDTH-1:0]  d,    // Data input
    output logic [WIDTH-1:0]  q     // Data output
);

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            q <= {WIDTH{1'b0}}; // Reset the register to 0
        end else if (en) begin
            q <= d;             // Load the input data into the register
        end
    end

endmodule