module cla_4(A, B, Cin, p, g, S, Cout);
    input [3:0] A, B;
    input Cin;
    output p, g;
    output Cout;
    output [3:0] S;

    wire p0, p1, p2, p3;
    wire g0, g1, g2, g3;

    wire c1, c2, c3;

    fulladder_1 fa1(.A(A[0]), .B(B[0]), .Cin(Cin), .p(p0), .g(g0), .S(S[0]));
    fulladder_1 fa2(.A(A[1]), .B(B[1]), .Cin(c1), .p(p1), .g(g1), .S(S[1]));
    fulladder_1 fa3(.A(A[2]), .B(B[2]), .Cin(c2), .p(p2), .g(g2), .S(S[2]));
    fulladder_1 fa4(.A(A[3]), .B(B[3]), .Cin(c3), .p(p3), .g(g3), .S(S[3]));

    groupcla cla(.p({p3, p2, p1, p0}), .g({g3, g2, g1, g0}), .Cin(Cin), .c({Cout, c3, c2, c1}), .pg(p), .gg(g));

endmodule
