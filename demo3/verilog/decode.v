`include "control_config.v"
module decode(clk, rst, instr, PC, writeBackData, writeregIn, regWriteIn, readdata1, readdata2, immediate, jump, jumpReg, branch, branchOp, memRead, memWrite, memToReg, ALUOp, ALUSrc, invSrc1, invSrc2, sub, halt, passthrough, reverse, writereg, regWrite, rs, rt, err, nextPC, regDstIn, regDstOut, linkPC, flush, jalr, willBranch, stall);

    input clk, rst;
    
    input [15:0] instr;
    input [15:0] PC, writeBackData;
    input [15:0] linkPC;
    input [2:0] writeregIn;
    input regWriteIn, stall;
    input [1:0] regDstIn;
    output [15:0] readdata1, readdata2;
    output reg [15:0] immediate;

    output jump, jumpReg, branch;
    output [1:0] branchOp;
    output memRead, memWrite, memToReg;
    output [3:0] ALUOp;
    output ALUSrc;

    output invSrc1, invSrc2, sub, halt, passthrough, reverse;

    output err;
    output flush;
    wire [1:0] regDst;
    wire [1:0] whichImm;
    wire toExt;
    output regWrite;
    output [2:0] rs, rt;
    output [1:0] regDstOut;
    output reg [2:0] writereg; // where to get the writeregsel
    output jalr, willBranch;
    wire [15:0] writedata;

    reg writeRegMuxErr, immediateMuxErr;
    wire ctrlErr, regErr;
    assign err = ctrlErr | regErr;
    assign flush = jump | jumpReg;
    wire cycle, haltCtrl;
	
    //Branch signals
    wire zero, LTZ, GEZ, NEZ;
    wire [15:0] pcImmAddSum, jumpRegAddSum;
    output [15:0] nextPC;
    reg branchCondition;

    assign haltWire = ((haltCtrl & cycle) | halt) & ~stall;
    assign regDstOut = regDst;
    dff haltFF(.q(halt), .d(haltWire), .clk(clk), .rst(rst));

    //determine if past first cycle
    dff cycleFF(.q(cycle), .d(1'b1), .clk(clk), .rst(rst));

    assign writedata = (regDstIn == 2'b01) ? linkPC : writeBackData;

    //determine writeReg
    always @(*) begin
        writeRegMuxErr = 1'b0;

        case(regDst)
        2'b11: writereg = instr[7:5];
        2'b00: writereg = instr[4:2];
        2'b01: writereg = 3'd7;
	    2'b10: writereg = instr[10:8];
        default: begin
            writereg = 3'bx;
            writeRegMuxErr = 1'b1;
        end
        endcase
    end

    //determine immediate
    always @(*) begin
        immediateMuxErr = 1'b0;
    
        case(whichImm)
        2'b00: immediate = {{5{instr[10]}}, instr[10:0]};
        2'b01: immediate = (toExt) ? {{11{instr[4]}}, instr[4:0]} : {11'b0, instr[4:0]};
        2'b10: immediate = {{8{instr[7]}},instr[7:0]};
        default: begin
            immediateMuxErr = 1'b1;
            immediate = 16'bx;
        end
        endcase
    end

    assign rs = instr[10:8];
    assign rt = instr[7:5];
    assign jalr = instr[15:11] == 5'b00111;
    assign willBranch = branchCondition & branch;
    control ctrl(.instr(instr[15:11]), .func(instr[1:0]), .regDst(regDst), .regWrite(regWrite), .whichImm(whichImm), .toExt(toExt), .jump(jump), .jumpReg(jumpReg), .branch(branch), .branchOp(branchOp), .memRead(memRead), .memWrite(memWrite), .memToReg(memToReg), .ALUOp(ALUOp), .ALUSrc(ALUSrc), .invSrc1(invSrc1), .invSrc2(invSrc2), .sub(sub), .halt(haltCtrl), .passthrough(passthrough), .reverse(reverse), .err(ctrlErr));

    rf_bypass register(
           .read1data(readdata1), .read2data(readdata2), .err(regErr),
           .clk(clk), .rst(rst), .read1regsel(instr[10:8]), .read2regsel(instr[7:5]), .writeregsel(writeregIn), .writedata(writedata), .write(regWriteIn)
           );

	//Branching logic
	
	assign zero = ~(|readdata1);
	assign GEZ = ~LTZ;
	assign NEZ = ~zero;
	assign LTZ = (readdata1[15]);
	
	adder pcImmAdd(.A(PC), .B(immediate), .Cin(1'b0), .Overflow(pcImmAddOfl), .Cout(), .Sum(pcImmAddSum));
	adder jumpRegAdd(.A(readdata1), .B(immediate), .Cin(1'b0), .Overflow(), .Cout(), .Sum(jumpRegAddSum));	
	assign nextPC = jumpReg ? jumpRegAddSum : (((branchCondition & branch) | jump) ? pcImmAddSum : PC);
	
	always @(*) begin
		casex(branchOp)
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
