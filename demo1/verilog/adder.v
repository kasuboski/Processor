module adder(A, B, Cin, Overflow, Cout, Sum);
    input [15:0] A, B;
    input Cin;
    output Overflow, Cout;
    output [15:0] Sum;

    wire p0, p4, p8, p12;
    wire g0, g4, g8, g12;
    wire c4, c8, c12;

    cla_4 add1(.A(A[15:12]), .B(B[15:12]), .Cin(c12), .p(p12), .g(g12), .S(Sum[15:12]), .Cout());
    cla_4 add2(.A(A[11:8]), .B(B[11:8]), .Cin(c8), .p(p8), .g(g8), .S(Sum[11:8]), .Cout());
    cla_4 add3(.A(A[7:4]), .B(B[7:4]), .Cin(c4), .p(p4), .g(g4), .S(Sum[7:4]), .Cout());
    cla_4 add4(.A(A[3:0]), .B(B[3:0]), .Cin(Cin), .p(p0), .g(g0), .S(Sum[3:0]), .Cout());

    assign Overflow = Cout ^ Sum[15]^A[15]^B[15];

    groupcla cla(.p({p12, p8, p4, p0}), .g({g12, g8, g4, g0}), .Cin(Cin), .c({Cout, c12, c8,c4}), .pg(), .gg());

endmodule
