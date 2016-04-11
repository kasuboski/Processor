module hazard(idex_memRead, idex_rt, ifid_rs, ifid_rt, ifid_write, pcWrite, stall, idex_writereg, exmem_writereg, memwb_writereg, jalr);
	input idex_memRead, jalr;
	input [2:0] idex_rt, ifid_rs, ifid_rt, idex_writereg, exmem_writereg, memwb_writereg;
	output reg ifid_write, pcWrite, stall;

	wire idex_eqrs, idex_eqrt;
	
	assign idex_eqrs = idex_rt == ifid_rs;
	assign idex_eqrt = idex_rt == ifid_rt;
	assign jalrDep = jalr & ((idex_writereg == ifid_rs) | (exmem_writereg == ifid_rs) | (memwb_writereg == ifid_rs));
	
	always @(*) begin
		casex({idex_memRead, idex_eqrs, idex_eqrt, jalrDep})
		4'b1_1_x_x: begin
			ifid_write = 1'b0;
			pcWrite = 1'b0;
			stall = 1'b1;
		end
		4'b1_x_1_x: begin
			ifid_write = 1'b0;
			pcWrite = 1'b0;
			stall = 1'b1;
		end
		4'bx_x_x_1: begin
			ifid_write = 1'b0;
			pcWrite = 1'b0;
			stall = 1'b1;
		end
		default: begin
			ifid_write = 1'b1;
			pcWrite = 1'b1;
			stall = 1'b0;
		end
		endcase
	end
endmodule
