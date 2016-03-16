module shifter_2(in, op, sh, out);
	input [15:0] in;
	input [2:0] op;
	input sh;
	output reg [15:0] out;

	always @(*) begin
		casex({sh, op})
		4'b0_xxx:
			//no shift assign out to in
			out = in;
		4'b1_000:
			out = {in[13:0], in[15:14]};
		4'b1_001:
			out = {in[1:0], in[15:2]};
		4'b1_010:
			out = {in[13:0], 2'b0};
		4'b1_011:
			out = {{2{in[15]}}, in[15:2]};
		4'b1_100:
			out = {2'b0, in[15:2]};
		default:
			out = 16'hXXXX;
		endcase
	end
endmodule
