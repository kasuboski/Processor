/* $Author: karu $ */
/* $LastChangedDate: 2009-03-04 23:09:45 -0600 (Wed, 04 Mar 2009) $ */
/* $Rev: 45 $ */
module proc (/*AUTOARG*/
   // Outputs
   err, 
   // Inputs
   clk, rst
   );

   input clk;
   input rst;

   output err;

   // None of the above lines can be modified

   // OR all the err ouputs for every sub-module and assign it as this
   // err output
   
   // As desribed in the homeworks, use the err signal to trap corner
   // cases that you think are illegal in your statemachines
   
   wire [15:0] instr;
   wire [15:0] PC, nextPC;
   wire [15:0] readdata1, readdata2, immediate, writeBackData;
   wire jump, jumpReg, branch;
   wire [1:0] branchOp;
   wire memRead, memWrite, memToReg;
   wire ALUSrc;
   wire [3:0] ALUOp;
   wire invSrc1, invSrc2, sub, halt, passthrough, reverse;
   wire [15:0] ALURes;
   wire [15:0] readData;

   wire [2:0] writereg, writeregIn;

   wire fetchErr, decodeErr, executeErr, memoryErr, writeBackErr;

   wire [15:0] ifidPC, ifidAddr;

   wire [15:0] idex_readdata1, idex_readdata2, idex_immediate;
   wire idex_jump, idex_jumpReg, idex_branch;
   wire [1:0] idex_branchOp;
   wire idex_memRead, idex_memWrite, idex_memToReg;
   wire [3:0] idex_ALUOp;
   wire idex_ALUSrc;
   wire idex_invSrc1, idex_invSrc2, idex_sub, idex_passthrough, idex_reverse;
   wire [2:0] idex_writereg;

   assign err = fetchErr | decodeErr | executeErr | memoryErr | writeBackErr;

   fetch fetch0(.clk(clk), .rst(rst), .halt(halt), .nextPC(nextPC), .PC2(PC), .instr(instr), .err(fetchErr));

   IFID ifidReg(.clk(clk), .rst(rst), .PC(PC), .addr(instr), .PCout(ifidPC), .addrOut(ifidAddr));

   decode decode0(.clk(clk), .rst(rst), .instr(ifidAddr), .PC(ifidPC), .writeBackData(writeBackData), .writeregIn(writeregIn), .readdata1(readdata1), .readdata2(readdata2), .immediate(immediate), .jump(jump), .jumpReg(jumpReg), .branch(branch), .branchOp(branchOp), .memRead(memRead), .memWrite(memWrite), .memToReg(memToReg), .ALUOp(ALUOp), .ALUSrc(ALUSrc), .invSrc1(invSrc1), .invSrc2(invSrc2), .sub(sub), .halt(halt), .passthrough(passthrough), .reverse(reverse), .writereg(writereg), .err(decodeErr));

   IDEX idexReg(.clk(clk), .rst(rst), 
    .readdata1(readdata1), .readdata2(readdata2), .immediate(immediate), .jump(jump), .jumpReg(jumpReg), .branch(branch), .branchOp(branchOp), .memRead(memRead), .memWrite(memWrite), .memToReg(memToReg), .ALUOp(ALUOp), .ALUSrc(ALUSrc), .invSrc1(invSrc1), .invSrc2(invSrc2), .sub(sub), .passthrough(passthrough), .reverse(reverse), .writereg(writereg),
    .readdata1Out(idex_readdata1), .readdata2Out(idex_readdata2), .immediateOut(idex_immediate), .jumpOut(idex_jump), .jumpRegOut(idex_jumpReg), .branchOut(idex_branch), .branchOpOut(idex_branchOp), .memReadOut(idex_memRead), .memWriteOut(idex_memWrite), .memToRegOut(idex_memToReg), .ALUOpOut(idex_ALUOp), .ALUSrcOut(idex_ALUSrc), .invSrc1Out(idex_invSrc1), .invSrc2Out(idex_invSrc2), .subOut(idex_sub), .passthroughOut(idex_passthrough), .reverseOut(idex_reverse), .writeregOut(idex_writereg)
    );

   execute ex0(.readdata1(readdata1), .readdata2(readdata2), .immediate(immediate), .BranchOP(branchOp), .ALUOp(ALUOp), .ALUSrc(ALUSrc), .invSrc1(invSrc1), .invSrc2(invSrc2), .sub(sub), .PC(PC), .jump(jump), .jumpReg(jumpReg), .branch(branch), .nextPC(nextPC), .ALURes(ALURes), .passthrough(passthrough), .reverse(reverse), .err(executeErr));

   memory memory0(.clk(clk), .rst(rst), .addr(ALURes), .writeData(readdata2), .memWrite(memWrite), .memRead(memRead), .halt(halt), .readData(readData), .err(memoryErr));

   writeBack wb0(.memData(readData), .ALUData(ALURes), .memToReg(memToReg), .writeBackData(writeBackData), .err(writeBackErr));
   
endmodule // proc
// DUMMY LINE FOR REV CONTROL :0:
