module subBytes128_inv (x, y);
input [127:0] x;
output [127:0] y;
wire [31:0] x0, x1, x2, x3;
wire [31:0] y0, y1, y2, y3;

assign x0 = x[127:96];
assign x1 = x[ 95:64];
assign x2 = x[ 63:32];
assign x3 = x[ 31: 0];

subBytes32_inv sub0_inv (x0, y0);
subBytes32_inv sub1_inv (x1, y1);
subBytes32_inv sub2_inv (x2, y2);
subBytes32_inv sub3_inv (x3, y3);

assign y = {y0, y1, y2, y3};
endmodule
