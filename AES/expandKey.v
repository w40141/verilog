module rotWord (in, out);
    input [31:0] in;
    output [31:0] out;
    wire [7:0] in0, in1, in2, in3;
    wire [7:0] out0, out1, out2, out3;

    divid32to8 div (in, in0, in1, in2, in3);
    assign out = <`2`>{in1, in2, in3, in0};
endmodule
