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
