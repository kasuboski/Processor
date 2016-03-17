module writeBack(memData, ALUData, memToReg, writeBackData, err);

    input [15:0] memData;
    input [15:0] ALUData;
    input memToReg;
    
    output [15:0] writeBackData;

    output err;

    assign err = 1'b0;

    assign writeBackData = memToReg ? memData : ALUData;

endmodule
