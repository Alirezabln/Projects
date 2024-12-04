module mux4 #(parameter WIDTH=8)(
    input [WIDTH-1:0] d0, d1, d2, d3,
    input [1:0] select,
    output [WIDTH-1:0] result
);

assign result = (select == 2'b00) ? d0 :
                (select == 2'b01) ? d1 :
                (select == 2'b10) ? d2 :
                (select == 2'b11) ? d3 : {WIDTH{1'b0}};

endmodule
