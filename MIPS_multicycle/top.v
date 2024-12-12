module top(	input clk, reset,
			output [31:0] writedata, adr,
			output memwrite);
	wire [31:0] readdata;
	// instantiate processor and memories
	mips mips(clk, reset,readdata, adr, writedata, memwrite);
	mem mem(clk, reset, memwrite, adr, writedata, readdata);
endmodule
