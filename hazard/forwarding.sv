module forwarding
(
    input logic [31:0]  i_addr_des_MEM,
    input logic [31:0]  i_addr_des_WB,
    input logic [31:0]  i_addrA_EX,
    input logic [31:0]  i_addrB_EX,
    input logic         i_reg_write_MEM,
    input               i_reg_write_WB,

    output logic [1:0]  o_forwardA,
    output logic [1:0]  o_forwardB
);

// ForwardA
always_comb begin   
    if (i_reg_write_MEM && (i_addrA_EX == i_addr_des_MEM) && (i_addrA_EX != 0)) begin
        // Forward from MEM stage
        o_forwardA = 2'b10; 
    end else if (i_reg_write_WB && (i_addrA_EX == i_addr_des_WB) && (i_addrA_EX != 0)) begin
        // Forward from WB stage
        o_forwardA = 2'b01; 
    end else begin
        // No forwarding
        o_forwardA = 2'b00;
        o_forwardA = 2'b00; 
    end
end

// ForwardB
always_comb begin   
    if (i_reg_write_MEM && (i_addrB_EX == i_addr_des_MEM) && (i_addrB_EX != 0)) begin
        // Forward from MEM stage
        o_forwardB = 2'b10; 
    end else if (i_reg_write_WB && (i_addrB_EX == i_addr_des_WB) && (i_addrB_EX != 0)) begin
        // Forward from WB stage
        o_forwardB = 2'b01; 
    end else begin
        // No forwarding
        o_forwardB = 2'b00;
        o_forwardB = 2'b00; 
    end
end
endmodule