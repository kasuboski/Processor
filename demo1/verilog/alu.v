module alu (A, B, Cin, Op, invA, invB, sign, Out, Ofl, zero);
   
    input [15:0] A;
    input [15:0] B;
    input Cin;
    
    input [3:0] Op;
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
    wire equal, lt, gt, ltOfl, gtOfl, ltCout, gtCout, ltSum, gtSum;
	
    assign A_inv = invA ? ~A : A;
    assign B_inv = invB ? ~B : B;

    assign zero = ~(|Out);
    assign Ofl = (sign ? overflow : Cout) & Op[2] & ~Op[1] & ~Op[0];
	
	assign equal = ~(A_inv ^ B_inv);
	
    /*****************************
    * Shifter Op Codes
    * 000 = ROL
    * 001 = ROR
    * 010 = SLL
    * 011 = SRA
    * 100 = SRL
    *****************************/
    shifter shift(.In(A_inv), .Cnt(B_inv[3:0]), .Op(Op[2:0]), .Out(shift_out));
    adder add(.A(A_inv), .B(B_inv), .Cin(Cin), .Overflow(overflow), .Cout(cout), .Sum(sum));
    
    always @(*) begin
        casex(Op)
            4'b0xxx:
                Out = shift_out;
            4'b1000:
                Out = sum;
            4'b1001:
                Out = A_inv | B_inv;
            4'b1010:
                Out = A_inv ^ B_inv;
            4'b1011:
                Out = A_inv & B_inv;
            
            //SCO
            4'b1100: 
            	Out = {15{1'b0}, cout};
            
            //SLE
            4'b1101:
            	Out =  {15{1'b0} ,(equal | lt)};
            
            //SLT
            4'b1110:
            	Out = {15{1'b0}, lt};
            	
            //SEQ
            4'b1111:
            	Out = {15{1'b0}, equal};
            	
            default:
                Out = 16'hXXXX;
        endcase
    end
endmodule
