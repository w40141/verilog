module mixCol32 (in, out);
input [31:0] in;
output [31:0] out;
wire [7:0] x0, x1, x2, x3;
wire [7:0] y0, y1, y2, y3;

assign x0 = in[31:24];
assign x1 = in[23:16];
assign x2 = in[15: 8];
assign x3 = in[ 7: 0];

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

assign x0 = in[127:96];
assign x1 = in[ 95:64];
assign x2 = in[ 63:32];
assign x3 = in[ 31: 0];

mixCol32 mix0(x0, y0);
mixCol32 mix1(x1, y1);
mixCol32 mix2(x2, y2);
mixCol32 mix3(x3, y3);

assign out = {y0, y1, y2, y3};
endmodule
