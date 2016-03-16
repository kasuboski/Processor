module comparator_tb();

 reg [15:0] A, B;
 reg clk, out;
 
 initial begin
   clk = 0;
   A = 16'hffff;
   B = 16'h0000;
 end
 
 always @(#5 posedge clk) begin
 
 
 end
 
 always #5 clk = ~clk;
endmodule