module hazard(idex_memRead, idex_rt, ifid_rs, ifid_rt, ifid_write, pcWrite, stall, idex_writereg, exmem_writereg, memwb_writereg, jalr, willBranch, ifid_PC, idex_PC, exmem_PC, memwb_PC, idex_regWrite, exmem_regWrite, memwb_regWrite);
	input idex_memRead, jalr, willBranch, idex_regWrite, exmem_regWrite, memwb_regWrite;
	input [2:0] idex_rt, ifid_rs, ifid_rt, idex_writereg, exmem_writereg, memwb_writereg;
	input [15:0] ifid_PC, idex_PC, exmem_PC, memwb_PC;
	output reg ifid_write, pcWrite, stall;

	wire idex_eqrs, idex_eqrt;
 	wire jumpBranchStall, jalrDep, brDep;	
	assign idex_eqrs = idex_rt == ifid_rs & (ifid_PC != idex_PC);
	assign idex_eqrt = idex_rt == ifid_rt & (ifid_PC != idex_PC);
	assign jalrDep = jalr & (((idex_writereg == ifid_rs) & (ifid_PC != idex_PC)) | (exmem_writereg == ifid_rs & (ifid_PC != exmem_PC)) | (memwb_writereg == ifid_rs & (ifid_PC != memwb_PC)));
	assign brDep = willBranch & (((idex_writereg == ifid_rs) && idex_regWrite) | ((exmem_writereg == ifid_rs) && exmem_regWrite) | ((memwb_writereg == ifid_rs) & memwb_regWrite));
 	assign jumpBranchStall = jalrDep | brDep;
	always @(*) begin
		casex({idex_memRead, idex_eqrs, idex_eqrt, jumpBranchStall})
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
