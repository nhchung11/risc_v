module mux2to1 (
    input  logic [31:0] a,      // Input 1
    input  logic [31:0] b,      // Input 2
    input  logic sel,           // Select signal
    output logic [31:0] y       // Output
);

    // Multiplexer logic
    assign y = sel ? b : a;

endmodule