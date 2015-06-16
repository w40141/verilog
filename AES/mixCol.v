module mixCol32 (in, out);
input [31:0] in;
output [31:0] out;
wire [7:0] x0, x1, x2, x3;
wire [7:0] y0, y1, y2, y3;

divid32to8 div(in, x0, x1, x2, x3);

assign y0 = FUNC_2(x0) ^ FUNC_2(x1) ^ x1 ^ x2 ^ x3;
assign y1 = x0 ^ FUNC_2(x1) ^ FUNC_2(x2) ^ x2 ^ x3;
assign y2 = x0 ^ x1 ^ FUNC_2(x2) ^ FUNC_2(x3) ^ x3;
assign y3 = FUNC_2(x0) ^ x0 ^ x1 ^ x2 ^ FUNC_2(x3);

assign out = {y0, y1, y2, y3};

function [7:0] FUNC_2;
    input [7:0] x;
    if(x[7] == 1)
        FUNC_2 = (x << 1) ^ 8'h1b;
    else
        FUNC_2 = (x << 1);
endfunction

endmodule


module mixCol128 (in, out);
input [127:0] in;
output [127:0] out;
wire [31:0] x0, x1, x2, x3;
wire [31:0] y0, y1, y2, y3;

divid128to32 div(in, x0, x1, x2, x3);
mixCol32     mix0(in0, y0);
mixCol32     mix1(in1, y1);
mixCol32     mix2(in2, y2);
mixCol32     mix3(in3, y3);

assign out = {y0, y1, y2, y3};

endmodule
