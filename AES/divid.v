module divid32to8 (word, w0, w1, w2, w3);
    input [31:0] word;
    output [7:0] w0, w1, w2, w3;

    assign w0 = word[ 7: 0];
    assign w1 = word[15: 8];
    assign w2 = word[23:16];
    assign w3 = word[31:24];
endmodule


module divid128to32 (word, w0, w1, w2, w3);
    input [127:0] word;
    output [31:0] w0, w1, w2, w3;

    assign w0 = word[ 31: 0];
    assign w1 = word[ 63:32];
    assign w2 = word[ 95:64];
    assign w3 = word[127:96];
endmodule
