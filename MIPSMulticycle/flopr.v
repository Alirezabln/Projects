module flopr #(parameter WIDTH=8) (
    input clk,
    input reset,
    input enable,
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);

always @(posedge clk, posedge reset)
    if (reset)
        q <= 0;
    else begin
        if (enable)
            q <= d;
    end
endmodule
