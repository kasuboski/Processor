module shifter_8(in, op, sh, out);
	input [15:0] in;
	input [1:0] op;
	input sh;
	output reg [15:0] out;

	always @(*) begin
		casex({sh, op})
		3'b0_xx:
			//no shift assign out to in
			out = in;
		3'b1_00:
			out = {in[7:0], in[15:8]};
		3'b1_01:
			out = {in[7:0], 8'b0};
		3'b1_10:
			out = {{8{in[15]}}, in[15:8]};
		3'b1_11:
			out = {8'b0, in[15:8]};
		default:
			out = 16'hXXXX;
		endcase
	end
endmodule
