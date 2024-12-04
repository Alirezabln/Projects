module mux3 #(parameter WIDTH=8)

			(input [WIDTH-1:0] d0,d1,d2,
			 input [1:0] select,
			 output [WIDTH-1:0] result);
assign result = select[1] ? d2 : (select[0] ? d1 : d0 );
			 
endmodule