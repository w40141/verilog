module rotWord (in, out);
    input [31:0] in;
    output [31:0] out;
    wire [7:0] in0, in1, in2, in3;

    divid32to8 div (in, in0, in1, in2, in3);
    assign out = {in1, in2, in3, in0};
endmodule


module rcon (in, out);
input [7:0] in;
output [7:0] out;
assign out = (in > 8'h08)? (8'h1b << (in - 8'h09)) : (8'h01 << (in - 1));
endmodule


module expandKey (in, out);
    input [127:0] in;
    output [127:0] out;
    wire [31:0] in0, in1, in2, in3;
    wire [31:0] rw, sw;
    wire [127:0] ;
    reg [32:0] rconj;

    divid128to32 div (in, in0, in1, in2, in3);
    rotWord rot (in3, rw);
    subBytes32 sub(rw, sw);
endmodule
