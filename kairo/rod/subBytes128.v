// subBytes32.v
module subBytes128 (x, y);
input [127:0] x;
output [127:0] y;
wire [31:0] x0, x1, x2, x3;
wire [31:0] y0, y1, y2, y3;

assign x0 = x[127:96];
assign x1 = x[ 95:64];
assign x2 = x[ 63:32];
assign x3 = x[ 31: 0];

subBytes32 sub0 (x0, y0);
subBytes32 sub1 (x1, y1);
subBytes32 sub2 (x2, y2);
subBytes32 sub3 (x3, y3);

assign y = {y0, y1, y2, y3};
endmodule
