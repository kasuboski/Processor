module alu (A, B, Cin, Op, passthrough, reverse, invA, invB, sign, Out, Ofl, zero);
   
    input [15:0] A;
    input [15:0] B;
    input Cin;
    
    input [3:0] Op;
    input passthrough, reverse;
    input invA;
    input invB;
    input sign;
    output reg [15:0] Out;
    output Ofl;
    output zero;

    wire [15:0] A_inv;
    wire [15:0] B_inv;
    wire [15:0] shift_out;
    wire overflow, Cout;
    wire [15:0] sum;
    wire equal;
	
    assign A_inv = invA ? ~A : A;
    assign B_inv = invB ? ~B : B;

    assign zero = ~(|Out);
    assign Ofl = (sign ? overflow : Cout) & Op[2] & ~Op[1] & ~Op[0];
	
	assign equal = (A_inv == B_inv);
	
    /*****************************
    * Shifter Op Codes
    * 000 = ROL
    * 001 = ROR
    * 010 = SLL
    * 011 = SRA
    * 100 = SRL
    *****************************/
    shifter shift(.In(A_inv), .Cnt(B_inv[3:0]), .Op(Op[2:0]), .Out(shift_out));
    adder add(.A(A_inv), .B(B_inv), .Cin(Cin), .Overflow(overflow), .Cout(Cout), .Sum(sum));
 
    always @(*) begin
        casex({Op, passthrough, reverse})
	    6'bxxxx_x_1: Out = {A[0], A[1], A[2], A[3], A[4], A[5], A[6], A[7], A[8], A[9], A[10], A[11], A[12], A[13], A[14], A[15]};
            6'bxxxx_1_x: Out = B;
            6'b0xxx_0_x:
                Out = shift_out;
            6'b1000_0_x:
                Out = sum;
            6'b1001_0_x:
                Out = {A[7:0], B[7:0]};
            6'b1010_0_x:
                Out = A_inv ^ B_inv;
            6'b1011_0_x:
                Out = A_inv & B_inv;
            
            //SCO
            6'b1100_0_x: 
            	Out = {{15{1'b0}}, Cout};
            
            //SLE
            6'b1101_0_x:
            	Out =  {{15{1'b0}} ,(equal | $signed(A)<$signed(B))};
            
            //SLT
            6'b1110_0_x:
            	Out = {{15{1'b0}}, $signed(A)<$signed(B)};
            	
            //SEQ
            6'b1111_0_x:
            	Out = {{15{1'b0}}, equal};
            	
            default:
                Out = 16'hXXXX;
        endcase
    end
endmodule
