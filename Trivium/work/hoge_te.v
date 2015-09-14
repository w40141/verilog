`timescale 1ns/1ns

module test;
    reg clk;
    reg reset;
    wire [63:0] OUT;
    parameter times = 0.5;
    always #(times)   clk = ~clk;

    ENCRIPT ENCRIPT (clk, reset, OUT);

    initial begin
        clk = 1'b0;
        reset = 1;
        repeat(2) @(negedge clk);
        reset = 0;
        while(reset) @(negedge clk);
        @(negedge clk);
        repeat(50) @(negedge clk);
        $finish;
    end

    initial begin
        $dumpfile("hoge.vcd");
        $dumpvars(0, test);
    end

endmodule
