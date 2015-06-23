module shift128_inv (in, out);
input [127:0] in;
output [127:0] out;

assign out = (in & 128'hff000000ff000000ff000000ff000000)       |
             (in & 128'h00ff000000ff000000ff000000ff0000) >> 32 |
             (in & 128'h00ff000000ff000000ff000000ff0000) << 96 |
             (in & 128'h0000ff000000ff000000ff000000ff00) >> 64 |
             (in & 128'h0000ff000000ff000000ff000000ff00) << 64 |
             (in & 128'h000000ff000000ff000000ff000000ff) << 96 |
             (in & 128'h000000ff000000ff000000ff000000ff) >> 96;
endmodule
