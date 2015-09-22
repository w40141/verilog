`timescale 1ns/1ns

module test;
    reg  [7:0] KEY;
    reg clk;
    reg reset;
    wire T1, T2, T3;
    parameter times = 0.5;
    always #(times)   clk = ~clk;

    ENCRIPT ENCRIPT (KEY, clk, reset, T1, T2, T3);

    initial begin
        clk = 0;
        KEY = 8'h44;
        reset = 1;
        repeat(2) @(negedge clk);
        reset = 0;
        while(reset) @(negedge clk);
        @(negedge clk);
        repeat(20) @(negedge clk);
        $finish;
    end

    initial begin
        // $monitor($time, ", KEY=%h, IV=%h, OUT=%h", KEY, IV, OUT);
        $dumpfile("hoge.vcd");
        $dumpvars(0, test);
    end

endmodule
