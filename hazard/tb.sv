module tb;

    // Inputs
    reg [31:0] i_addr_des_MEM;
    reg [31:0] i_addr_des_WB;
    reg [31:0] i_addrA_EX;
    reg [31:0] i_addrB_EX;
    reg        i_reg_write_MEM;
    reg        i_reg_write_WB;

    // Outputs
    wire [1:0] o_forwardA;
    wire [1:0] o_forwardB;

    // Instantiate the DUT (Device Under Test)
    forwarding_unit dut (
        .i_addr_des_MEM(i_addr_des_MEM),
        .i_addr_des_WB(i_addr_des_WB),
        .i_addrA_EX(i_addrA_EX),
        .i_addrB_EX(i_addrB_EX),
        .i_reg_write_MEM(i_reg_write_MEM),
        .i_reg_write_WB(i_reg_write_WB),
        .o_forwardA(o_forwardA),
        .o_forwardB(o_forwardB)
    );

    // Function to check for errors
    task check_output;
        input [1:0] expected_forwardA;
        input [1:0] expected_forwardB;
        begin
            if (o_forwardA !== expected_forwardA || o_forwardB !== expected_forwardB) begin
                $display("ERROR: Mismatch detected at time %0t", $time);
                $display("Expected: o_forwardA = %b, o_forwardB = %b", expected_forwardA, expected_forwardB);
                $display("Actual:   o_forwardA = %b, o_forwardB = %b", o_forwardA, o_forwardB);
            end else begin
                $display("PASS: Outputs match at time %0t", $time);
            end
        end
    endtask

    // Testbench logic
    initial begin
        // Initialize inputs
        i_addr_des_MEM = 32'd0;
        i_addr_des_WB = 32'd0;
        i_addrA_EX = 32'd0;
        i_addrB_EX = 32'd0;
        i_reg_write_MEM = 1'b0;
        i_reg_write_WB = 1'b0;

        // Wait for global reset
        #10;

        // Test case 1: No forwarding
        i_addrA_EX = 32'd10;
        i_addrB_EX = 32'd20;
        i_addr_des_MEM = 32'd30;
        i_addr_des_WB = 32'd40;
        i_reg_write_MEM = 1'b0;
        i_reg_write_WB = 1'b0;
        #10;
        check_output(2'b00, 2'b00);

        // Test case 2: Forwarding to o_forwardA from MEM
        i_addrA_EX = 32'd50;
        i_addr_des_MEM = 32'd50;
        i_reg_write_MEM = 1'b1;
        i_reg_write_WB = 1'b0;
        #10;
        check_output(2'b10, 2'b00);

        // Test case 3: Forwarding to o_forwardA from WB
        i_addrA_EX = 32'd60;
        i_addr_des_WB = 32'd60;
        i_reg_write_MEM = 1'b0;
        i_reg_write_WB = 1'b1;
        #10;
        check_output(2'b01, 2'b00);

        // Test case 4: No forwarding when i_addrA_EX is 0
        i_addrA_EX = 32'd0;
        i_addr_des_MEM = 32'd50;
        i_addr_des_WB = 32'd60;
        i_reg_write_MEM = 1'b1;
        i_reg_write_WB = 1'b1;
        #10;
        check_output(2'b00, 2'b00);

        // Test case 5: Forwarding to o_forwardB from MEM
        i_addrB_EX = 32'd70;
        i_addr_des_MEM = 32'd70;
        i_reg_write_MEM = 1'b1;
        i_reg_write_WB = 1'b0;
        #10;
        check_output(2'b00, 2'b10);

        // Test case 6: Forwarding to o_forwardB from WB
        i_addrB_EX = 32'd80;
        i_addr_des_WB = 32'd80;
        i_reg_write_MEM = 1'b0;
        i_reg_write_WB = 1'b1;
        #10;
        check_output(2'b00, 2'b01);

        // End simulation
        $finish;
    end

endmodule