module ras
(
    input logic         i_clk       ,
    input logic         i_rst_n     ,
    input logic [6:0]   i_opcode    ,
    input logic [31:0]  i_pc_plus4  ,
    
    output logic        o_pop       ,
    output logic[31:0]  o_ras_target
);

    // RAS signals
    logic [31:0] ras_stack [0:31]; // 32 entries
    logic [4:0]  ras_top;          // Pointer 
    logic [31:0] hold_pc_plus4[0:1];


    predecoder predecoder_inst
    (
        .i_opcode   (i_opcode   ),
        .o_push     (o_push     ),
        .o_pop      (o_pop      )
    );

    always_ff @(posedge i_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            ras_top <= 0;
            for (int i = 0; i < 32; i++) begin
                ras_stack[i] <= '0; // Initialize RAS stack entries to zero
            end
        end else begin
            if (o_push) begin
                ras_stack[ras_top] <= hold_pc_plus4[1];
                ras_top <= ras_top + 1;
            end else if (o_pop && ras_top > 0) begin
                ras_top <= ras_top - 1;
            end
        end
    end

    always_comb begin
        if (ras_top > 0) begin
            o_ras_target = ras_stack[ras_top - 1]; // Return the top of the RAS stack
        end else begin
            o_ras_target = '0; // If stack is empty, return zero
        end
    end

    always_ff @(posedge i_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            hold_pc_plus4[0] <= '0;
            hold_pc_plus4[1] <= '0;
        end else begin
            hold_pc_plus4[0] <= i_pc_plus4; // Store current PC+4
            hold_pc_plus4[1] <= hold_pc_plus4[0]; // Store previous PC+4
        end
    end
endmodule
