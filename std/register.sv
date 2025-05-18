module register #(
    parameter WIDTH = 32 
) (
    input  logic              clk,  
    input  logic              rstn, 
    input  logic              en,   
    input  logic [WIDTH-1:0]  d,    
    output logic [WIDTH-1:0]  q     
);

    always_ff @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            q <= {WIDTH{1'b0}}; 
        end else if (en) begin
            q <= d;             
        end
    end

endmodule