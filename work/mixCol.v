module mixCol (x0, x1, x2, x3, y0, y1, y2, y3);
input [7:0] x0, x1, x2, x3;
output [7:0] y0, y1, y2, y3;

assign y0 = FUNC_2(x0) ^ FUNC_2(x1) ^ x1 ^ x2 ^ x3;
assign y1 = x0 ^ FUNC_2(x1) ^ FUNC_2(x2) ^ x2 ^ x3;
assign y2 = x0 ^ x1 ^ FUNC_2(x2) ^ FUNC_2(x3) ^ x3;
assign y3 = FUNC_2(x0) ^ x0 ^ x1 ^ x2 ^ FUNC_2(x3);

function [7:0] FUNC_2;
    input [7:0] x;
    reg [7:0] fx;
    if(x[7] == 1)
        FUNC_2 = (x << 1) ^ 8'b00011011;
    else
        FUNC_2 = (x << 1);
endfunction

endmodule
