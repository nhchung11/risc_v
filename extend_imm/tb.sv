module tb;
    reg [31:7] i_instr;
    reg [1:0] i_immsrc;
    wire [31:0] o_imm;
    
    extend_imm dut (
        .i_instr(i_instr),
        .i_immsrc(i_immsrc),
        .o_imm(o_imm)
    );
    
    initial begin
        // Test case 1: I-type
        i_instr = 32'h12345678;
        i_immsrc = 2'b00;
        #10;
        $display("o_imm = %h, imm_src = %b", o_imm, i_immsrc);
        
        // Test case 2: S-type
        i_instr = 32'h12345678;
        i_immsrc = 2'b01;
        #10;
        $display("o_imm = %h, imm_src = %b", o_imm, i_immsrc);
        
        // Test case 3: B-type
        i_instr = 32'h1122668;
        i_immsrc = 2'b10;
        #10;
        $display("o_imm = %h, imm_src = %b", o_imm, i_immsrc);
        
        // Test case 4: J-type
        i_instr = 32'h12244778;
        i_immsrc = 2'b11;
        #10;
        $display("o_imm = %h, imm_src = %b", o_imm, i_immsrc);
        
        // Test case 5: Default case
        i_instr = 32'h12345678;
        i_immsrc = 2'bxx;
        #10;
        $display("o_imm = %h, imm_src = %b", o_imm, i_immsrc);
        
        $finish;
    end
endmodule