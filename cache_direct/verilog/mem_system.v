/* $Author: karu $ */
/* $LastChangedDate: 2009-04-24 09:28:13 -0500 (Fri, 24 Apr 2009) $ */
/* $Rev: 77 $ */

module mem_system(/*AUTOARG*/
   // Outputs
   DataOut, Done, Stall, CacheHit, err,
   // Inputs
   Addr, DataIn, Rd, Wr, createdump, clk, rst
   );
   
   input [15:0] Addr;
   input [15:0] DataIn;
   input        Rd;
   input        Wr;
   input        createdump;
   input        clk;
   input        rst;
   
   output [15:0] DataOut;
   output Done;
   output Stall;
   output CacheHit;
   output err;

   /* data_mem = 1, inst_mem = 0 *
    * needed for cache parameter */
   parameter mem_type = 0;
   cache (0 + memtype) c0(// Outputs
                          .tag_out              (),
                          .data_out             (),
                          .hit                  (hit),
                          .dirty                (dirty),
                          .valid                (valid),
                          .err                  (),
                          // Inputs
                          .enable               (),
                          .clk                  (),
                          .rst                  (),
                          .createdump           (),
                          .tag_in               (),
                          .index                (),
                          .offset               (),
                          .data_in              (),
                          .comp                 (),
                          .write                (),
                          .valid_in             ());

   four_bank_mem mem(// Outputs
                     .data_out          (),
                     .stall             (mem_stall),
                     .busy              (),
                     .err               (),
                     // Inputs
                     .clk               (),
                     .rst               (),
                     .createdump        (),
                     .addr              (),
                     .data_in           (),
                     .wr                (),
                     .rd                ());

   
   // your code here
   


   	//State machine

   	/*************************************************
   	* State definitions
   	* 4'b0000 = IDLE
   	* 4'b0001 = Compare
   	* 4'b0010 = Hit
   	* 4'b0011 = Miss Read Request 1
   	* 4'b0100 = Miss Read Request 2
   	* 4'b0101 = Read 1
   	* 4'b0110 = Read 2
   	* 4'b0111 = Miss Read Request 3
   	* 4'b1000 = Miss Read Request 4
   	* 4'b1001 = Read 3
   	* 4'b1010 = Read 4
   	* 4'b1011 = Write 1
   	* 4'b1100 = Write 2
   	* 4'b1101 = Write 3
  	* 4'b1110 = Write 4
	*************************************************/
	reg [3:0] state, next_state; 
 	wire hit, dirty, valid, mem_stall;
 
   	dff SM_Flops [3:0] (.q(state), .d(next_state), .clk(clk), .rst(rst));


	assign next_state = ((state == 4'b0) & ~Rd & ~Wr)) ? 4'b0 : 
			    ((state == 4'b0) & (Wr | Rd))  ? 4'b1 : 
			    ((state == 4'b1) & (valid & hit)) ? 4'b0010 : 
			    ((state == 4'b1) & (~hit & ~ dirty)) ? 4'b0011 :
			    ((state == 4'b1) & (~hit & dirty)) ? 4'b1011 :
			    ((state == 4'b0010) & (Rd | Wr)) ? 4'b1 : 
			    ((state == 4'b0010) & ~(Rd | Wr)) ? 4'b0 :
			    ((state == 4'b0011) & mem_stall) ? 4'b0011 :
			    ((state == 4'b0011) & ~mem_stall) ? 4'b0100 : 
			    ((state == 4'b0100) & mem_stall) ? 4'b0100 :
			    ((state == 4'b0100) & ~mem_stall) ? 4'b0101 : 
			    (state == 4'b0101) ? 4'b0110 : 
			    (state == 4'b0110) ? 4'b0111 : 
			    ((state == 4'b0111) & mem_stall) ? 4'b0111 : 
			    ((state == 4'b0111) & ~mem_stall) ? 4'b1000 : 
			    ((state == 4'b1000) & mem_stall) ? 4'b1000 : 
			    ((state == 4'b1000) & ~mem_stall) ? 4'b1001 :
		   	    (state == 4'b1001) ? 4'b1010 : 
			    (state == 4'b1010) ? 4'b0 :  //Might want to add transition from Read 4 right to Compare again
			    ((state == 4'b1011) & mem_stall) ? 4'b1011 : 
			    ((state == 4'b1011) & ~mem_stall) ? 4'b1100 : 
			    ((state == 4'b1100) & mem_stall) ? 4'b1100 :
			    ((state == 4'b1100) & ~mem_stall) ? 4'b1101 :
			    ((state == 4'b1101) & mem_stall) ? 4'b1101 :
			    ((state == 4'b1101) & ~mem_stall) ? 4'b1110 : 
			    ((state == 4'b1110) & mem_stall) ? 4'b1110 :
			    ((state == 4'b1110) & ~mem_stall) ? 4'b0011 :
			    4'b0;  			   
 
	always @(*) begin
	
		casex(state)

			//Compare state
			4'b0001: begin

			end

			//Hit State
			4'b0010: begin

			end
			
			//Miss Read Request 1 State
			4'b0011: begin

			end
			
			//Miss Read Request 2 State
			4'b0100: begin

			end

			//Read 1 State
			4'b0101: begin

			end

			//Read 2 State
			4'b0110: begin

			end

			//Miss Read Request 3 State
			4'b0111: begin

			end

			//Miss Read Request 4 State
			4'b1000: begin

			end

			//Read 3 State
			4'b1001: begin

			end

			//Read 4 State
			4'b1010: begin

			end

			//Write 1 State
			4'b1011: begin

			end
		
			//Write 2 State
			4'b1100: begin


			end

			//Write 3 State
			4'b1101: begin

			end

			//Write 4 State
			4'b1110: begin

			end

			//Idle State
			default: begin
				
				
			end 
		endcase
	end
 
endmodule // mem_system

// DUMMY LINE FOR REV CONTROL :9:
