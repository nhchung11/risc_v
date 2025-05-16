`timescale 1ns / 1ps

module tb;

    // Inputs
    reg [31:0] i_srcA;
    reg [31:0] i_srcB;
    reg [2:0] i_alu_control;

    // Outputs
    wire [31:0] o_alu;
    wire o_zero;

    // Instantiate the Unit Under Test (UUT)
    alu uut (
        .i_srcA(i_srcA),
        .i_srcB(i_srcB),
        .i_alu_control(i_alu_control),
        .o_alu(o_alu),
        .o_zero(o_zero)
    );

    initial begin
        // Initialize Inputs
        i_srcA = 0;
        i_srcB = 0;
        i_alu_control = 0;

        // Wait for global reset
        #10;

        // Test ADD operation
        i_srcA = 32'd10;
        i_srcB = 32'd20;
        i_alu_control = 3'b000; // ADD
        #10;

        // Test SUBTRACT operation
        i_srcA = 32'd30;
        i_srcB = 32'd15;
        i_alu_control = 3'b001; // SUBTRACT
        #10;

        // Test AND operation
        i_srcA = 32'hFF00FF00;
        i_srcB = 32'h00FF00FF;
        i_alu_control = 3'b010; // AND
        #10;

        // Test OR operation
        i_srcA = 32'hFF00FF00;
        i_srcB = 32'h00FF00FF;
        i_alu_control = 3'b011; // OR
        #10;

        // Test SLT operation
        i_srcA = 32'd10;
        i_srcB = 32'd20;
        i_alu_control = 3'b101; // SLT
        #10;

        // Test default case
        i_srcA = 32'd0;
        i_srcB = 32'd0;
        i_alu_control = 3'b111; // Undefined operation
        #10;

        // Finish simulation
        $stop;
    end

    initial begin
        // Monitor the signals only when o_alu changes
        forever @(o_alu) begin
            $display("Time = %0t | i_srcA = %d | i_srcB = %d | i_alu_control = %b | o_alu = %d | o_zero = %b",
                     $time, i_srcA, i_srcB, i_alu_control, o_alu, o_zero);
        end
    end

endmodule