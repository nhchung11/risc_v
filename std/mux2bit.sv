module mux1bit (
    input  logic [31:0] a,      // Input 1
    input  logic [31:0] b,      // Input 2
    input  logic [31:0] c,      // Input 3
    input  logic [31:0] d,      // Input 4
    input  logic [1:0] sel,     // 2-bit Select signal
    output logic [31:0] y       // Output
);

    // Multiplexer logic
    always_comb begin
        case (sel)
            2'b00: y = a; // Select input a
            2'b01: y = b; // Select input b
            2'b10: y = c; // Select input c
            2'b11: y = d; // Select input d
            default: y = 32'b0; // Default case (optional)
        endcase
    end

endmodule