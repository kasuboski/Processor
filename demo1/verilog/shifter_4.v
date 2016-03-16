module shifter_4(in, op, sh, out);
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
			out = {in[11:0], in[15:12]};
		4'b1_001:
			out = {in[3:0], in[15:4]};
		4'b1_010:
			out = {in[11:0], 4'b0};
		4'b1_011:
			out = {{4{in[15]}}, in[15:4]};
		4'b1_100:
			out = {4'b0, in[15:4]};
		default:
			out = 16'hXXXX;
		endcase
	end
endmodule
