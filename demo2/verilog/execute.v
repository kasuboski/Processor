module execute(readdata1, readdata2, immediate, BranchOP, ALUOp, ALUSrc, invSrc1, invSrc2, sub, PC, jump, jumpReg, branch, nextPC, ALURes, passthrough, reverse, exmem_ALURes, memwb_writeBack, forwardA, forwardB, err);
	
	input [15:0] readdata1, readdata2, immediate, PC;
	input [3:0] ALUOp;
	input [1:0] BranchOP;
	input ALUSrc, jump, jumpReg, branch, invSrc1, invSrc2, sub, passthrough, reverse;

	input [15:0] exmem_ALURes, memwb_writeBack;
	input [1:0] forwardA, forwardB;
	
	output [15:0] nextPC, ALURes;
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
		2'b00: src1 = readdata1;
		2'b01: src1 = memwb_writeBack;
		2'b10: src1 = exmem_ALURes;
		default: src1 = readdata1;
		endcase
	end	

	always @(*) begin
		case(forwardB)
		2'b00: srcB = readdata2;
		2'b01: srcB = memwb_writeBack;
		2'b10: srcB = exmem_ALURes;
		default: srcB = readdata2;
		endcase
	end
	
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
