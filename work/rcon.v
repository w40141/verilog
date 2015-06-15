module rcon (in, out);
input [7:0] in;
output [7:0] out;

assign out = (in > 8'h08)? (8'h1b << (in - 8'h09)) : (8'h01 << (in - 1));

endmodule
