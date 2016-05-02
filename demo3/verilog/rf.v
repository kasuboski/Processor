/* $Author: karu $ */
/* $LastChangedDate: 2009-03-04 23:09:45 -0600 (Wed, 04 Mar 2009) $ */
/* $Rev: 45 $ */
module rf (
           // Outputs
           read1data, read2data, err,
           // Inputs
           clk, rst, read1regsel, read2regsel, writeregsel, writedata, write
           );
   input clk, rst;
   input [2:0] read1regsel;
   input [2:0] read2regsel;
   input [2:0] writeregsel;
   input [15:0] writedata;
   input        write;

   output reg [15:0] read1data;
   output reg [15:0] read2data;
   output        err;
  
   wire [15:0] r7in, r6in, r5in, r4in, r3in, r2in, r1in, r0in;
   wire [15:0] r7out, r6out, r5out, r4out, r3out, r2out, r1out, r0out;

   assign err = 1'b0;

   assign r7in = ((writeregsel == 3'd7) & write) ? writedata : r7out;
   assign r6in = ((writeregsel == 3'd6) & write) ? writedata : r6out;
   assign r5in = ((writeregsel == 3'd5) & write) ? writedata : r5out;
   assign r4in = ((writeregsel == 3'd4) & write) ? writedata : r4out;
   assign r3in = ((writeregsel == 3'd3) & write) ? writedata : r3out;
   assign r2in = ((writeregsel == 3'd2) & write) ? writedata : r2out;
   assign r1in = ((writeregsel == 3'd1) & write) ? writedata : r1out;
   assign r0in = ((writeregsel == 3'd0) & write) ? writedata : r0out;

   always @(*) begin
      case(read1regsel)
         3'd7:
	   read1data = r7out;
         3'd6:
           read1data = r6out;
         3'd5:
           read1data = r5out;
         3'd4:
	   read1data = r4out;
         3'd3:
           read1data = r3out;
         3'd2:
           read1data = r2out;
         3'd1:
           read1data = r1out;
         3'd0:
           read1data = r0out; 
      endcase
   end

   always @(*) begin
      case(read2regsel)
         3'd7:
	   read2data = r7out;
         3'd6:
           read2data = r6out;
         3'd5:
           read2data = r5out;
         3'd4:
	   read2data = r4out;
         3'd3:
           read2data = r3out;
         3'd2:
           read2data = r2out;
         3'd1:
           read2data = r1out;
         3'd0:
           read2data = r0out; 
      endcase
   end

   register r7(.in(r7in), .clk(clk), .rst(rst),  .out(r7out));
   register r6(.in(r6in), .clk(clk), .rst(rst),  .out(r6out));
   register r5(.in(r5in), .clk(clk), .rst(rst),  .out(r5out));
   register r4(.in(r4in), .clk(clk), .rst(rst),  .out(r4out));
   register r3(.in(r3in), .clk(clk), .rst(rst),  .out(r3out));
   register r2(.in(r2in), .clk(clk), .rst(rst),  .out(r2out));
   register r1(.in(r1in), .clk(clk), .rst(rst),  .out(r1out));
   register r0(.in(r0in), .clk(clk), .rst(rst),  .out(r0out));


endmodule
// DUMMY LINE FOR REV CONTROL :1:
