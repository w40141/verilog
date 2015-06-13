module shiftRows (in, out);
input [127:0] in;
output [127:0] out;
wire [31:0] in0, in1, in2, in3;
wire [31:0] out0, out1, out2, out3;
wire [7:0]  i00, i01, i02, i03,
            i10, i11, i12, i13,
            i20, i21, i22, i23,
            i30, i31, i32, i33;
wire [7:0]  o00, o01, o02, o03,
            o10, o11, o12, o13,
            o20, o21, o22, o23,
            o30, o31, o32, o33;

divid128to32 divid(in, in0, in1, in2, in3);
divid32to8 div0(in0, i00, i10, i20, i30);
divid32to8 div1(in1, i01, i11, i21, i31);
divid32to8 div2(in2, i02, i12, i22, i32);
divid32to8 div3(in3, i03, i13, i23, i33);

assign o00 = i00;
assign o01 = i01;
assign o02 = i02;
assign o03 = i03;

assign o10 = i11;
assign o11 = i12;
assign o12 = i13;
assign o13 = i10;

assign o20 = i22;
assign o21 = i23;
assign o22 = i20;
assign o23 = i21;

assign o30 = i33;
assign o31 = i30;
assign o32 = i31;
assign o33 = i32;

assign out0 = {o03, o02, o01, o00};
assign out1 = {o13, o12, o11, o10};
assign out2 = {o23, o22, o21, o20};
assign out3 = {o33, o32, o31, o30};

assign out = {out3, out2, out1, out0}<`2`>;

endmodule
