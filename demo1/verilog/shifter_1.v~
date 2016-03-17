module shifter_1(in, op, sh, out);
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
			out = {in[14:0], in[15]};
		4'b1_001:
			out = {in[0], in[15:1]}
		4'b1_010:
			out = {in[14:0], 1'b0};
		4'b1_011:
			out = {in[15], in[15:1]};
		4'b1_100:
			out = {1'b0, in[15:1]};
		default:
			out = 16'hXXXX;
		endcase
	end
endmodule
