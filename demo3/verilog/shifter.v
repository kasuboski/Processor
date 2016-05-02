module shifter (In, Cnt, Op, Out);
   
    input [15:0] In;
    input [3:0]  Cnt;
    input [2:0]  Op;
    output [15:0] Out;

    wire [15:0] sh1;
    wire [15:0] sh2;
    wire [15:0] sh3;
    wire [15:0] sh4;

    shifter_1 sh_1(.in(In), .op(Op), .sh(Cnt[0]), .out(sh1));
    shifter_2 sh_2(.in(sh1), .op(Op), .sh(Cnt[1]), .out(sh2));
    shifter_4 sh_4(.in(sh2), .op(Op), .sh(Cnt[2]), .out(sh3));
    shifter_8 sh_8(.in(sh3), .op(Op), .sh(Cnt[3]), .out(Out));

endmodule

