module keyMake (KEY, clk, reset, EXKEY);
input  [127:0] KEY;
input  clk;
output reset;
output [127:0] EXKEY;
reg    [127:0] EXKEY;

reg [7:0] count;

assign in_key = KEY;
module expandKey (in_key, count, EXKEY);

always @(clk) begin
    if(count > 8'h0a) reset = 1'b0;
    else begin
        in_key = EXKEY;
        count = count + 1'h01;
        reset = 1'b1;
    end
end
endmodule
