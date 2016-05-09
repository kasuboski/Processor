module EXMEM(clk, rst, readData2, ALURes, nextPC, writeReg, regWrite, memToReg, memRead, memWrite, halt, readData2Out, ALUResOut, nextPCOut, writeRegOut, regWriteOut, memToRegOut, memReadOut,memWriteOut, haltOut, regDst, regDstOut, memStall);
	
	input [15:0] readData2, ALURes, nextPC;
	input [2:0] writeReg;
	input regWrite, memToReg, memRead, memWrite, clk, rst, halt;
	input [1:0] regDst;
	input memStall;
	
	output [15:0] readData2Out, ALUResOut, nextPCOut;
	output [2:0] writeRegOut;
	output regWriteOut, memToRegOut, memReadOut, memWriteOut, haltOut;
	output [1:0] regDstOut;	

	wire [15:0] readData2In, ALUResIn, nextPCIn;
	wire [2:0] writeRegIn;
	wire regWriteIn, memToRegIn, memReadIn, memWriteIn, clk, rst, haltIn;
	wire [1:0] regDstIn;
        
	assign readData2In = memStall ? readData2Out : readData2;
	assign ALUResIn = memStall ? ALUResOut : ALURes;
 	assign nextPCIn = memStall ? nextPCOut : nextPC;
	assign writeRegIn = memStall ? writeRegOut : writeReg;
	assign regWriteIn = memStall ? regWriteOut : regWrite;
	assign memToRegIn = memStall ? memToRegOut : memToReg;
	assign memReadIn = memStall ? memReadOut : memRead;
	assign memWriteIn = memStall ? memWriteOut : memWrite;
	assign haltIn = memStall ? haltOut : halt;
	assign regDstIn = memStall ? regDstOut : regDst;
	

	dff readData2FF[15:0](.q(readData2Out), .d(readData2In), .clk(clk), .rst(rst));
	dff ALUResFF[15:0](.q(ALUResOut), .d(ALUResIn), .clk(clk), .rst(rst));
	dff nextPCFF[15:0](.q(nextPCOut), .d(nextPCIn), .clk(clk), .rst(rst));
	dff writeRegFF[2:0](.q(writeRegOut), .d(writeRegIn), .clk(clk), .rst(rst));
	dff regWriteFF(.q(regWriteOut), .d(regWriteIn), .clk(clk), .rst(rst));
	dff memToRegFF(.q(memToRegOut), .d(memToRegIn), .clk(clk), .rst(rst));
	dff memReadFF(.q(memReadOut), .d(memReadIn), .clk(clk), .rst(rst));
	dff memWriteFF(.q(memWriteOut), .d(memWriteIn), .clk(clk), .rst(rst));
	dff haltFF(.q(haltOut), .d(haltIn), .clk(clk), .rst(rst));
	dff regDstReg [1:0](.q(regDstOut), .d(regDstIn), .clk(clk), .rst(rst));
endmodule
