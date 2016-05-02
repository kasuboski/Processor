module MEMWB(clk, rst,memData, ALUData, memToReg, regWrite, writereg, halt, memDataOut, ALUDataOut, memToRegOut,
	regWriteOut, writeregOut, haltOut, regDst, regDstOut, nextPC, nextPCOut);
	input [15:0] memData, ALUData, nextPC;
	input memToReg, regWrite, clk, rst, halt;
	input [2:0] writereg;
	input [1:0] regDst;		

	output [15:0] memDataOut, ALUDataOut, nextPCOut;
	output memToRegOut, regWriteOut, haltOut;
	output [2:0] writeregOut;
	output [1:0] regDstOut;	

	dff memDataFF[15:0](.q(memDataOut), .d(memData), .clk(clk), .rst(rst));
	dff ALUDataFF[15:0](.q(ALUDataOut), .d(ALUData), .clk(clk), .rst(rst));
	dff memToRegFF(.q(memToRegOut), .d(memToReg), .clk(clk), .rst(rst));
	dff regWriteFF(.q(regWriteOut), .d(regWrite), .clk(clk), .rst(rst));
	dff writeregFF[2:0](.q(writeregOut), .d(writereg), .clk(clk), .rst(rst));
	dff haltFF(.q(haltOut), .d(halt), .clk(clk), .rst(rst));
	dff regDstReg[1:0] (.q(regDstOut), .d(regDst), .clk(clk), .rst(rst));
	dff nextPCReg[15:0] (.q(nextPCOut), .d(nextPC), .clk(clk), .rst(rst));
endmodule
