module expandKey (in, count, out);
input [127:0] in;
input [7:0] count;
output [127:0] out;
wire [31:0] in0, in1, in2, in3;
wire [31:0] out0, out1, out2, out3;
wire [31:0] rc, rw, sw, rt;
assign in0 = in[127:96];
assign in1 = in[ 95:64];
assign in2 = in[ 63:32];
assign in3 = in[ 31: 0];
rcon rcon (count, rc);
rotWord rot (in3, rw);
subBytes32 sub (rw, sw);
assign rt = sw ^ rc;
assign out0 = in0 ^ rt;
assign out1 = in1 ^ out0;
assign out2 = in2 ^ out1;
assign out3 = in3 ^ out2;
assign out = {out0, out1, out2, out3};
endmodule


module rcon (count, out);
input [7:0] count;
output [31:0] out;
assign out = (count > 8'h08)? (32'h1b000000 << (count - 8'h09)) : (32'h01000000 << (count - 1));
endmodule


module rotWord (in, out);
input [31:0] in;
output [31:0] out;
wire [31:0] in0, in1, in2, in3;

assign in0 = (in & 32'hff000000) >> 24;
assign in1 = (in & 32'h00ff0000) <<  8;
assign in2 = (in & 32'h0000ff00) <<  8;
assign in3 = (in & 32'h000000ff) <<  8;
assign out = in0 | in1 | in2 | in3;
endmodule
