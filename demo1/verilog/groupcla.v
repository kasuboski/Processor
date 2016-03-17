module groupcla(p, g, Cin, c, pg, gg);
    input [3:0] p;
    input [3:0] g;
    input Cin;
    output [3:0] c;
    output pg, gg;

    assign c[0] = g[0] | (p[0] & Cin);
    assign c[1] = g[1] | (g[0] & p[1]) | (c[0] & p[0] & p[1]);
    assign c[2] = g[2] | (g[1] & p[2]) | (g[0] & p[1] & p[2]) | (c[0] & p[0] & p[1] & p[2]);
    assign c[3] = g[3] | (g[2] & p[3]) | (g[1] & p[2] & p[3]) | (g[0] & p[1] & p[2] & p[3]) | (c[0] & p[0] & p[1] & p[2] & p[3]);

    assign pg = p[0] & p[1] & p[2] & p[3];
    assign gg = g[3] | (g[2] & p[3]) | (g[1] & p[3] & p[2]) | (g[0] & p[3] & p[2] & p[1]);

endmodule
