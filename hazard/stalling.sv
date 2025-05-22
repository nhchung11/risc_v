module stalling 
(
    input logic [19:15]     i_adr_srcA_ID,
    input logic [24:20]     i_adr_srcB_ID,
    input logic [11:7]      i_addr_des_EX,
    input logic             i_result_src_EX,

    output logic            o_stall_F,
    output logic            o_stall_ID,
    output logic            o_flush_EX 
);

always_comb begin
    // Check for hazards
    if (i_result_src_EX && (i_addr_des_EX == i_adr_srcA_ID || i_addr_des_EX == i_adr_srcB_ID)) begin
        o_stall_F   = 1'b1; 
        o_stall_ID  = 1'b1; 
        o_flush_EX  = 1'b1; 
    end
end
endmodule