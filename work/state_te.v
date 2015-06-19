`timescale 1ns/1ns

module test;
// reg clk, reset, en;
reg clk, reset;
reg [127:0] IN, KEY;
wire [127:0] ENC;
parameter times = 1;
always #(times)   clk = ~clk;
// always #(times*2)     en  = ~en;

// round   round (IN, KEY, clk, en, reset, ENC);
round   round (IN, KEY, clk, reset, ENC);

initial begin
    clk = 1'b0;
    // en  = 1'b0;
    IN  = 128'h00112233445566778899aabbccddeeff;
    KEY = 128'h000102030405060708090a0b0c0d0e0f;
    reset = 1;
    repeat(5) @(negedge clk);
    reset = 0;
    @(negedge clk);
    while(reset) @(negedge clk);
    repeat(200) @(negedge clk);
    $finish;
end

initial begin
    $dumpfile("state.vcd");
    $dumpvars(0, test);
end

endmodule
