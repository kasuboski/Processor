module IDEX(clk, rst, 
    readdata1, readdata2, immediate, PC, jump, jumpReg, branch, branchOp, memRead, memWrite, memToReg, ALUOp, ALUSrc, invSrc1, invSrc2, sub, passthrough, reverse, writereg, regWrite, halt, rs, rt, regDst,
    readdata1Out, readdata2Out, immediateOut, PCOut, jumpOut, jumpRegOut, branchOut, branchOpOut, memReadOut, memWriteOut, memToRegOut, ALUOpOut, ALUSrcOut, invSrc1Out, invSrc2Out, subOut, passthroughOut, reverseOut, writeregOut, regWriteOut, haltOut, rsOut, rtOut, regDstOut, memStall
    );
    input clk, rst;

    input [15:0] readdata1, readdata2, immediate, PC;
    input jump, jumpReg, branch;
    input [1:0] branchOp;
    input memRead, memWrite, memToReg;
    input [3:0] ALUOp;
    input ALUSrc;
    input [1:0] regDst;
    input invSrc1, invSrc2, sub, passthrough, reverse;

    input [2:0] writereg, rs, rt;
    input regWrite, halt, memStall;

    output [15:0] readdata1Out, readdata2Out, immediateOut, PCOut;
    output jumpOut, jumpRegOut, branchOut;
    output [1:0] branchOpOut;
    output memReadOut, memWriteOut, memToRegOut;
    output [3:0] ALUOpOut;
    output ALUSrcOut;
    output [1:0] regDstOut;
    output invSrc1Out, invSrc2Out, subOut, passthroughOut, reverseOut;

    output [2:0] writeregOut, rsOut, rtOut;
    output regWriteOut, haltOut;

    wire [15:0] readdata1In, readdata2In, immediateIn, PCIn;
    wire jumpIn, jumpRegIn, branchIn, invSrc1In, invSrc2In, subIn, passthroughIn, reverseIn;
    wire [1:0] branchOpIn, regDstIn;
    wire memReadIn, memWriteIn, memToRegIn, ALUSrcIn;    
    wire [3:0] ALUOpIn;
    wire [2:0] writeregIn, rsIn, rtIn;
    wire regWriteIn, haltIn;

    assign readdata1In = memStall ? readdata1Out : readdata1;
    assign readdata2In = memStall ? readdata2Out : readdata2;
    assign immediateIn = memStall ? immediateOut : immediate;
    assign PCIn = memStall ? PCOut : PC;
    assign jumpIn = memStall ? jumpOut : jump;
    assign jumpRegOut = memStall ? jumpRegOut : jumpReg;
    assign ALUSrcIn = memStall ? ALUSrcOut : ALUSrc;
    assign branchIn = memStall ? branchOut : branch;
    assign invSrc1In = memStall ? invSrc1Out : invSrc1;
    assign invSrc2In = memStall ? invSrc2Out : invSrc2;
    assign subIn = memStall ? subOut : sub;
    assign passthroughIn = memStall ? passthroughOut : passthrough;
    assign reverseIn = memStall ? reverseOut : reverse;
    assign branchOpIn = memStall ? branchOpOut : branchOp;
    assign regDstIn = memStall ? regDstOut : regDst;  
    assign memReadIn = memStall ? memReadOut : memRead;
    assign memWriteIn = memStall ? memWriteOut : memWrite;
    assign memToRegIn = memStall ? memToRegOut : memToReg;
    assign ALUOpIn = memStall ? ALUOpOut : ALUOp;
    assign writeregIn = memStall ? writeregOut : writereg;
    assign rsIn = memStall ? rsOut : rs;
    assign rtIn = memStall ? rtOut : rt;
    assign regWriteIn = memStall ? regWriteOut : regWrite;
    assign haltIn = memStall ? haltOut : halt;  

    dff readdata1Reg[15:0](.q(readdata1Out), .d(readdata1In), .clk(clk), .rst(rst));
    dff readdata2Reg[15:0](.q(readdata2Out), .d(readdata2In), .clk(clk), .rst(rst));
    dff immediateReg[15:0](.q(immediateOut), .d(immediateIn), .clk(clk), .rst(rst));
    dff PCReg[15:0](.q(PCOut), .d(PCIn), .clk(clk), .rst(rst));

    dff jumpFF(.q(jumpOut), .d(jumpIn), .clk(clk), .rst(rst));
    dff jumpRegFF(.q(jumpRegOut), .d(jumpRegIn), .clk(clk), .rst(rst));
    dff branchReg(.q(branchOut), .d(branchIn), .clk(clk), .rst(rst));
    
    dff branchOpReg[1:0](.q(branchOpOut), .d(branchOpIn), .clk(clk), .rst(rst));
    
    dff memReadReg(.q(memReadOut), .d(memReadIn), .clk(clk), .rst(rst));
    dff memWriteReg(.q(memWriteOut), .d(memWriteIn), .clk(clk), .rst(rst));
    dff memToRegFF(.q(memToRegOut), .d(memToRegIn), .clk(clk), .rst(rst));

    dff ALUOpReg[3:0](.q(ALUOpOut), .d(ALUOpIn), .clk(clk), .rst(rst));
    
    dff ALUSrcReg(.q(ALUSrcOut), .d(ALUSrcIn), .clk(clk), .rst(rst));

    dff invSrc1Reg(.q(invSrc1Out), .d(invSrc1In), .clk(clk), .rst(rst));
    dff invSrc2Reg(.q(invSrc2Out), .d(invSrc2In), .clk(clk), .rst(rst));
    dff subReg(.q(subOut), .d(subIn), .clk(clk), .rst(rst));
    dff passthroughReg(.q(passthroughOut), .d(passthroughIn), .clk(clk), .rst(rst));
    dff reverseReg(.q(reverseOut), .d(reverseIn), .clk(clk), .rst(rst));

    dff writeregFF[2:0](.q(writeregOut), .d(writeregIn), .clk(clk), .rst(rst));
    dff rsFF[2:0](.q(rsOut), .d(rsIn), .clk(clk), .rst(rst));
    dff rtFF[2:0](.q(rtOut), .d(rtIn), .clk(clk), .rst(rst));

    dff regWriteReg(.q(regWriteOut), .d(regWriteIn), .clk(clk), .rst(rst));
    dff haltReg(.q(haltOut), .d(haltIn), .clk(clk), .rst(rst));
    dff regDstReg[1:0](.q(regDstOut), .d(regDstIn), .clk(clk), .rst(rst));
endmodule
