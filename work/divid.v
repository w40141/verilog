module divid32to8 (word, w0, w1, w2, w3);
input [31:0] word;
output [7:0] w0, w1, w2, w3;
wire [31:0] t0, t1, t2, t3;

assign t0 = word & 32'hff000000;
assign t1 = word & 32'h00ff0000;
assign t2 = word & 32'h0000ff00;
assign t3 = word & 32'h000000ff;
assign w0 = t0[31:24];
assign w1 = t1[23:16];
assign w2 = t2[15: 8];
assign w3 = t3[ 7: 0];
endmodule


module divid128to32 (word, w0, w1, w2, w3);
input [127:0] word;
output [31:0] w0, w1, w2, w3;

assign w0 = word[127:96];
assign w1 = word[ 95:64];
assign w2 = word[ 63:32];
assign w3 = word[ 31: 0];
endmodule
