module rcon (count, out);
input [7:0] count;
output [31:0] out;
assign out = (count > 8'h08)? (32'h1b000000 << (count - 8'h09)) : (32'h01000000 << (count - 1));
endmodule
