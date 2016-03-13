module fetch(clk, rst, halt, nextPC, instr, err);
    input clk, rst;
    
    input halt;
    input [15:0] nextPC;

    output [15:0] instr;
    output err;

    wire [15:0] currentPC;

    assign err = 1'b0;

    dff pc(.q(nextPC), .d(currentPC), .clk(clk), .rst(rst));
    memory2c instrmem(.data_out(instr), .data_in(16'b0), .addr(currentPC), .enable(~halt), .wr(1'b0), .createdump(1'b0), .clk(clk), .rst(rst));

endmodule
