module EXMEM(clk, rst, readData2, ALURes, nextPC, writeReg, regWrite, memToReg, memRead, memWrite, halt, readData2Out, ALUResOut, nextPCOut, writeRegOut, regWriteOut, memToRegOut, memReadOut,memWriteOut, haltOut);
	
	input [15:0] readData2, ALURes, nextPC;
	input [2:0] writeReg;
	input regWrite, memToReg, memRead, memWrite, clk, rst, halt;
	
	output [15:0] readData2Out, ALUResOut, nextPCOut;
	output [2:0] writeRegOut;
	output regWriteOut, memToRegOut, memReadOut, memWriteOut, haltOut;
	
	dff readData2FF[15:0](.q(readData2Out), .d(readData2), .clk(clk), .rst(rst));
	dff ALUResFF[15:0](.q(ALUResOut), .d(ALURes), .clk(clk), .rst(rst));
	dff nextPCFF[15:0](.q(nextPCOut), .d(nextPC), .clk(clk), .rst(rst));
	dff writeRegFF[2:0](.q(writeRegOut), .d(writeReg), .clk(clk), .rst(rst));
	dff regWriteFF(.q(regWriteOut), .d(regWrite), .clk(clk), .rst(rst));
	dff memToRegFF(.q(memToRegOut), .d(memToReg), .clk(clk), .rst(rst));
	dff memReadFF(.q(memReadOut), .d(memRead), .clk(clk), .rst(rst));
	dff memWriteFF(.q(memWriteOut), .d(memWrite), .clk(clk), .rst(rst));
	dff haltFF(.q(haltOut), .d(halt), .clk(clk), .rst(rst));
endmodule
