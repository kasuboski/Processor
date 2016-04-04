module memory (clk, rst, addr, writeData, halt, memWrite, memRead, readData, err);

    input clk, rst;
    input [15:0] addr, writeData;
    input memWrite, memRead, halt;

    output [15:0] readData;
    output err;

    assign err = 1'b0;

    memory2c instrmem(.data_out(readData), .data_in(writeData), .addr(addr), .enable(~halt), .wr(memWrite), .createdump(halt), .clk(clk), .rst(rst));

endmodule
