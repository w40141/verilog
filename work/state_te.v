`timescale 1ns/1ns

module test;
reg clk, reset;
wire [7:0] count;
wire [2:0] cs;
parameter times = 4;

reg [127:0] IN, KEY;
wire [127:0] ENC;
wire [127:0] OUT, EXKEY;

state   state   (clk, reset, count, cs);
round   round   (IN, KEY, cs, count, OUT, EXKEY, ENC);

initial begin
    clk = 1'b0;
    IN  = 128'h00112233445566778899aabbccddeeff;
    KEY = 128'h000102030405060708090a0b0c0d0e0f;
end

always #(times/2)   clk = ~clk;

initial begin
    reset = 1;
    repeat(5) @(negedge clk);
    reset = 0;
end

initial begin
    @(negedge clk);
    while(reset) @(negedge clk);
    repeat(100) @(negedge clk);
    $finish;
end

initial begin
    $dumpfile("state.vcd");
    $dumpvars(0, test);
end

endmodule
