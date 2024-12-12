module mips (input clk, reset,
output [31:0] pc,
input [31:0] instr,
output memwrite,
output [31:0] aluout, writedata,
input [31:0] readdata);
// new jal wire
wire jal;
// new jr wire
wire jr;
wire memtoreg, branch, alusrc, regdst, regwrite, jump;
wire [2:0] alucontrol;
controller c(instr[31:26], instr[5:0], zero,memtoreg, memwrite, pcsrc,
alusrc, regdst, regwrite, jump, jal, jr, alucontrol);
datapath dp(clk, reset, memtoreg, pcsrc,
alusrc, regdst, regwrite, jump, jal, jr,
alucontrol,
zero, pc, instr,
aluout, writedata, readdata);
endmodule