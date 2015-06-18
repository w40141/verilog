`timescale 1ns/1ns

module test;
reg clk, reset;
wire [7:0] count;
wire [2:0] cs;
parameter times = 4;

reg IN2, IN3;
wire OUT;

state   state   (clk, reset, count, cs);
cal     cal     (clk, IN2, IN3, cs, count, OUT);

initial begin
    clk = 1'b0;
    IN2 = 1'b0;
    IN3 = 1'b1;
end

always #(times/2)   clk = ~clk;
always #(times/4)   IN2 = ~IN2;
always #(times)     IN3 = ~IN3;

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
    $dumpfile("hoge.vcd");
    $dumpvars(0, test);
end

endmodule
