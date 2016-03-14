`include "control_config.v"
module control(instr, regDst, regWrite, whichImm, toExt, jump, jumpReg, branch, memRead, memWrite, memToReg, ALUOp, ALUSrc, err);
    input [4:0] instr;

    output [1:0] regDst;
    output regWrite;
    output reg [1:0] whichImm;
    output reg toExt;
    output jump, jumpReg, branch;
    output memRead, memWrite, memToReg;
    output [3:0] ALUOp;
    output ALUSrc;

    output err;

    reg whichImmErr, toExtErr;
   
    assign err = whichImmErr | toExtErr;
 
    assign regDst = (instr[4:3] == 2'b11) ? `REG_R_FORMAT : 
		    (instr[4:2] == 3'b001) ? `REG_R7 : 
                    (instr == 5'b10011 || instr == 5'b11000 ||
		     instr == 5'b10010) ? `REG_I_FORMAT_UP : `REG_I_FORMAT_LOW;
    //assign regWrite if not one of the instructions that doesn't write
    //a register
    assign regWrite = ~(instr[4:2] == 3'b000 || instr == 5'b10000 ||
			instr[4:2] == 3'b011 || instr[4:1] == 4'b0010); 

    always @(*) begin
	whichImmErr = 1'b0;
	casex(instr)
	5'b010xx: whichImm = `IMM_I1;
	5'b101xx: whichImm = `IMM_I1;
	5'b1000x: whichImm = `IMM_I1;
	5'b10011: whichImm = `IMM_I1;
	5'b011xx: whichImm = `IMM_I2;
	5'b11000: whichImm = `IMM_I2;
	5'b10010: whichImm = `IMM_I2;
	5'b00101: whichImm = `IMM_I2;
	5'b00111: whichImm = `IMM_I2;
	5'b00100: whichImm = `IMM_J;
	5'b00110: whichImm = `IMM_J;
	default: begin
		whichImm = 3'bx;
		whichImmErr = 1'b1;
	end 
	endcase
    end

    always @(*) begin
	toExtErr = 1'b0;
	casex(instr)
	5'b0101x: toExt = 1'b0;
	5'b101xx: toExt = 1'b0;
	default: begin
		toExtErr = 1'b1;
		toExt = 1'bx;
	end
	endcase	
    end 

    assign jump = (instr == 5'b00100 || instr == 5'b00110);

    assign jumpReg = (instr == 5'b00111 || instr == 5'b00101);

    assign branch = (instr[4:2] == 3'b011);

    assign memRead = (instr == 5'b10001);

    assign memWrite = (instr == 5'b10000 || instr == 5'b10011);

    assign memToReg = (instr == 5'b10001);

    //TODO ALuOp
    
    assign ALUSrc = (instr[4:1] == 4'b1101 || instr[4:2] == 3'b111) ? 
			ALUSRC_REG : ALUSRC_IMM;        

endmodule
