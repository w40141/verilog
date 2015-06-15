module rotWord (in, out);
input [31:0] in;
output [31:0] out;
wire [7:0] in0, in1, in2, in3, out0;

divid32to8 div (in, in0, in1, in2, in3);
assign out = {in1, in2, in3, in0};
endmodule


module rcon (in, out);
input [7:0] in;
output [31:0] out;
assign out0 = (in > 8'h08)? (8'h1b << (in - 8'h09)) : (8'h01 << (in - 1));
assign out = {out0, 8'h00, 8'h00, 8'h00};
endmodule


module expandKey (in, count, out);
input [127:0] in;
input [7:0] count;
output [127:0] out;
wire [31:0] in0, in1, in2, in3;
wire [31:0] out0, out1, out2, out3;
wire [31:0] rw, sw, rc, rt;

rcon rcon (count, rc);
divid128to32 div (in, in0, in1, in2, in3);
rotWord rot (in3, rw);
subBytes32 sub(rw, sw);
assign rt = sw ^ rc;
assign out0 = in0 ^ rt;
assign out1 = in1 ^ out0;
assign out2 = in2 ^ out1;
assign out3 = in3 ^ out2;
assign out = {out0, out1, out2, out3};

endmodule
