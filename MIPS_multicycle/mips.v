module mips(input clk, reset, 
			input [31:0] readdata,
			output [31:0] adr, writedata,
			output memwrite);
	wire zero, pcen, irwrite, regwrite, alusrca, iord, memtoreg, regdst;
	wire [1:0] alusrcb, pcsrc;
	wire [2:0] alucontrol;
	wire [5:0] op, funct;
	controller c(clk, reset, op, funct, zero, iord, memwrite, irwrite, regdst, memtoreg,
			regwrite, alusrca, alusrcb, alucontrol, pcsrc, pcen);
	datapath dp(clk, reset, pcen, iord, irwrite, regdst, memtoreg, regwrite, alusrca,
			alusrcb, alucontrol, pcsrc, readdata, op, funct, zero, adr, writedata);
endmodule