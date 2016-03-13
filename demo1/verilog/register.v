module register(in, clk, rst,  out);
	parameter width = 16;

	input [width-1:0] in;
	input clk, rst;
	input [width-1:0] out;

	dff val[width-1:0](.q(out), .d(in), .clk(clk), .rst(rst));	
endmodule
