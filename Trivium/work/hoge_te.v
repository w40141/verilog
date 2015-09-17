`timescale 1ns/1ns

module test;
    reg clk;
    reg reset;
    reg [3:0] KEY;
    wire OUT_1, OUT_2, OUT_3;
    parameter times = 0.5;
    always #(times)   clk = ~clk;

    ENCRIPT ENCRIPT (KEY, clk, reset, OUT_1, OUT_2, OUT_3);

    initial begin
        clk = 1'b0;
        reset = 1;
        KEY = 4'h1;
        repeat(2) @(negedge clk);
        reset = 0;
        while(reset) @(negedge clk);
        @(negedge clk);
        repeat(10) @(negedge clk);
        $finish;
    end

    initial begin
        $dumpfile("hoge.vcd");
        $dumpvars(0, test);
    end

endmodule
