// module polyCal (x, y, d);
module polyCal (x, y, d);
    input [7:0] x, y;
    output [7:0] d;
    wire [7:0] f0, f1, f2, f3, f4, f5, f6, f7;
    wire [7:0] h0, h1, h2, h3, h4, h5, h6, h7;
    parameter fx = 8'h1B;

    assign h0 = x;
    assign h1 = (h0[7])? (h0 << 1) ^ fx : (h0 << 1);
    assign h2 = (h1[7])? (h1 << 1) ^ fx : (h1 << 1);
    assign h3 = (h2[7])? (h2 << 1) ^ fx : (h2 << 1);
    assign h4 = (h3[7])? (h3 << 1) ^ fx : (h3 << 1);
    assign h5 = (h4[7])? (h4 << 1) ^ fx : (h4 << 1);
    assign h6 = (h5[7])? (h5 << 1) ^ fx : (h5 << 1);
    assign h7 = (h6[7])? (h6 << 1) ^ fx : (h6 << 1);

    assign f0 = (y[0])? h0 : 0;
    assign f1 = (y[1])? h1 : 0;
    assign f2 = (y[2])? h2 : 0;
    assign f3 = (y[3])? h3 : 0;
    assign f4 = (y[4])? h4 : 0;
    assign f5 = (y[5])? h5 : 0;
    assign f6 = (y[6])? h6 : 0;
    assign f7 = (y[7])? h7 : 0;
    assign d = f0 ^ f1 ^ f2 ^ f3 ^ f4 ^ f5 ^ f6 ^ f7;

endmodule
