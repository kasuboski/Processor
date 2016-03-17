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
   wire invSrc1, invSrc2, sub, halt, passthrough;
   wire [15:0] ALURes;
   wire [15:0] readData;

   wire fetchErr, decodeErr, executeErr, memoryErr, writeBackErr;

   assign err = fetchErr | decodeErr | executeErr | memoryErr | writeBackErr;

   fetch fetch0(.clk(clk), .rst(rst), .halt(halt), .nextPC(nextPC), .PC2(PC), .instr(instr), .err(fetchErr));

   decode decode0(.clk(clk), .rst(rst), .instr(instr), .PC(PC), .writeBackData(writeBackData), .readdata1(readdata1), .readdata2(readdata2), .immediate(immediate), .jump(jump), .jumpReg(jumpReg), .branch(branch), .branchOp(branchOp), .memRead(memRead), .memWrite(memWrite), .memToReg(memToReg), .ALUOp(ALUOp), .ALUSrc(ALUSrc), .invSrc1(invSrc1), .invSrc2(invSrc2), .sub(sub), .halt(halt), .passthrough(passthrough), .err(decodeErr));

   execute ex0(.readdata1(readdata1), .readdata2(readdata2), .immediate(immediate), .BranchOP(branchOp), .ALUOp(ALUOp), .ALUSrc(ALUSrc), .invSrc1(invSrc1), .invSrc2(invSrc2), .sub(sub), .PC(PC), .jump(jump), .jumpReg(jumpReg), .branch(branch), .nextPC(nextPC), .ALURes(ALURes), .passthrough(passthrough), .err(executeErr));

   memory memory0(.clk(clk), .rst(rst), .addr(ALURes), .writeData(readdata2), .memWrite(memWrite), .memRead(memRead), .halt(halt), .readData(readData), .err(memoryErr));

   writeBack wb0(.memData(readData), .ALUData(ALURes), .memToReg(memToReg), .writeBackData(writeBackData), .err(writeBackErr));
   
endmodule // proc
// DUMMY LINE FOR REV CONTROL :0:
