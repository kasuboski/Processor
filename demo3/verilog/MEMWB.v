module MEMWB(clk, rst,memData, ALUData, memToReg, regWrite, writereg, halt, memDataOut, ALUDataOut, memToRegOut,
	regWriteOut, writeregOut, haltOut, regDst, regDstOut, nextPC, nextPCOut, memStall);
	input [15:0] memData, ALUData, nextPC;
	input memToReg, regWrite, clk, rst, halt, memStall;
	input [2:0] writereg;
	input [1:0] regDst;		

	output [15:0] memDataOut, ALUDataOut, nextPCOut;
	output memToRegOut, regWriteOut, haltOut;
	output [2:0] writeregOut;
	output [1:0] regDstOut;	

	wire [15:0] memDataIn, ALUDataIn, nextPCIn;
	wire memToRegIn, regWriteIn, haltIn;
	wire [2:0] writeregIn;
	wire [1:0] regDstIn;
	
	assign memDataIn = memStall ? memDataOut : memData;
	assign ALUDataIn = memStall ? ALUDataOut : ALUData;
	assign nextPCIn = memStall ? nextPCOut : nextPC;
	assign memToRegIn = memStall ? memToRegOut : memToReg;
	assign regWriteIn = memStall ? regWriteOut : regWrite;
	assign haltIn = memStall ? haltOut : halt;
	assign writeregIn = memStall ? writeregOut : writereg;
	assign regDstIn = memStall ? regDstOut : regDst;

	dff memDataFF[15:0](.q(memDataOut), .d(memDataIn), .clk(clk), .rst(rst));
	dff ALUDataFF[15:0](.q(ALUDataOut), .d(ALUDataIn), .clk(clk), .rst(rst));
	dff memToRegFF(.q(memToRegOut), .d(memToRegIn), .clk(clk), .rst(rst));
	dff regWriteFF(.q(regWriteOut), .d(regWriteIn), .clk(clk), .rst(rst));
	dff writeregFF[2:0](.q(writeregOut), .d(writeregIn), .clk(clk), .rst(rst));
	dff haltFF(.q(haltOut), .d(haltIn), .clk(clk), .rst(rst));
	dff regDstReg[1:0] (.q(regDstOut), .d(regDstIn), .clk(clk), .rst(rst));
	dff nextPCReg[15:0] (.q(nextPCOut), .d(nextPCIn), .clk(clk), .rst(rst));
endmodule
