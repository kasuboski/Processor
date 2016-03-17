module alu (A, B, Cin, Op, passthrough, invA, invB, sign, Out, Ofl, zero);
   
    input [15:0] A;
    input [15:0] B;
    input Cin;
    
    input [3:0] Op;
    input passthrough;
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
    wire equal, lt, gt;
	
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
    
    comparator gtComp(.A(A), .B(B), .out(gt));
    comparator ltComp(.A(B), .B(A), .out(lt));
    
    always @(*) begin
        casex({Op, passthrough})
            5'bxxxx_1: Out = B;
            5'b0xxx_0:
                Out = shift_out;
            5'b1000_0:
                Out = sum;
            5'b1001_0:
                Out = {A[7:0], B[7:0]};
            5'b1010_0:
                Out = A_inv ^ B_inv;
            5'b1011_0:
                Out = A_inv & B_inv;
            
            //SCO
            5'b1100_0: 
            	Out = {{15{1'b0}}, cout};
            
            //SLE
            5'b1101_0:
            	Out =  {{15{1'b0}} ,(equal | lt)};
            
            //SLT
            5'b1110_0:
            	Out = {{15{1'b0}}, lt};
            	
            //SEQ
            5'b1111_0:
            	Out = {{15{1'b0}}, equal};
            	
            default:
                Out = 16'hXXXX;
        endcase
    end
endmodule
