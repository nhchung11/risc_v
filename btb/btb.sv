module btb
#(
    parameter WIDTH     = 32,
    parameter ENTRY_NUM = 32, 
    parameter INDEX     = $clog2(ENTRY_NUM),
    parameter TAG       = ENTRY_NUM - INDEX - 2
)(
    input logic                 i_clk,
    input logic                 i_rst_n,
    input logic                 i_jump_ID,
    input logic                 i_pc_src_EX,
    input logic                 i_btb_update_en_ID,
    input logic [WIDTH-1:0]     i_pc_F,
    input logic [WIDTH-1:0]     i_pc_target_ID,
    input logic [WIDTH-1:0]     i_pc_plus4_F,

    output                      o_flush_PC,
    output logic [WIDTH-1:0]    o_pc_F0
);

    // Wires
    logic               w_compare;
    logic               w_taken;
    logic [WIDTH-1:0]   w_pc_target_F;
    logic [INDEX-1:0]   w_index;
    logic [TAG-1:0]     w_tag;
    logic               w_pc_sel;

    logic [1:0]         w_btb_predicted;
    logic [TAG-1:0]     w_btb_tag;
    logic               w_btb_valid;
    logic [WIDTH-1:0]   w_btb_target;
    

    // BTB entry structure
    typedef struct packed {
        logic [TAG-1:0]     tag;        
        logic               valid;                  
        logic [WIDTH-1:0]   target;    
        logic [1:0]         predicted; 
    } btb_entry_t;

    btb_entry_t btb_array[ENTRY_NUM];

    // Combinational logic
    assign w_pc_sel         = i_jump_ID || i_pc_src_EX;
    assign o_flush_PC       = ~w_taken && i_jump_ID;
    assign w_tag            = i_pc_F[WIDTH - 1:INDEX + 2];
    assign w_index          = i_pc_F[INDEX + 1:2];
    assign w_btb_target     = btb_array[w_index].target;
    assign w_btb_predicted  = btb_array[w_index].predicted;
    assign w_btb_tag        = btb_array[w_index].tag;
    assign w_btb_valid      = btb_array[w_index].valid;
    assign w_taken          = w_compare && btb_array[w_index].predicted[1]; 
    assign w_compare        = (w_btb_tag == w_tag) && w_btb_valid;


    always_ff @(posedge i_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            for (int i = 0; i < ENTRY_NUM; i++) begin
                btb_array[i].valid      <= 1'b0;
            end
        end else if (i_btb_update_en_ID) begin
            btb_array[w_index].tag      <= i_pc_F[w_tag];
            btb_array[w_index].target   <= i_pc_target_ID;
            btb_array[w_index].valid    <= 1'b1;
        end
    end

    always_comb begin
        if (w_taken) begin
            w_pc_target_F = w_btb_target;
        end else begin
            w_pc_target_F = i_pc_target_ID  ;
        end
    end

    always_comb begin
        if (w_pc_sel) begin
            o_pc_F0 = w_pc_target_F;
        end else begin
            o_pc_F0 = i_pc_plus4_F;
        end
    end
endmodule
