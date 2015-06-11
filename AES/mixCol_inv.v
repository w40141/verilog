`define s0 = 8'h0e;
`define s1 = 8'h0b;
`define s2 = 8'h0d;
`define s3 = 8'h09;

module mixCol_inv (x0, x1, x2, x3, y0, y1, y2, y3);
input [7:0] x0, x1, x2, x3;
output [7:0] y0, y1, y2, y3;
wire [7:0] d00, d01, d02, d03,
           d10, d11, d12, d13,
           d20, d21, d22, d23,
           d30, d31, d32, d33;

garoa_Cal garoa00(x0, 8'h0e, d00);
garoa_Cal garoa01(x1, 8'h0b, d01);
garoa_Cal garoa02(x2, 8'h0d, d02);
garoa_Cal garoa03(x3, 8'h09, d03);

garoa_Cal garoa10(x0, 8'h09, d10);
garoa_Cal garoa11(x1, 8'h0e, d11);
garoa_Cal garoa12(x2, 8'h0b, d12);
garoa_Cal garoa13(x3, 8'h0d, d13);

garoa_Cal garoa20(x0, 8'h0d, d20);
garoa_Cal garoa21(x1, 8'h09, d21);
garoa_Cal garoa22(x2, 8'h0e, d22);
garoa_Cal garoa23(x3, 8'h0b, d23);

garoa_Cal garoa30(x0, 8'h0b, d30);
garoa_Cal garoa31(x1, 8'h0d, d31);
garoa_Cal garoa32(x2, 8'h09, d32);
garoa_Cal garoa33(x3, 8'h0e, d33);

assign y0 = d00 ^ d01 ^ d02 ^ d03;
assign y1 = d10 ^ d11 ^ d12 ^ d13;
assign y2 = d20 ^ d21 ^ d22 ^ d23;
assign y3 = d30 ^ d31 ^ d32 ^ d33;

endmodule
