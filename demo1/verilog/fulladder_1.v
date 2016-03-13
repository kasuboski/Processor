module fulladder_1(A, B, Cin, p, g, S);
    input A, B, Cin;
    output p, g, S;
    
    wire AxorB;

    assign p = AxorB;
    assign g = A & B;

    assign AxorB = A^B;
    assign S = Cin ^ AxorB;

endmodule
