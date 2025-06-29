module btb
#(
    parameter WIDTH     = 32,
    parameter ENTRY_NUM = 32, 
    parameter INDEX     = $clog2(ENTRY_NUM),
    parameter TAG       = ENTRY_NUM - INDEX - 2
)(
    input logic                 i_clk           ,
    input logic                 i_rst_n         ,
    input logic                 i_taken         ,
    input logic [WIDTH-1:0]     i_pc_target     ,
    input logic                 i_branch        ,
    input logic                 i_jump          ,
    input logic [WIDTH-1:0]     i_pipelined_pc  ,
    
    output logic [WIDTH-1:0]    o_pc
);

    // Wires
    logic               w_hit;
    logic [WIDTH-1:0]   w_target_sel;
    logic [INDEX-1:0]   w_pc_index;
    logic [TAG-1:0]     w_pc_tag;
    logic [WIDTH-1:0]   w_pc_target;
    logic [WIDTH-1:0]   w_pc;

    // BTB signals
    logic [1:0]         w_btb_pred;
    logic [TAG-1:0]     w_btb_tag;
    logic               w_btb_valid;
    logic [WIDTH-1:0]   w_btb_target;

    // Adder
    logic [WIDTH-1:0]   w_pc_plus4;

    // Save PC + 4
    logic [WIDTH-1:0]   reg_plus4;
    logic               hold_branch;
    logic [1:0]         reg_branch_delay;
    logic [WIDTH-1:0]   hold_current_pc;

    always @(posedge i_clk or negedge i_rst_n) begin
        #0.5;
        if (!i_rst_n) begin
            reg_plus4 <= '0;
        end else if (i_branch) begin
            reg_plus4 <= o_pc - 4;
        end
    end

    always @(posedge i_clk or negedge i_rst_n) begin
        #0.5;
        if (!i_rst_n) begin
            reg_branch_delay <= 2'b00;
        end else begin
            if (i_branch) begin
                reg_branch_delay <= 2'b11;
            end else begin
                reg_branch_delay <= {reg_branch_delay[0], 1'b0};
            end
        end
    end
    assign #0.1 hold_branch = ^reg_branch_delay;
    

    // BTB entry structure
    typedef struct packed {
        logic [TAG-1:0]     tag;        
        logic               valid;                  
        logic [WIDTH-1:0]   target;    
        logic [1:0]         pred; 
    } btb_entry_t;

    btb_entry_t btb_array[ENTRY_NUM];

    // Combinational logic
    assign      w_pc_tag         = i_pc_target[WIDTH - 1:INDEX + 2];
    assign      w_pc_index       = i_pc_target[INDEX + 1:2];
    assign #0.1 w_hit            = (w_btb_tag == w_pc_tag) && w_btb_valid;
    assign #0.1 w_target_sel     = w_hit & w_btb_pred[1]; 

    assign      w_btb_target     = btb_array[w_pc_index].target;
    assign      w_btb_pred       = btb_array[w_pc_index].pred;
    assign      w_btb_tag        = btb_array[w_pc_index].tag;
    assign      w_btb_valid      = btb_array[w_pc_index].valid;
    


    // Update BTB
    always @(posedge i_clk or negedge i_rst_n) begin
        #0.5;
        if (!i_rst_n) begin
            for (int i = 0; i < ENTRY_NUM; i++) begin
                btb_array[i].valid      <= 1'b0;
                btb_array[i].tag        <= '0;
                btb_array[i].target     <= '0;
            end
        end else if (i_taken) begin
            btb_array[i_pipelined_pc[INDEX + 1:2]].tag      <= i_pipelined_pc[w_pc_tag];
            btb_array[i_pipelined_pc[INDEX + 1:2]].target   <= hold_current_pc;
            btb_array[i_pipelined_pc[INDEX + 1:2]].valid    <= 1'b1;
        end
    end

    // Update BTB prediction
    always @(posedge i_clk or negedge i_rst_n) begin
        #0.5;
        if (!i_rst_n) begin
            for (int i = 0; i < ENTRY_NUM; i++) begin
                btb_array[i].pred <= 2'b00; 
            end
        end else if (i_taken) begin
            btb_array[i_pipelined_pc[INDEX + 1:2]].pred <= 2'b10;
        end
    end

    // PC register
    always @(posedge i_clk or negedge i_rst_n) begin
        #0.5;
        if (!i_rst_n) begin
            o_pc <= '0;
            hold_current_pc <= '0;
        end else begin
            hold_current_pc <= o_pc;
            if (hold_branch && ~i_taken) begin
                o_pc <= reg_plus4;
            end else begin
                o_pc <= w_pc;
            end
        end
    end

    assign #0.2 w_pc_plus4 = o_pc + 4;


    // MUX0 - select target PC based on taken or not
    always @(*) begin
        #0.5;
        if (w_target_sel) begin
            w_pc_target = w_btb_target;
        end else begin
            w_pc_target = i_pc_target;
        end
    end

    // MUX1 - select PC for next cycle
    always @(*) begin
        #0.5;
        if (i_jump || i_branch) begin
            w_pc = w_pc_target;
        end else begin
            w_pc = w_pc_plus4;
        end
    end
endmodule
