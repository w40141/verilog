`timescale 1ns/1ns

module test;
    reg  [79:0] KEY;
    reg  [79:0] IV;
    reg clk;
    reg reset;
    wire [287:0] STRM;
    parameter times = 0.5;
    always #(times)   clk = ~clk;

    ENCRIPT ENCRIPT (KEY, IV, clk, reset, STRM);

    initial begin
        clk = 1'b0;
        IV  = 80'h0000123456789abcdef;
        KEY = 80'h0000000000000000000;
        reset = 1;
        repeat(2) @(negedge clk);
        reset = 0;
        while(reset) @(negedge clk);
        @(negedge clk);
        repeat(2000) @(negedge clk);
        $finish;
    end

    initial begin
        $dumpfile("enc.vcd");
        $dumpvars(0, test);
    end

endmodule
