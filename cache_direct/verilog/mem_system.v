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
   output reg Done;
   output Stall;
   output CacheHit;
   output err;



	wire [15:0] memDataOut;
	wire [3:0] state;
	wire [3:0] memBusy;
	reg [2:0] memOffset; 
	reg enable, compare, cacheWrite, memRead, memWrite;
 	wire  dirty, valid, mem_stall, cacheErr, memErr;
 	reg [15:0] cacheAddr, cacheDataIn, memDataIn;
	wire [4:0] cacheTagOut;
	wire [15:0] memAddr;
	reg [4:0] memTag;
	wire [3:0] next_state;

   /* data_mem = 1, inst_mem = 0 *
    * needed for cache parameter */
   parameter mem_type = 0;
   cache #(0 + mem_type) c0(// Outputs
                          .tag_out              (cacheTagOut),
                          .data_out             (DataOut),
                          .hit                  (CacheHit),
                          .dirty                (dirty),
                          .valid                (valid),
                          .err                  (cacheErr),
                          // Inputs
                          .enable               (enable),
                          .clk                  (clk),
                          .rst                  (rst),
                          .createdump           (createdump),
                          .tag_in               (cacheAddr[15:11]),
                          .index                (cacheAddr[10:3]),
                          .offset               (cacheAddr[2:0]),
                          .data_in              (cacheDataIn),
                          .comp                 (compare),
                          .write                (cacheWrite),
                          .valid_in             (1'b1));

   four_bank_mem mem(// Outputs
                     .data_out          (memDataOut),
                     .stall             (mem_stall),
                     .busy              (memBusy),
                     .err               (memErr),
                     // Inputs
                     .clk               (clk),
                     .rst               (rst),
                     .createdump        (createdump),
                     .addr              (memAddr),
                     .data_in           (memDataIn),
                     .wr                (memWrite),
                     .rd                (memRead));

   
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
   	dff SM_Flops [3:0] (.q(state), .d(next_state), .clk(clk), .rst(rst));

	assign Stall = (~Done & (state != 4'b0));	
	assign memAddr = {memTag, cacheAddr[11:3], memOffset};
	assign err = cacheErr | memErr;
	assign next_state = ((state == 4'b0) & ~Rd & ~Wr) ? 4'b0 : 
			    ((state == 4'b0) & (Wr | Rd))  ? 4'b1 : 
			    ((state == 4'b1) & (valid & CacheHit)) ? 4'b0010 : 
			    ((state == 4'b1) & (~CacheHit & ~ dirty)) ? 4'b0011 :
			    ((state == 4'b1) & (~CacheHit & dirty)) ? 4'b1011 :
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
			    ((state == 4'b1010) & (Rd | Wr)) ? 4'b0001 : 
			    ((state == 4'b1010) & ~(Rd | Wr)) ? 4'b0 :  
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
		
		enable = 1'b1;
		Done = 1'b0;
		compare = 1'b0;
		memOffset = 3'b0;
		cacheAddr = Addr;
		cacheDataIn = DataIn;
		cacheWrite = 1'b0;
		memDataIn = DataOut;		
		memWrite = 1'b0;
		memRead = 1'b0;
		memTag = cacheAddr[15:11];
		casex(state)

			//Compare state
			4'b0001: begin
				compare = 1'b1;
				cacheWrite = Wr & ~Rd;	
			end

			//Hit State
			4'b0010: begin
				Done = 1'b1;	
			end
			
			//Miss Read Request 1 State
			4'b0011: begin
				memOffset = 3'b0;
				memRead = 1'b1;			
			end
			
			//Miss Read Request 2 State
			4'b0100: begin

				memOffset = 3'b010;
				memRead = 1'b1;			
			end

			//Read 1 State
			4'b0101: begin
				cacheWrite = 1'b1;
				memOffset = 3'b0;
				cacheAddr = memAddr;	
				cacheDataIn = memDataOut; 	
			end

			//Read 2 State
			4'b0110: begin
				cacheAddr = memAddr;
				memOffset = 3'b010;
				cacheWrite = 1'b1;
				cacheDataIn = memDataOut; 	
			end

			//Miss Read Request 3 State
			4'b0111: begin

				memOffset = 3'b100;
				memRead = 1'b1;			
			end

			//Miss Read Request 4 State
			4'b1000: begin

				memOffset = 3'b110;
				memRead = 1'b1;			
			end

			//Read 3 State
			4'b1001: begin
				
				cacheWrite = 1'b1;
				memOffset = 3'b100;
				cacheAddr = memAddr;	
				cacheDataIn = memDataOut; 	
			end

			//Read 4 State
			4'b1010: begin

				cacheWrite = 1'b1;
				memOffset = 3'b110;
				cacheAddr = memAddr;	
				cacheDataIn = memDataOut; 	
			end

			//Write 1 State
			4'b1011: begin
				memWrite = 1'b1;
				memOffset = 3'b0;
				
				memTag = cacheTagOut;
					
			end
		
			//Write 2 State
			4'b1100: begin

				memWrite = 1'b1;
				memOffset = 3'b010;
				
				memTag = cacheTagOut;

			end

			//Write 3 State
			4'b1101: begin

				memWrite = 1'b1;
				memOffset = 3'b100;
				
				memTag = cacheTagOut;
			end

			//Write 4 State
			4'b1110: begin

				memWrite = 1'b1;
				memOffset = 3'b110;
				
				memTag = cacheTagOut;
			end

			//Idle State
			default: begin
				enable = 1'b0;			
			end 
		endcase
	end
 
endmodule // mem_system

// DUMMY LINE FOR REV CONTROL :9:
