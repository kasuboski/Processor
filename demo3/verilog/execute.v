module execute(readdata1, readdata2, immediate, BranchOP, ALUOp, ALUSrc, invSrc1, invSrc2, sub, PC, jump, jumpReg, branch, nextPC, ALURes, passthrough, reverse, exmem_ALURes, memwb_writeBack, forwardA, forwardB, rt, err, exmem_nextPC, memwb_nextPC);
	
	input [15:0] readdata1, readdata2, immediate, PC;
	input [3:0] ALUOp;
	input [1:0] BranchOP;
	input ALUSrc, jump, jumpReg, branch, invSrc1, invSrc2, sub, passthrough, reverse;

	input [15:0] exmem_ALURes, memwb_writeBack, exmem_nextPC, memwb_nextPC;
	input [2:0] forwardA, forwardB;
	
	output [15:0] nextPC, ALURes, rt;
	output err;
	
	wire [15:0] src2, pcImmAddSum;
	wire sign, zero, jumpErr, pcImmAddOfl, LTZ, GEZ, NEZ;
	
	reg branchCondition;

	reg [15:0] src1, srcB;
	
	assign src2 = (ALUSrc) ? immediate : srcB;
	assign sign = (ALUOp == 4'b1000) ? 1'b1 : 1'b0; 
	assign jumpErr = pcImmAddOfl & ((branch & zero) | jump);
	
	assign GEZ = ~LTZ;
	assign NEZ = ~zero;
	assign LTZ = (readdata1[15]);

        always @(*) begin
		case(forwardA)
		3'b000: src1 = readdata1;
		3'b001: src1 = memwb_writeBack;
		3'b010: src1 = exmem_ALURes;
		3'b011: src1 = exmem_nextPC;
		3'b100: src1 = memwb_nextPC;
		default: src1 = readdata1;
		endcase
	end	

	always @(*) begin
		case(forwardB)
		3'b000: srcB = readdata2;
		3'b001: srcB = memwb_writeBack;
		3'b010: srcB = exmem_ALURes;
		3'b011: srcB = exmem_nextPC;
		3'b100: srcB = memwb_nextPC;
		default: srcB = readdata2;
		endcase
	end

	assign rt = srcB;
	
	//Directly linked the error signal to the overflow signal
	alu ALU(.A(src1), .B(src2), .Cin(sub), .Op(ALUOp), .invA(invSrc1), .invB(invSrc2), .sign(sign), .Out(ALURes), .Ofl(aluErr), .zero(zero), .passthrough(passthrough), .reverse(reverse));
	
	adder pcImmAdd(.A(PC), .B(immediate), .Cin(1'b0), .Overflow(pcImmAddOfl), .Cout(), .Sum(pcImmAddSum));
	
	assign jumpErr = ((branchCondition & branch) | jump) & pcImmAddOfl;
	assign err = 1'b0;
	
	always @(*) begin
		casex(BranchOP)
			//In the case of no branch, just use 00 as branch opcode.
			2'b00 : 
				branchCondition = zero;
			
			2'b01 : 
				branchCondition = NEZ;
			
			2'b10 :
				branchCondition = LTZ;
			
			2'b11 : 
				branchCondition = GEZ;
				
			default : 
				branchCondition = 1'bx;	
		endcase
	end
	
endmodule
