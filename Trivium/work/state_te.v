`timescale 1ns/1ns

module test;
reg clk, reset;
reg [79:0] KEY, IV;
wire [287:0] STR;

parameter times = 1;
always #(times)   clk = ~clk;

ENCRIPT ENCRIPT (KEY, IV, clk, reset, STR);

initial begin
    clk = 1'b0;
    IV  = 80'h00000123456789abcdef;
    KEY = 80'h00112233445566778899;
    reset = 1;
    repeat(2) @(negedge clk);
    reset = 0;
    @(negedge clk);
    while(reset) @(negedge clk);
    repeat(5000) @(negedge clk);
    $finish;
end

initial begin
    $dumpfile("state.vcd");
    $dumpvars(0, test);
end

endmodule
