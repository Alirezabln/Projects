module datapath( 
			  input clk, reset, pcen,
			  input iord, irwrite, regdst,
			  input memtoreg, regwrite, alusrca,
		      input [1:0] alusrcb,
		      input [2:0] alucontrol,
		      input [1:0] pcsrc,
		      input [31:0] readdata,
		      output [5:0] op, funct,
              output zero,
		      output [31:0] adr,
		      output [31:0] writedata );
wire [31:0] pc,pcnext;
wire [31:0] address,aluout;
wire [31:0] instr,data;
wire [4:0] writereg;
wire [31:0] wd3,rd1,rd2;
wire [31:0] avalue;
wire [31:0] srca,srcb;
wire [31:0] signimm,shiftimm;
wire [31:0] aluresult,jumpadr;
assign op = instr[31:26];
assign funct = instr[5:0];
assign jumpadr = {pc[31:28],instr[25:0],2'b00};
flopr #(32) pcreg(clk,reset,pcen,pcnext,pc);
mux2 #(32)  memmux(pc,aluout,iord,adr);
flopr #(32) instrreg(clk,reset,irwrite,readdata,instr);
flopr #(32) datareg(clk,reset,1'b1,readdata,data);
mux2 #(5) a3mux(instr[20:16],instr[15:11],regdst,writereg);
mux2 #(32) wd3mux(aluout,data,memtoreg,wd3);
regfile rf(clk,regwrite,instr[25:21],instr[20:16],writereg,wd3,rd1,rd2);
flopr #(32) areg(clk,reset,1'b1,rd1,avalue);
flopr #(32) breg(clk,reset,1'b1,rd2,writedata);
mux2 #(32) srcamux(pc,avalue,alusrca,srca);
signext se(instr[15:0],signimm);
sl2 shift(signimm,shiftimm);
mux4 #(32) srcbmux(writedata,32'b100,signimm,shiftimm,alusrcb,srcb);
alu alu(srca,srcb,alucontrol,aluresult,zero);
flopr #(32) alureg(clk,reset,1'b1,aluresult,aluout);
mux3 #(32) pcmux(aluresult,aluout, jumpadr,pcsrc,pcnext);
endmodule