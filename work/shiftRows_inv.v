module shiftRows_inv (in, out);
input [127:0] in;
output [127:0] out;
wire [31:0] in0, in1, in2, in3;
wire [31:0] out0, out1, out2, out3;
wire [7:0]  i00, i01, i02, i03,
            i10, i11, i12, i13,
            i20, i21, i22, i23,
            i30, i31, i32, i33;

assign in0 = in[127:96];
assign in1 = in[ 95:64];
assign in2 = in[ 63:32];
assign in3 = in[ 31: 0];

assign i00 = in0[31:24];
assign i10 = in0[23:16];
assign i20 = in0[15: 8];
assign i30 = in0[ 7: 0];

assign i01 = in1[31:24];
assign i11 = in1[23:16];
assign i21 = in1[15: 8];
assign i31 = in1[ 7: 0];

assign i02 = in2[31:24];
assign i12 = in2[23:16];
assign i22 = in2[15: 8];
assign i32 = in2[ 7: 0];

assign i03 = in3[31:24];
assign i13 = in3[23:16];
assign i23 = in3[15: 8];
assign i33 = in3[ 7: 0];

assign out0 = {i00, i13, i22, i31};
assign out1 = {i01, i10, i23, i32};
assign out2 = {i02, i11, i20, i33};
assign out3 = {i03, i12, i21, i30};

assign out = {out0, out1, out2, out3};

endmodule
