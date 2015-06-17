module leftShift32 (in, num, out);
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


module leftShift128 (in, out);
input [127:0] in;
output [127:0] out;

assign out = (in & 128'hff000000ff000000ff000000ff000000)       |
             (in & 128'h00ff0000000000000000000000000000) >> 96 |
             (in & 128'h0000000000ff000000ff000000ff0000) << 32 |
             (in & 128'h0000ff000000ff000000000000000000) >> 64 |
             (in & 128'h00000000000000000000ff000000ff00) << 64 |
             (in & 128'h000000000000000000000000000000ff) << 96 |
             (in & 128'h000000ff000000ff000000ff00000000) >> 32;
endmodule
