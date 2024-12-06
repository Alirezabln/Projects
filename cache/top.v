module top (input clk, reset,output [31:0] writedata, dataadr, misses, totalInstr, output memwrite);
wire [31:0] pc, instr, readdata;
// instantiate processor and memories
mips mips (clk, reset, pc, instr, memwrite, dataadr,
writedata, readdata);
cache cache (pc[7:2], clk, reset, instr, misses, totalInstr );
dmem dmem (clk, memwrite, dataadr, writedata,readdata);
endmodule