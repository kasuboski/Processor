module MEMWB(clk, rst,memData, ALUData, memToReg, regWrite, memDataOut, ALUDataOut, memToRegOut,
	regWriteOut);
	input [15:0] memData, ALUData;
	input memToReg, regWrite, clk, rst;
	
	output [15:0] memDataOut, ALUDataOut;
	output memToRegOut, regWriteOut;
	
	dff memDataFF[15:0](.q(memDataOut), .d(memData), .clk(clk), .rst(rst));
	dff ALUDataFF[15:0](.q(ALUDataOut), .d(ALUData), .clk(clk), .rst(rst));
	dff memToRegFF(.q(memToRegOut), .d(memToReg), .clk(clk), .rst(rst));
	dff regWriteFF(.q(regWriteOut), .d(regWrite), .clk(clk), .rst(rst));
endmodule