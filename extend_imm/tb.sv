module tb;
    reg [31:7] i_instr;
    reg [1:0] i_imm_src;
    wire [31:0] o_imm;
    
    extend_imm dut (
        .i_instr    (i_instr),
        .i_imm_src   (i_imm_src),
        .o_imm      (o_imm)
    );
    
    initial begin
        // Test case 1: I-type
        i_instr = 32'h12345678;
        i_imm_src = 2'b00;
        #10;
        $display("o_imm = %h, imm_src = %b", o_imm, i_imm_src);
        
        // Test case 2: S-type
        i_instr = 32'h12345678;
        i_imm_src = 2'b01;
        #10;
        $display("o_imm = %h, imm_src = %b", o_imm, i_imm_src);
        
        // Test case 3: B-type
        i_instr = 32'h1122668;
        i_imm_src = 2'b10;
        #10;
        $display("o_imm = %h, imm_src = %b", o_imm, i_imm_src);
        
        // Test case 4: J-type
        i_instr = 32'h12244778;
        i_imm_src = 2'b11;
        #10;
        $display("o_imm = %h, imm_src = %b", o_imm, i_imm_src);
        
        // Test case 5: Default case
        i_instr = 32'h12345678;
        i_imm_src = 2'bxx;
        #10;
        $display("o_imm = %h, imm_src = %b", o_imm, i_imm_src);
        
        $finish;
    end
endmodule