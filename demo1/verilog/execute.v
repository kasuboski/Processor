module execute(readdata1, readdata2, immediate, BranchOP, ALUOp, ALUSrc, invSrc1, invSrc2, sub, PC, jump, jumpReg, branch, nextPC, ALURes, passthrough, err);
	
	input [15:0] readdata1, readdata2, immediate, PC;
	input [3:0] ALUOp;
	input [1:0] BranchOP;
	input ALUSrc, jump, jumpReg, branch, invSrc1, invSrc2, sub, passthrough;
	
	output [15:0] nextPC, ALURes;
	output err;
	
	wire [15:0] src2, pcImmAddSum;
	wire sign, zero, aluERR, jumpErr, pcImmAddOfl, LTZ, GEZ, NEZ;
	
	reg branchCondition;
	
	assign src2 = (ALUSrc) ? immediate : readdata2;
	assign sign = (ALUOp == 4'b1000) ? 1'b1 : 1'b0; 
	assign jumpErr = pcImmAddOfl & ((branch & zero) | jump);
	
	assign GEZ = ~LTZ;
	assign NEZ = ~zero;
	assign LTZ = (ALURes[15]);
	
	//Directly linked the error signal to the overflow signal
	alu ALU(.A(readdata1), .B(src2), .Cin(sub), .Op(ALUOp), .invA(invSrc1), .invB(invSrc2), .sign(sign), .Out(ALURes), .Ofl(aluErr), .zero(zero), .passthrough(passthrough));
	
	adder pcImmAdd(.A(PC), .B(immediate), .Cin(1'b0), .Overflow(pcImmAddOfl), .Cout(), .Sum(pcImmAddSum));
	
	assign nextPC = jumpReg ?  ALURes : (((branchCondition & branch) | jump) ? pcImmAddSum : PC);
	assign jumpErr = ((branchCondition & branch) | jump) & pcImmAddOfl;
	assign err = aluErr | jumpErr;
	
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
