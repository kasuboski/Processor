module comparator_tb();

 reg [15:0] A, B;
 reg clk;
 wire out;
 
 initial begin
   clk = 0;
   A = 16'hffff;
   B = 16'h0000;
 end
 
 always @(posedge clk) begin
 	if(((A > B) &&  !out) || ((A < B) && out))begin
 		$display("Somethings wrong\n");
 		$stop;	
 	end
 	
 	else if(A == 0) begin
 		$display("Success!\n");
 		$stop;
 	end
 	
 	A = A-1;
 	B = B + 1;
 end
 
 always #5 clk = ~clk;
endmodule