module instruction_cache_controller
(
    // CPU interface
    input logic         i_clk               ,
    input logic         i_rst_n             ,
    input logic [31:0]  i_pc                ,
    input logic         i_pc_valid          ,
    output logic [31:0] o_instruction       ,
    output logic        o_instruction_valid ,
    output logic        o_hit               ,
    output logic        o_ready             ,
    // Memory interface
    input logic [127:0] i_mem_data_in       ,
    input logic         i_mem_data_valid    ,
    output logic        o_mem_read_en         
);

// Parameters
parameter NUM_SETS      = 32;    
parameter NUM_WAYS      = 2;     
parameter BLOCK_SIZE    = 16;  
parameter TAG_WIDTH     = 4;    
parameter SET_WIDTH     = 5;    
parameter OFFSET_WIDTH  = 3; 

// Cache line structure - 1kB
typedef struct packed{
    logic valid;                 
    logic [TAG_WIDTH-1:0] tag;   
    logic [0:3][31:0] data;     
} cache_line_t;
cache_line_t cache [0:NUM_SETS-1][0:NUM_WAYS-1]; 

// Instruction cache controller FSM - Read only
typedef enum logic [1:0] {
    IDLE,
    COMPARE_TAG,
    UPDATE
} state_t;
state_t current_state, next_state;


logic [TAG_WIDTH-1:0]       tag;
logic [SET_WIDTH-1:0]       set;
logic [OFFSET_WIDTH-1:0]    offset;
logic [TAG_WIDTH-1:0]       saved_tag;
logic [SET_WIDTH-1:0]       saved_set;
logic [OFFSET_WIDTH-1:0]    saved_offset;
logic [1:0]                 hitway;
logic                       cache_hit;          // 0: Miss , 1: Hit
logic                       lru [0:NUM_SETS-1]; // 0: Way 1, 1: Way 0
logic                       replace_way;        // 0: Way 0, 1: Way 1 

assign tag          = i_pc[11:8];
assign set          = i_pc[7:3];
assign offset       = i_pc[2:0];

assign hitway[0]    = (cache[set][0].valid && (cache[set][0].tag == tag)) ? 1'b1 : 1'b0;
assign hitway[1]    = (cache[set][1].valid && (cache[set][1].tag == tag)) ? 1'b1 : 1'b0;
assign cache_hit    = hitway[0] || hitway[1];
assign replace_way  = ~lru[set]; 
assign #1 o_mem_read_en = ~cache_hit && (current_state == COMPARE_TAG); 

// LRU replacement policy
always_ff @(posedge i_clk or i_rst_n) begin
    if (~i_rst_n) begin
        for (int i = 0; i < NUM_SETS; i++) begin
            lru[i] <= 1'b0; 
        end
    end else begin
        if (i_pc_valid) begin
            if (cache_hit) begin
                lru[set] <= hitway[0] ? 1'b1 : 1'b0; 
            end else begin
                lru[set] <= ~replace_way; 
            end
        end
    end
end

// Save tag, set, and offset 
always_ff @(posedge i_clk or negedge i_rst_n) begin
    if (!i_rst_n) begin
        saved_tag    <= 0;
        saved_set    <= 0;
        saved_offset <= 0;
    end else if (~cache_hit && current_state == COMPARE_TAG) begin
        saved_tag    <= tag;
        saved_set    <= set;
        saved_offset <= offset;
    end
end

// Update cache line 
always_ff @(posedge i_clk or negedge i_rst_n) begin
    if (!i_rst_n) begin
        for (int i = 0; i < NUM_SETS; i++) begin
            for (int j = 0; j < NUM_WAYS; j++) begin
                cache[i][j].valid <= 1'b1;
                cache[i][j].tag   <= 0;
                for (int k = 0; k < 4; k++) begin
                    cache[i][j].data[k] <= 32'b0;
                end
            end
        end
    end else begin
        if (i_mem_data_valid && current_state == UPDATE) begin
            cache[saved_set][replace_way].valid <= 1'b0;
            cache[saved_set][replace_way].tag   <= saved_tag;
            for (int i = 0; i < 4; i++) begin
                cache[saved_set][replace_way].data[i] <= i_mem_data_in[(i * 32) +: 32];
            end
        end
    end
end

always_ff @(posedge i_clk or negedge i_rst_n) begin
    if (!i_rst_n) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

// Next state logic
always_comb begin
    case (current_state)
        IDLE: begin
            if (i_pc_valid) begin
                next_state = COMPARE_TAG;
            end else begin
                next_state = IDLE;
            end
        end

        COMPARE_TAG: begin
            if (cache_hit) begin
                next_state = IDLE; 
            end else begin
                next_state = UPDATE;
            end
        end

        UPDATE: begin
            if (i_mem_data_valid) begin
                next_state = COMPARE_TAG; 
            end else begin
                next_state = UPDATE; 
            end
        end
    endcase
end

// Output logic
always_ff @(posedge i_clk or negedge i_rst_n) begin
    if (~i_rst_n) begin
        o_instruction       <= 32'b0;
        o_hit               <= 1'b0;
        o_ready             <= 1'b0;
        o_instruction_valid <= 1'b0;
    end else begin
        case (current_state) 
            IDLE: begin
                    o_instruction       <= 32'b0;
                    o_hit               <= 1'b0;
                    o_ready             <= 1'b1;
                    o_instruction_valid <= 1'b0;
            end

            COMPARE_TAG: begin
                if (cache_hit) begin
                    o_instruction       <= cache[set][hitway[0] ? 0 : 1].data[offset];
                    o_hit               <= 1'b1;
                    o_ready             <= 1'b1; 
                    o_instruction_valid <= 1'b0;
                end else begin
                    o_instruction       <= 32'b0;
                    o_hit               <= 1'b0;
                    o_ready             <= 1'b0; 
                    o_instruction_valid <= 1'b0;
                end
            end

            UPDATE: begin
                    o_instruction       <= 32'b0;
                    o_hit               <= 1'b0;
                    o_ready             <= 1'b1; 
                    o_instruction_valid <= 1'b1;
            end
            default: begin
                    o_instruction       <= 32'b0;
                    o_hit               <= 1'b0;
                    o_ready             <= 1'b1; 
                    o_instruction_valid <= 1'b0;
            end
        endcase
    end
end

endmodule
