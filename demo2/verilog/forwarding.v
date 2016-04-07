module forwarding(idex_rs, idex_rt, exmem_rd, memwb_rd, exmem_regWrite, memwb_regWrite, forwardA, forwardB);
	input [2:0] idex_rs, idex_rt, exmem_rd, memwb_rd;
	input exmem_regWrite, memwb_regWrite;
	output reg [1:0] forwardA, forwardB;

	wire exmem_eqrs, exmem_eqrt, memwb_eqrs, memwb_eqrt;

	assign exmem_eqrs = (exmem_rd == idex_rs);
	assign exmem_eqrt = (exmem_rd == idex_rt);
	
	assign memwb_eqrs = (memwb_rd == idex_rs);
	assign memwb_eqrt = (memwb_rd == idex_rt);

	//assigning forwardA
	always @(*) begin
		casex({exmem_regWrite, exmem_eqrs, memwb_regWrite, memwb_eqrs})
		4'b1_1_x_x: forwardA = 2'b10;
		4'bx_x_1_1: forwardA = 2'b01;
		default: forwardA = 2'b00;	
		endcase
	end	

	//assigning forwardB
	always @(*) begin
		casex({exmem_regWrite, exmem_eqrt, memwb_regWrite, memwb_eqrt})
		4'b1_1_x_x: forwardB = 2'b10;
		4'bx_x_1_1: forwardB = 2'b01;
		default: forwardB = 2'b00;
		endcase
	end
endmodule
