module execute(readdata1, readdata2, immediate, ALUOp, ALUSrc, invSrc1, invSrc2, sub, PC, jump, jumpReg, branch, nextPC, ALURes, err);
	
	input [15:0] readdata1, readdata2, immediate, PC, nextPC;
	input [3:0] ALUOp;
	input ALUSrc, jump, jumpReg, branch, invSrc1, invSrc2, sub;
	
	output [15:0] nextPC, ALURes;
	output err;
	
	wire [15:0] src2;
	wire sign, zero;
	
	assign src2 = (ALUSrc) ? readdata2 : immediate;
	assign sign = (ALUOp == 4'b1000) ? 1'b1 : 1'b0; 
	
	//Directly linked the error signal to the overflow signal
	alu ALU(.A(readdata1), .B(src2), .Cin(sub), .Op(ALUOp), .invA(invSrc1), .invB(invSrc2), .sign(sign), .Out(ALURes), .Ofl(err), .zero(zero));
	
	adder pcImmAdd();
endmodule
