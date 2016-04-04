module EXMEM(clk, rst, readData2, ALURes, nextPC, writeReg, regWrite, memToReg, memRead, memWrite,readData2Out, ALUResOut, nextPCOut, writeRegOut, regWriteOut, memToRegOut, memReadOut,memWriteOut);
	
	input [15:0] readData2, ALURes, nextPC;
	input [2:0] writeReg;
	input regWrite, memToReg, memRead, memWrite, clk, rst;
	
	output [15:0] readData2Out, ALUResOut, nextPCOut;
	output [2:0] writeRegOut;
	output regWriteOut, memToRegOut, memReadOut, memWriteOut;
	
	dff [15:0] readData2FF(.q(readData2Out), .d(readData2), .clk(clk), .rst(rst));
	dff [15:0] ALUResFF(.q(ALUResOut), .d(ALURes), .clk(clk), .rst(rst));
	dff [15:0] nextPCFF(.q(nexPCOut), .d(nextPC), .clk(clk), .rst(rst));
	dff [2:0] writeRegFF(.q(writeRegOut), .d(writeReg), .clk(clk), .rst(rst));
	dff regWriteFF(.q(regWriteOut), .d(regWrite), .clk(clk), .rst(rst));
	dff memToRegFF(.q(memToRegOut), .d(memToReg), .clk(clk), .rst(rst));
	dff memReadFF(.q(memReadOut), .d(memRead), .clk(clk), .rst(rst));
	dff memWriteFF(.q(memWriteOut), .d(memWrite), .clk(clk), .rst(rst));
endmodule