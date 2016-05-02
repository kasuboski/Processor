module IFID(clk, rst, ifid_write, PC, addr, PCout, addrOut, flush, stall, stallOut);
    input clk, rst;
    input ifid_write, flush, stall;
    input [15:0] PC, addr;

    output [15:0] PCout, addrOut;
    output stallOut;

    wire [15:0] updatedPC,updatedaddr, addr;

    assign updatedPC =  ifid_write ? PC : PCout;
    assign updatedaddr = ifid_write ? addr : addrOut;
        

    dff pc[15:0](.q(PCout), .d(updatedPC), .clk(clk), .rst(rst));
    dff address[15:0](.q(addrOut), .d(updatedaddr), .clk(clk), .rst(rst));
    dff stallFF(.q(stallOut), .d(stall), .clk(clk), .rst(rst));
endmodule
