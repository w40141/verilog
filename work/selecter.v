module selector (x, y, s, d);
    input x, y, s;
    output d;

    assign d = (x & s) | (y & ~s);
endmodule
