module comparator_tb();

 reg [15:0] A, B;
 reg clk;
 wire out;
 
 comparator iDUT(.A(A), .B(B), .out(out));
 initial begin
   clk = 0;
   A = 16'h7fff;
   B = 16'h8000;
 end
 
 always @(posedge clk) begin
 	if((($signed(A) > $signed(B)) &&  !out) || (($signed(A) < $signed(B)) && out)) begin
 		$display("Somethings wrong\n");
 		$stop;	
 	end
 	
 	else if(A == 16'h8000) begin
 		$display("Success!\n");
 		$stop;
 	end
 	
 	A = A-1;
 	B = B + 1;
 end
 
 always #5 clk = ~clk;
endmodule