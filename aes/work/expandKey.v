// subbytes.v
// rcon.v
// leftShift.v
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
shift32 ls (in3, 8'h01, rw);
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
