module shift32 (in, num, out);
input [31:0] in;
input [7:0] num;
output [31:0] out;

assign out = FUNC_SHIFT(in, num);

function [31:0]FUNC_SHIFT;
    input [31:0] in;
    input [7:0] num;

    case (num)
        8'h01:  FUNC_SHIFT = (in & 32'hff000000) >> 24 | (in & 32'h00ffffff) <<  8;
        8'h02:  FUNC_SHIFT = (in & 32'hffff0000) >> 16 | (in & 32'h0000ffff) << 16;
        8'h03:  FUNC_SHIFT = (in & 32'hffffff00) >>  8 | (in & 32'h000000ff) << 24;
        default:FUNC_SHIFT = in;
    endcase
endfunction
endmodule
