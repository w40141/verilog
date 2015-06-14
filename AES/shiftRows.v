module shiftRows_inv (in, out);
input [127:0] in;
output [127:0] out;
wire [31:0] in0, in1, in2, in3;
wire [31:0] out0, out1, out2, out3;
wire [7:0]  i00, i01, i02, i03,
            i10, i11, i12, i13,
            i20, i21, i22, i23,
            i30, i31, i32, i33;

divid128to32 divid(in, in0, in1, in2, in3);
divid32to8 div0(in0, i00, i10, i20, i30);
divid32to8 div1(in1, i01, i11, i21, i31);
divid32to8 div2(in2, i02, i12, i22, i32);
divid32to8 div3(in3, i03, i13, i23, i33);

assign out0 = {i00, i11, i22, i33};
assign out1 = {i01, i12, i23, i30};
assign out2 = {i02, i13, i20, i31};
assign out3 = {i03, i10, i21, i32};

assign out = {out0, out1, out2, out3};

endmodule
