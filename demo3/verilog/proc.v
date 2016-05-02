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
   wire [15:0] PC, nextPC, dec_nextPC;
   wire [15:0] readdata1, readdata2, immediate, writeBackData;
   wire jump, jumpReg, branch;
   wire [1:0] branchOp;
   wire memRead, memWrite, memToReg;
   wire ALUSrc;
   wire [3:0] ALUOp;
   wire invSrc1, invSrc2, sub, halt, passthrough, reverse;
   wire [15:0] ALURes;
   wire [15:0] readData;

   wire [2:0] writereg;
   wire [2:0] rs, rt;

   wire regWrite;

   wire stalled_regWrite, stalled_memWrite, stalled_memToReg;

   wire [2:0] forwardA, forwardB;

   wire fetchErr, decodeErr, executeErr, memoryErr, writeBackErr;

   wire [15:0] ifidPC, ifidAddr;
   wire ifid_write, pcWrite, stall;
   wire flush;   

   wire [2:0] idex_rs, idex_rt;
   wire [15:0] idex_readdata1, idex_readdata2, idex_immediate;
   wire idex_jump, idex_jumpReg, idex_branch;
   wire [1:0] idex_branchOp;
   wire idex_memRead, idex_memWrite, idex_memToReg;
   wire [3:0] idex_ALUOp;
   wire idex_ALUSrc;
   wire idex_invSrc1, idex_invSrc2, idex_sub, idex_passthrough, idex_reverse;
   wire [2:0] idex_writereg;
   wire [15:0] idex_PC;
   wire idex_regWrite, idex_halt;
   wire [1:0] idex_regDst, exmem_regDst, memwb_regDst, regDstIn, regDstOut;
   wire [15:0] ex_writeData;

   wire [15:0] exmem_readData2, exmem_ALURes, exmem_nextPC;
   wire [2:0] exmem_writeReg;
   wire exmem_regWrite, exmem_memToReg, exmem_memRead, exmem_memWrite, exmem_halt;

   wire [15:0] memwb_memData, memwb_ALUData, memwb_nextPC;
   wire [2:0] memwb_writereg;
   wire memwb_memToReg, memwb_regWrite, memwb_halt, jalr, willBranch, stalled_memRead;
  
   wire [1:0] decodeForward;
   assign err = fetchErr | decodeErr | executeErr | memoryErr | writeBackErr;

   fetch fetch0(.clk(clk), .rst(rst), .pcWrite(pcWrite), .halt(idex_halt), .nextPC(dec_nextPC), .PC2(PC), .instr(instr), .err(fetchErr), .stall(fetch_stall));

   IFID ifidReg(.clk(clk), .rst(rst), .ifid_write(ifid_write & ~fetch_stall), .PC(PC), .addr(instr), .PCout(ifidPC), .addrOut(ifidAddr), .flush(flush), .stall(fetch_stall), .stallOut(ifid_stall));

   decode decode0(.clk(clk), .rst(rst), .instr(ifidAddr), .PC(ifidPC), .linkPC(memwb_nextPC), .writeBackData(writeBackData), .writeregIn(memwb_writereg), .regWriteIn(~memwb_halt & memwb_regWrite),  .readdata1(readdata1), .readdata2(readdata2), .immediate(immediate), .jump(jump), .jumpReg(jumpReg), .branch(branch), .branchOp(branchOp), .memRead(memRead), .memWrite(memWrite), .memToReg(memToReg), .ALUOp(ALUOp), .ALUSrc(ALUSrc), .invSrc1(invSrc1), .invSrc2(invSrc2), .sub(sub), .halt(halt), .passthrough(passthrough), .reverse(reverse), .writereg(writereg), .regWrite(regWrite), .rs(rs), .rt(rt), .nextPC(dec_nextPC), .err(decodeErr), .regDstIn(memwb_regDst), .regDstOut(regDstOut), .flush(flush), .jalr(jalr), .willBranch(willBranch), .stall(ifid_stall));

   hazard haz(.idex_memRead(idex_memRead), .idex_rt(idex_rt), .ifid_rs(rs), .ifid_rt(rt), .ifid_write(ifid_write), .pcWrite(pcWrite), .stall(stall), .jalr(jalr | jumpReg), .idex_writereg(idex_writereg), .exmem_writereg(exmem_writeReg), .memwb_writereg(memwb_writereg), .willBranch(branch), .idex_PC(idex_PC), .exmem_PC(exmem_nextPC), .memwb_PC(memwb_nextPC), .ifid_PC(ifidPC), .idex_regWrite(idex_regWrite), .exmem_regWrite(exmem_regWrite), .memwb_regWrite(memwb_regWrite));

   assign stalled_regWrite = (stall | fetch_stall) ? 1'b0 : regWrite;
   assign stalled_memWrite = (stall | fetch_stall) ? 1'b0 : memWrite;
   assign stalled_memToReg = (stall | fetch_stall) ? 1'b0 : memToReg;
   assign stalled_memRead =  (stall | fetch_stall) ? 1'b0 : memRead;  

   IDEX idexReg(.clk(clk), .rst(rst), 
    .readdata1(readdata1), .readdata2(readdata2), .immediate(immediate), .PC(ifidPC), .jump(jump), .jumpReg(jumpReg), .branch(branch), .branchOp(branchOp), .memRead(stalled_memRead), .memWrite(stalled_memWrite), .memToReg(stalled_memToReg), .ALUOp(ALUOp), .ALUSrc(ALUSrc), .invSrc1(invSrc1), .invSrc2(invSrc2), .sub(sub), .passthrough(passthrough), .reverse(reverse), .writereg(writereg), .regWrite(stalled_regWrite), .halt(halt), .rs(rs), .rt(rt),
    .readdata1Out(idex_readdata1), .readdata2Out(idex_readdata2), .immediateOut(idex_immediate), .jumpOut(idex_jump), .jumpRegOut(idex_jumpReg), .branchOut(idex_branch), .branchOpOut(idex_branchOp), .memReadOut(idex_memRead), .memWriteOut(idex_memWrite), .memToRegOut(idex_memToReg), .ALUOpOut(idex_ALUOp), .ALUSrcOut(idex_ALUSrc), .invSrc1Out(idex_invSrc1), .invSrc2Out(idex_invSrc2), .subOut(idex_sub), .passthroughOut(idex_passthrough), .reverseOut(idex_reverse), .writeregOut(idex_writereg), .PCOut(idex_PC), .regWriteOut(idex_regWrite), .haltOut(idex_halt), .rsOut(idex_rs), .rtOut(idex_rt), .regDst(regDstOut), .regDstOut(idex_regDst));

   forwarding forward(.idex_rs(idex_rs), .idex_rt(idex_rt), .exmem_rd(exmem_writeReg), .memwb_rd(memwb_writereg), .exmem_regWrite(exmem_regWrite), .memwb_regWrite(memwb_regWrite), .exmem_regDst(exmem_regDst), .memwb_regDst(memwb_regDst), .forwardA(forwardA), .forwardB(forwardB));

   execute ex0(.readdata1(idex_readdata1), .readdata2(idex_readdata2), .immediate(idex_immediate), .BranchOP(idex_branchOp), .ALUOp(idex_ALUOp), .ALUSrc(idex_ALUSrc), .invSrc1(idex_invSrc1), .invSrc2(idex_invSrc2), .sub(idex_sub), .PC(idex_PC), .jump(idex_jump), .jumpReg(idex_jumpReg), .branch(idex_branch), .nextPC(nextPC), .ALURes(ALURes), .passthrough(idex_passthrough), .reverse(idex_reverse), .exmem_ALURes(exmem_ALURes), .memwb_writeBack(writeBackData), .forwardA(forwardA), .forwardB(forwardB), .rt(ex_writeData), .err(executeErr), .exmem_nextPC(exmem_nextPC), .memwb_nextPC(memwb_nextPC));

   EXMEM exmemReg(.clk(clk), .rst(rst), .readData2(ex_writeData), .ALURes(ALURes), .nextPC(idex_PC), .writeReg(idex_writereg), .regWrite(idex_regWrite), .memToReg(idex_memToReg), .memRead(idex_memRead), .memWrite(idex_memWrite), .halt(idex_halt), .readData2Out(exmem_readData2), .ALUResOut(exmem_ALURes), .nextPCOut(exmem_nextPC), .writeRegOut(exmem_writeReg), .regWriteOut(exmem_regWrite), .memToRegOut(exmem_memToReg), .memReadOut(exmem_memRead), .memWriteOut(exmem_memWrite), .haltOut(exmem_halt), .regDst(idex_regDst), .regDstOut(exmem_regDst));

   memory memory0(.clk(clk), .rst(rst), .addr(exmem_ALURes), .writeData(exmem_readData2), .memWrite(exmem_memWrite), .memRead(exmem_memRead), .halt(exmem_halt), .readData(readData), .err(memoryErr));

   MEMWB memwbReg(.clk(clk), .rst(rst), .memData(readData), .ALUData(exmem_ALURes), .memToReg(exmem_memToReg), .regWrite(exmem_regWrite), .writereg(exmem_writeReg), .halt(exmem_halt), .memDataOut(memwb_memData), .ALUDataOut(memwb_ALUData), .memToRegOut(memwb_memToReg), .regWriteOut(memwb_regWrite), .writeregOut(memwb_writereg), .haltOut(memwb_halt), .regDst(exmem_regDst), .regDstOut(memwb_regDst), .nextPC(exmem_nextPC), .nextPCOut(memwb_nextPC));

   writeBack wb0(.memData(memwb_memData), .ALUData(memwb_ALUData), .memToReg(memwb_memToReg), .writeBackData(writeBackData), .err(writeBackErr));
   
endmodule // proc
// DUMMY LINE FOR REV CONTROL :0:
