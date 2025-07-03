module instruction_cache_controller
(
    // CPU interface
    input logic         i_clk           ,
    input logic         i_rst_n         ,
    input logic [31:0]  i_pc            ,
    input logic         i_pc_valid      ,
    output logic [31:0] o_instruction   ,
    output logic        o_hit           ,
    output logic        o_ready         ,
    // Memory interface
    input logic [127:0] i_mem_data_in   ,
    input logic         i_mem_data_valid,
    output logic        o_mem_read_en   ,  
);

// Parameters
parameter NUM_SETS      = 32;    
parameter NUM_WAYS      = 2;     
parameter BLOCK_SIZE    = 16;  
parameter TAG_WIDTH     = 4;    
parameter SET_WIDTH     = 5;    
parameter OFFSET_WIDTH  = 3; 

// Cache line structure
typedef struct packed {
    logic valid;                 
    logic [TAG_WIDTH-1:0] tag;   
    logic [31:0] data [0:3];     
} cache_line_t;

// 1kB cache 
cache_line_t cache [0:NUM_SETS-1][0:NUM_WAYS-1]; 

logic lru [0:NUM_SETS-1]; 
logic [TAG_WIDTH-1:0]      w_tag;
logic [SET_WIDTH-1:0]      w_set;
logic [OFFSET_WIDTH-1:0]   w_offset;
logic [1:0] w_hitway;
logic w_cache_hit;
logic w_cache_ready;

assign w_tag     = i_pc[11:8];
assign w_set     = i_pc[7:3];
assign w_offset  = i_pc[2:0];
// Instruction cache controller FSM - Read only
typedef enum logic [1:0] {
    IDLE,
    COMPARE_TAG,
    FETCH_LINE,
    UPDATE,
} state_t;

state_t current_state, next_state;
// Stage registers
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
        end

        FETCH_LINE: begin
        end

        UPDATE: begin
        end
    endcase
end

// Output logic
always_comb begin
    case (current_state) 
        IDLE: begin
            w_cache_ready = 1'b0;   
            w_cache_hit = 1'b0;
        end

        COMPARE_TAG: begin
        end

        FETCH_LINE: begin
        end

        UPDATE: begin
        end
    endcase
end
endmodule