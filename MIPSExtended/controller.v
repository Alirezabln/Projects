module controller (input [5:0] op, funct,
input zero,
output memtoreg, memwrite,
output pcsrc, alusrc,
output regdst, regwrite,
output jump,
// new jal and jr outputs
output jal,
output jr,
output [2:0] alucontrol);
wire [1:0] aluop;
wire branch;
maindec md(op, memtoreg, memwrite, branch,
alusrc, regdst, regwrite, jump, jal,
aluop);
aludec ad (funct, aluop, alucontrol);
assign pcsrc = branch & zero;
// assign jr
assign jr = ((~funct[0]) & (~funct[1]) & (~funct[2]) & (funct[3]) & (~funct[4]) & (~funct[5]));
endmodule