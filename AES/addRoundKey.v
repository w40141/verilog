module addRoundKey128 (word, key, str);
    input  [127:0] word, key;
    output [127:0] str;
    wire   [31:0] w0, w1, w2, w3;
    wire   [31:0] k0, k1, k2, k3;
    wire   [31:0] s0, s1, s2, s3;

    assign w0 = word[ 31: 0];
    assign w1 = word[ 63:32];
    assign w2 = word[ 95:64];
    assign w3 = word[127:96];

    assign k0 =  key[ 31: 0];
    assign k1 =  key[ 63:32];
    assign k2 =  key[ 95:64];
    assign k3 =  key[127:96];

    addRoundKey32 add0(w0, k0, s0);
    addRoundKey32 add1(w1, k1, s1);
    addRoundKey32 add2(w2, k2, s2);
    addRoundKey32 add3(w3, k3, s3);

    assign str = {s3, s2, s1, s0};
endmodule


module addRoundKey32 (word, key, str);
    input  [31:0] word, key;
    output [31:0] str;
    wire   [7:0] w0, w1, w2, w3;
    wire   [7:0] k0, k1, k2, k3;
    wire   [7:0] s0, s1, s2, s3;

    assign w0 = word[ 7: 0];
    assign w1 = word[15: 8];
    assign w2 = word[23:16];
    assign w3 = word[31:24];

    assign k0 =  key[ 7: 0];
    assign k1 =  key[15: 8];
    assign k2 =  key[23:16];
    assign k3 =  key[31:24];

    addRoundKey1 add0(w0, k0, s0);
    addRoundKey1 add1(w1, k1, s1);
    addRoundKey1 add2(w2, k2, s2);
    addRoundKey1 add3(w3, k3, s3);

    assign str = {s3, s2, s1, s0};
endmodule


module addRoundKey1 (word, key, str);
    input  [7:0] word, key;
    output [7:0] str;
    assign str = word ^ key;
endmodule
