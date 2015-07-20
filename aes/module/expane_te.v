`timescale 1ns/1ns

module test;
reg clk;
reg [127:0] KEY;
wire reset;
wire [127:0] EXKEY;
parameter times = 4;
always #(times)   clk = ~clk;

module keyMake (KEY, clk, reset, EXKEY);

initial begin
    clk = 1'b0;
    KEY = 128'h13111d7fe3944a17f307a78b4d2b30c5;
    @(negedge clk);
    repeat(100) @(negedge clk);
    $finish;
end

initial begin
    $dumpfile("make.vcd");
    $dumpvars(0, test);
end

endmodule
