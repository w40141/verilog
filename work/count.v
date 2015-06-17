module counter (in, out);
input [3:0] in;
output [3:0] out;
assign out = in + 4'h1;
endmodule
