`timescale 1ns/1ns

module test;
    reg  [79:0] KEY;
    reg  [79:0] IV;
    reg [15:0] len;
    reg clk;
    reg reset;
    wire [511:0] OUT;
    parameter times = 0.5;
    always #(times)   clk = ~clk;

    ENCRIPT ENCRIPT (KEY, IV, len, clk, reset, OUT);
    // ENCRIPT ENCRIPT (KEY, IV, clk, reset, OUT);

    initial begin
        clk = 0;
        KEY = 80'h10000000000000000000;
        IV  = 80'h00000000000000000000;
        // len = 512 * 8;
        len = 512;
        reset = 1;
        repeat(2) @(negedge clk);
        reset = 0;
        while(reset) @(negedge clk);
        @(negedge clk);
        repeat(2000) @(negedge clk);
        $finish;
    end

    initial begin
        $monitor($time, ", KEY=%h, IV=%h, OUT=%h", KEY, IV, OUT);
        $dumpfile("trivium.vcd");
        $dumpvars(0, test);
    end

endmodule
