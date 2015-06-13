module combine8into32 (in0, in1, in2, in3, out);
input [7:0] in0, in1, in2, in3;
output [31:0] out;
assign out = {in3, in2, in1, in0};
endmodule


module combine32into128 (in0, in1, in2, in3, out);
input [31:0] in0, in1, in2, in3;
output [127:0] out;
assign out = {in3, in2, in1, in0};
endmodule
