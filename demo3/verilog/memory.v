module memory (clk, rst, addr, writeData, halt, memWrite, memRead, readData, err, stall);

    input clk, rst;
    input [15:0] addr, writeData;
    input memWrite, memRead, halt;

    output [15:0] readData;
    output err, stall;
    wire doneIn, memStall, done;
    assign err = 1'b0;

    //memory2c instrmem(.data_out(readData), .data_in(writeData), .addr(addr), .enable(~halt), .wr(memWrite), .createdump(halt), .clk(clk), .rst(rst));

    
    mem_system dcachemem(.DataOut(readData), .Done(done), .Stall(memStall), .CacheHit(), .err(), .Addr(addr), .DataIn(writeData), .Rd(memRead), .Wr(memWrite), .createdump(halt), .clk(clk), .rst(rst));

    //dff doneFF(.q(done), .d(doneIn), .clk(clk), .rst(rst));

    assign stall = ((memRead | memWrite) & ~done);
endmodule
