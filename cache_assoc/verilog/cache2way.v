module cache2way(
              input enable,
              input clk,
              input rst,
              input createdump,
              input [4:0] tag_in,
              input [7:0] index,
              input [2:0] offset,
              input [15:0] data_in,
              input comp,
              input write,
              input valid_in,
	      input invert_victimway,

              output [4:0] tag_out,
              output [15:0] data_out,
              output hit,
              output dirty,
              output valid,
              output err

);
  
	wire [4:0] tag_out0, tag_out1;
	wire [15:0] data_out0, data_out1;
	wire hit0, hit1, dirty0, dirty1, valid0, valid1, err0, err1;

	wire write0, write1;

	wire victimway;
	wire selectedCache, selectedCacheIn;
	reg selectedCacheSel;

        /* data_mem = 1, inst_mem = 0 *
         * needed for cache parameter */
	parameter mem_type = 0;
	cache #(0 + mem_type) c0(// Outputs
                          .tag_out              (tag_out0),
                          .data_out             (data_out0),
                          .hit                  (hit0),
                          .dirty                (dirty0),
                          .valid                (valid0),
                          .err                  (err0),
                          // Inputs
                          .enable               (enable),
                          .clk                  (clk),
                          .rst                  (rst),
                          .createdump           (createdump),
                          .tag_in               (tag_in),
                          .index                (index),
                          .offset               (offset),
                          .data_in              (data_in),
                          .comp                 (comp),
                          .write                (write0),
                          .valid_in             (valid_in));


	cache #(2 + mem_type) c1(// Outputs
                          .tag_out              (tag_out1),
                          .data_out             (data_out1),
                          .hit                  (hit1),
                          .dirty                (dirty1),
                          .valid                (valid1),
                          .err                  (err1),
                          // Inputs
                          .enable               (enable),
                          .clk                  (clk),
                          .rst                  (rst),
                          .createdump           (createdump),
                          .tag_in               (tag_in),
                          .index                (index),
                          .offset               (offset),
                          .data_in              (data_in),
                          .comp                 (comp),
                          .write                (write1),
                          .valid_in             (valid_in));

	assign hit = ((hit1 & valid1) | (hit0 & valid0));
	assign valid = valid1 | valid0;
	assign dirty = hit ? (hit1 & valid1 ? dirty1 : dirty0) :
			 (comp ? (selectedCacheSel ? dirty1 : dirty0) : (selectedCache ? dirty1 : dirty0));
	assign data_out = hit ? (hit1 & valid1 ? data_out1 : data_out0) :
			 (comp ? (selectedCacheSel ? data_out1 : data_out0) : (selectedCache ? data_out1 : data_out0));

	assign tag_out = hit ? (hit1 & valid1 ? tag_out1 : tag_out0) :
			 (comp ? (selectedCacheSel ? tag_out1 : tag_out0) : (selectedCache ? tag_out1 : tag_out0));
	assign err = err0 | err1; 

	assign victimwayIn = invert_victimway ? ~victimway : victimway;
	dff victimway0(.q(victimway), .d(victimwayIn), .clk(clk), .rst(rst));
	
	assign write0 = hit0 & valid0 ? write : comp ? 1'b0 :  selectedCache ? 1'b0 : write;
	assign write1 = hit1 & valid1 ? write : comp ? 1'b0 :  selectedCache ? write : 1'b0;

	assign selectedCacheIn = comp ? selectedCacheSel : selectedCache;
	dff selectedCache0(.q(selectedCache), .d(selectedCacheIn), .clk(clk), .rst(rst));

	always @(hit0, hit1, valid0, valid1, victimway) begin
		casex({hit0, hit1, valid0, valid1})
		//cache 0 has a hit
		4'b1_0_x_x: selectedCacheSel = 1'b0;
		//cache 1 has a hit
		4'b0_1_x_x: selectedCacheSel = 1'b1;
		//in case of miss
		//one is valid
		//cache 0 is valid
		4'b0_0_1_0: selectedCacheSel = 1'b1;
		//cache 1 is valid
		4'b0_0_0_1: selectedCacheSel = 1'b0;
		//neither is valid
		4'b0_0_0_0: selectedCacheSel = 1'b0;
		//both are valid
		4'b0_0_1_1: selectedCacheSel = victimway;
		default: selectedCacheSel = 1'b0;
		endcase
	end

endmodule
