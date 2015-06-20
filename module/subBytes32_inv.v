module subBytes32_inv (x, y);
input [31:0] x;
output [31:0] y;
wire [7:0] x0, x1, x2, x3;
wire [7:0] y0, y1, y2, y3;

assign x0 = x[31:24];
assign x1 = x[23:16];
assign x2 = x[15: 8];
assign x3 = x[ 7: 0];

subBytes_inv sub0 (x0, y0);
subBytes_inv sub0 (x1, y1);
subBytes_inv sub0 (x2, y2);
subBytes_inv sub0 (x3, y3);

assign y = {y0, y1, y2, y3};
endmodule