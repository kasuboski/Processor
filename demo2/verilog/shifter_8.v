module shifter_8(in, op, sh, out);
	input [15:0] in;
	input [2:0] op;
	input sh;
	output reg [15:0] out;

	always @(*) begin
		casex({sh, op})
		4'b0_xxx:
			//no shift assign out to in
			out = in;
		4'b1_00x:
			out = {in[7:0], in[15:8]};
		4'b1_010:
			out = {in[7:0], 8'b0};
		4'b1_011:
			out = {{8{in[15]}}, in[15:8]};
		4'b1_100:
			out = {8'b0, in[15:8]};
		default:
			out = 16'hXXXX;
		endcase
	end
endmodule
