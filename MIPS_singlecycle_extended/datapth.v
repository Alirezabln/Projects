module datapath (input clk, reset,
input memtoreg, pcsrc,
input alusrc, regdst,
input regwrite, jump,
// new input jal and jr
input jal,
input jr,
input [2:0] alucontrol,
output zero,
output [31:0] pc,
input [31:0] instr,
output [31:0] aluout, writedata,
input [31:0] readdata);

wire [4:0] writereg;
wire [4:0] wireafterjal;
wire [31:0] pcnext, pcnextbr, pcplus4, pcbranch;
wire [31:0] pcafterjr;
wire [31:0] signimm, signimmsh;
wire [31:0] srca, srcb;
wire [31:0] result;
wire [31:0] resultafterjal;
// next PC logic
flopr #(32) pcreg(clk, reset, pcnext, pc);
adder pcadd1 (pc, 32'b100, pcplus4);
sl2 immsh(signimm, signimmsh); 
adder pcadd2(pcplus4, signimmsh, pcbranch);
mux2 #(32) pcbrmux(pcplus4, pcbranch, pcsrc, pcnextbr);
// new mux for PC = RD1
mux2 #(32) pcmuxjr(pcnextbr, srca, jr, pcafterjr);
mux2 #(32) pcmux(pcafterjr, {pcplus4[31:28], instr[25:0], 2'b00},jump, pcnext);
// register file logic
regfile rf(clk, regwrite, instr[25:21],
instr[20:16], wireafterjal, resultafterjal, srca, writedata);
mux2 #(5) wrmux(instr[20:16], instr[15:11],regdst, writereg);
// new mux for selecting ra
mux2 #(5) ramuxadd(writereg, {5'b11111}, jal, wireafterjal);
mux2 #(32) resmux(aluout, readdata, memtoreg, result);
// new mux for writing PC+4 into ra $31 for jal instruction
mux2 #(32) ramuxw(result, pcplus4, jal, resultafterjal);
signext se(instr[15:0], signimm);
// ALU logic
mux2 #(32) srcbmux(writedata, signimm, alusrc, srcb);
alu alu(srca, srcb, alucontrol, aluout, zero);
endmodule