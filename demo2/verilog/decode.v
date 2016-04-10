`include "control_config.v"
module decode(clk, rst, instr, PC, writeBackData, writeregIn, regWriteIn, readdata1, readdata2, immediate, jump, jumpReg, branch, branchOp, memRead, memWrite, memToReg, ALUOp, ALUSrc, invSrc1, invSrc2, sub, halt, passthrough, reverse, writereg, regWrite, rs, rt, err);

    input clk, rst;
    
    input [15:0] instr;
    input [15:0] PC, writeBackData;

    input [2:0] writeregIn;
    input regWriteIn;
    
    output [15:0] readdata1, readdata2;
    output reg [15:0] immediate;

    output jump, jumpReg, branch;
    output [1:0] branchOp;
    output memRead, memWrite, memToReg;
    output [3:0] ALUOp;
    output ALUSrc;

    output invSrc1, invSrc2, sub, halt, passthrough, reverse;

    output err;

    wire [1:0] regDst;
    wire [1:0] whichImm;
    wire toExt;
    output regWrite;
    output [2:0] rs, rt;

    output reg [2:0] writereg; // where to get the writeregsel
    wire [15:0] writedata;

    reg writeRegMuxErr, immediateMuxErr;
    wire ctrlErr, regErr;
    assign err = ctrlErr | regErr;

    wire cycle, haltCtrl;

    assign haltWire = (haltCtrl & cycle) | halt;

    dff haltFF(.q(halt), .d(haltWire), .clk(clk), .rst(rst));

    //determine if past first cycle
    dff cycleFF(.q(cycle), .d(1'b1), .clk(clk), .rst(rst));

    assign writedata = (regDst == 2'b01) ? PC : writeBackData;

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

    control ctrl(.instr(instr[15:11]), .func(instr[1:0]), .regDst(regDst), .regWrite(regWrite), .whichImm(whichImm), .toExt(toExt), .jump(jump), .jumpReg(jumpReg), .branch(branch), .branchOp(branchOp), .memRead(memRead), .memWrite(memWrite), .memToReg(memToReg), .ALUOp(ALUOp), .ALUSrc(ALUSrc), .invSrc1(invSrc1), .invSrc2(invSrc2), .sub(sub), .halt(haltCtrl), .passthrough(passthrough), .reverse(reverse), .err(ctrlErr));

    rf_bypass register(
           .read1data(readdata1), .read2data(readdata2), .err(regErr),
           .clk(clk), .rst(rst), .read1regsel(instr[10:8]), .read2regsel(instr[7:5]), .writeregsel(writeregIn), .writedata(writedata), .write(regWriteIn)
           );

endmodule
