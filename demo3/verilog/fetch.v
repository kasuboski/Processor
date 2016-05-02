module fetch(clk, rst, pcWrite, halt, nextPC, PC2, instr, err, stall);
    input clk, rst;
    
    input halt, pcWrite, stall;
    input [15:0] nextPC;

    output [15:0] instr;
    output [15:0] PC2; // currentPC + 2
    
    output err;

    wire [15:0] currentPC, actualNextPC;

    assign err = 1'b0;

    assign actualNextPC = pcWrite ? nextPC : currentPC;

    dff pc[15:0](.q(currentPC), .d(actualNextPC), .clk(clk), .rst(rst));
//    memory2c instrmem(.data_out(instr), .data_in(16'b0), .addr(actualNextPC), .enable(1'b1), .wr(1'b0), .createdump(1'b0), .clk(clk), .rst(rst));

    stallmem stallinstrmem(.DataOut(instr), .Done(), .Stall(stall), .CacheHit(), .err(), .Addr(actualNextPC), .DataIn(16'b0), .Rd(1'b1), .Wr(1'b0), .createdump(1'b0), .clk(clk), .rst(rst));

    adder pcAdd(.A(actualNextPC), .B(16'd2), .Cin(1'b0), .Overflow(), .Cout(), .Sum(PC2));

endmodule
