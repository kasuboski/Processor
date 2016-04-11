module forwarding(idex_rs, idex_rt, exmem_rd, memwb_rd, exmem_regDst, memwb_regDst, exmem_regWrite, memwb_regWrite, forwardA, forwardB);
	input [2:0] idex_rs, idex_rt, exmem_rd, memwb_rd;
	input exmem_regWrite, memwb_regWrite;
	input [1:0] exmem_regDst, memwb_regDst;

	output reg [2:0] forwardA, forwardB;

	wire exmem_eqrs, exmem_eqrt, memwb_eqrs, memwb_eqrt, exmem_regDstEqrs, exmem_regDstEqrt, memwb_regDstEqrs, memwb_regDstEqrt;

	assign exmem_eqrs = (exmem_rd == idex_rs);
	assign exmem_eqrt = (exmem_rd == idex_rt);
	
	assign memwb_eqrs = (memwb_rd == idex_rs);
	assign memwb_eqrt = (memwb_rd == idex_rt);

	assign exmem_regDstEqrt = ((3'd7 == idex_rt) && (exmem_regDst == 2'b01));
	assign exmem_regDstEqrs = ((3'd7 == idex_rs) && (exmem_regDst == 2'b01));

	assign memwb_regDstEqrs = ((3'd7 == idex_rs) && (memwb_regDst == 2'b01));
	assign memwb_regDstEqrt = ((3'd7 == idex_rt) && (memwb_regDst == 2'b01));

	//assigning forwardA
	always @(*) begin
		casex({exmem_regWrite, exmem_eqrs, memwb_regWrite, memwb_eqrs, exmem_regDstEqrs, memwb_regDstEqrs})
		6'b1_x_x_x_1_x: forwardA = 3'b011;
		6'bx_x_1_x_x_1: forwardA = 3'b100;
		6'b1_1_x_x_x_x: forwardA = 3'b010;
		6'bx_x_1_1_x_x: forwardA = 3'b001;	
		default: forwardA = 3'b000;	
		endcase
	end	

	//assigning forwardB
	always @(*) begin
		casex({exmem_regWrite, exmem_eqrt, memwb_regWrite, memwb_eqrt, exmem_regDstEqrt, memwb_regDstEqrt})	
		6'b1_x_x_x_1_x: forwardB = 3'b011;
		6'bx_x_1_x_x_1: forwardB = 3'b100;
		6'b1_1_x_x_x_x: forwardB = 3'b010;
		6'bx_x_1_1_x_x: forwardB = 3'b001;
		default: forwardB = 3'b000;
		endcase
	end
endmodule
