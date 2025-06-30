module tb;

    // Parameters
    parameter WIDTH     = 32                ;
    parameter ENTRY_NUM = WIDTH             ; 

    // Signals
    logic i_clk                             ;
    logic i_rst_n                           ;
    logic i_taken                           ;
    logic i_branch                          ;
    logic i_jump                            ;
    logic [WIDTH-1:0] i_pc_target           ;
    logic [WIDTH-1:0] i_pipelined_pc        ; 
    logic             o_flush               ;
    logic [WIDTH-1:0] o_pc                  ;
    logic [WIDTH-1:0] w_hold_pipeline [0:3] ;
    

    // Instantiate the DUT
    btb #(
        .WIDTH          (WIDTH          ),
        .ENTRY_NUM      (ENTRY_NUM      )
    ) dut (
        .i_clk          (i_clk          ),
        .i_rst_n        (i_rst_n        ),
        .i_taken        (i_taken        ),
        .i_branch       (i_branch       ),
        .i_jump         (i_jump         ),
        .i_pc_target    (i_pc_target    ),
        .i_pipelined_pc (i_pipelined_pc ),
        .o_flush        (o_flush        ),
        .o_pc           (o_pc           )
    );

    logic [1:0] taken_pipeline = 0;
    // Write data task
    task automatic write(input logic [31:0] pc_target_val, input logic taken_val, input logic branch_val, input logic jump_val);
        begin
            @(posedge i_clk);
            #1;
            i_pc_target <= pc_target_val;
            i_branch <= branch_val;
            #0.1 taken_pipeline   <= {taken_pipeline[0], taken_val};  
            i_taken  <= taken_pipeline[1]; 
            i_branch <= branch_val;
            i_jump <= jump_val;
        end
    endtask

    always @(posedge i_clk or negedge i_rst_n) begin
        #1;
        if (!i_rst_n) begin
            for (int i = 0; i < 5; i++) begin
                w_hold_pipeline[i] <= '0;
            end
        end else begin
            w_hold_pipeline[0] <= o_pc;
            w_hold_pipeline[1] <= w_hold_pipeline[0];
            w_hold_pipeline[2] <= w_hold_pipeline[1];
            w_hold_pipeline[3] <= w_hold_pipeline[2];
        end
    end

    // Assign the pipelined PC
    assign i_pipelined_pc = w_hold_pipeline[3];
    // Clock generation
    initial begin
        i_clk = 0;
        forever #5 i_clk = ~i_clk; // 10 time units clock period
    end

    initial begin

    end

    // Test sequence
    initial begin
        // Initialize inputs
        i_rst_n = 0         ;
        i_taken = 0         ;
        i_pc_target = 0     ;
        i_branch = 0        ;
        i_jump = 0          ;
    
        // RESET
        #25;
        i_rst_n = 1;
        //write(target, taken, branch, jump)
        write(32'h00000000, 0, 0, 0); 
        write(32'h00000000, 0, 0, 0); 
        write(32'h00000020, 0, 0, 0); 
        write(32'h00000028, 0, 0, 0); 
        write(32'h0000002C, 1, 1, 0); 
        write(32'h00000020, 0, 0, 0); 
        write(32'h00000034, 0, 0, 0); 
        write(32'h00000038, 0, 1, 0); 
        write(32'h0000003C, 0, 0, 0); 
        write(32'h00000040, 0, 0, 0); 
        write(32'h00000044, 0, 0, 0); 
        write(32'h00000048, 0, 0, 0); 
        write(32'h0000000C, 1, 1, 0); 
        write(32'h00000040, 0, 0, 0); 
        write(32'h00000050, 0, 0, 0); 
        write(32'h00000060, 0, 0, 0); 
        write(32'h00000070, 0, 0, 0); 

        #100;
        @(posedge i_clk);
        i_rst_n = 0;
        #20;
        $finish;
    end
endmodule