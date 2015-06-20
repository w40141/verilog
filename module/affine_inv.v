module affine_inv (x, y);
input [7:0] x;
output [7:0] y;
assign y[7] =  (x[1] ^ x[4] ^ x[6]);
assign y[6] =  (x[0] ^ x[3] ^ x[5]);
assign y[5] =  (x[7] ^ x[2] ^ x[4]);
assign y[4] =  (x[6] ^ x[1] ^ x[3]);
assign y[3] =  (x[5] ^ x[0] ^ x[2]);
assign y[2] = ~(x[4] ^ x[7] ^ x[1]);
assign y[1] =  (x[3] ^ x[6] ^ x[0]);
assign y[0] = ~(x[2] ^ x[5] ^ x[7]);
endmodule
