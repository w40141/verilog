module SEL(A, B, C, D, SEL, OUT);
    input A, B, C, D;
    input [1:0] SEL;
    output OUT;
    assign OUT = (SEL[1] == 0)? ((SEL[0] == 0)? A : B) : ((SEL[0] == 0)? C : D);
endmodule
