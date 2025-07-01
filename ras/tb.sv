module tb;
    // Testbench signals
    logic         i_clk;
    logic         i_rst_n;
    logic [6:0]   i_opcode;
    logic [31:0]  o_ras_target;
    logic [31:0] w_pc_plus4;
    logic w_pop;
    // Instantiate the RAS module
    ras dut (
        .i_clk          (i_clk          ),
        .i_rst_n        (i_rst_n        ),
        .i_opcode       (i_opcode       ),
        .i_pc_plus4     (w_pc_plus4     ),
        .o_pop          (w_pop          ),
        .o_ras_target   (o_ras_target   )
    );

    logic [31:0] w_next_pc;
    logic [31:0] w_target;
    logic [31:0] reg_pc;
    logic [31:0] w_target_fromBTB = 0;
    logic sel1=0;

    task automatic write(input logic [6:0] opcode_val);
        begin
            @(posedge i_clk);
            #1;
            i_opcode <= opcode_val;
        end
    endtask

    task automatic reset();
        @(posedge i_clk);
        #2;
        i_rst_n = 1;
    endtask 
    
    initial begin
        i_clk = 0;
        forever #5 i_clk = ~i_clk; 
    end

    always_ff @(posedge i_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            reg_pc <= 32'h00000000;
        end else begin
            reg_pc <= w_next_pc;
        end
    end

    assign #1 w_pc_plus4 = reg_pc + 32'h00000004;
    always_comb begin
        if (sel1) begin
            w_target = w_target_fromBTB;
        end else begin
            w_target = w_pc_plus4;
        end
    end
    always_comb begin
        if (w_pop) begin
            w_next_pc = o_ras_target;
        end else begin
            w_next_pc = w_target; // Default value when not popping
        end
    end


    initial begin
        i_rst_n = 0;
        i_opcode = 7'b0000000;

        #10;
        reset();
        write(7'b0000000); // 1
        write(7'b0000000); // 2
        write(7'b0000000); // 3
        write(7'b0000000); // 4
        write(7'b1101111); // 5
        write(7'b1101111); 
        write(7'b1101111); 
        write(7'b1100111); 
        write(7'b1100111); 
        write(7'b1101111); 
        write(7'b1101111); 
        write(7'b0000000); 
        #200;
        $finish;
    end

    // Monitor outputs
    initial begin
        $monitor("Time: %0t | RAS Target: %h", $time, o_ras_target);
    end

endmodule