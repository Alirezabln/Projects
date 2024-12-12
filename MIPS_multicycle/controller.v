module controller(input clk, reset,
				  input[5:0] op, funct,
				  input zero,
				  output iord, memwrite, irwrite, regdst,
				  output memtoreg, regwrite, alusrca,
				  output [1:0] alusrcb,
		          output [2:0] alucontrol,
				  output [1:0] pcsrc,
				  output pcen);
	
	wire [1:0] aluop;
	wire branch, pcwrite;
	maindec md(clk, reset,op, memtoreg, memwrite, pcsrc, pcwrite, regdst,
				regwrite, iord, irwrite, branch, alusrca, alusrcb, aluop);
	aludec ad(funct, aluop, alucontrol);
	assign pcen = (branch & zero) | pcwrite;
endmodule