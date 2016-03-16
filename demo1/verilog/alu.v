module alu (A, B, Cin, Op, invA, invB, sign, Out, Ofl, Z);
   
    input [15:0] A;
    input [15:0] B;
    input Cin;
    input [2:0] Op;
    input invA;
    input invB;
    input sign;
    output reg [15:0] Out;
    output Ofl;
    output Z;

    wire [15:0] A_inv;
    wire [15:0] B_inv;
    wire [15:0] shift_out;
    wire overflow, Cout;
    wire [15:0] sum;

    assign A_inv = invA ? ~A : A;
    assign B_inv = invB ? ~B : B;

    assign zero = ~(|Out);
    assign Ofl = (sign ? overflow : Cout) & Op[2] & ~Op[1] & ~Op[0];

    shifter shift(.In(A_inv), .Cnt(B_inv[3:0]), .Op(Op[1:0]), .Out(shift_out));
    adder add(.A(A_inv), .B(B_inv), .Cin(Cin), .Overflow(overflow), .Cout(cout), .Sum(sum));
    
    always @(*) begin
        casex(Op)
            3'b0xx:
                Out = shift_out;
            3'b100:
                Out = sum;
            3'b101:
                Out = A_inv | B_inv;
            3'b110:
                Out = A_inv ^ B_inv;
            3'b111:
                Out = A_inv & B_inv;
            default:
                Out = 16'hXXXX;
        endcase
    end
endmodule
