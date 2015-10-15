`timescale 1ns/1ns

module test;
    reg  [79:0] KEY, IV;
    reg [15:0] len;
    reg clk, reset;
    // wire OUT;
    wire [4095:0] OUT;
    parameter times = 0.5;
    always #(times)   clk = ~clk;

    ENCRIPT ENCRIPT (KEY, IV, len, clk, reset, OUT);

    initial begin
        clk = 1'b0;
        KEY = 80'hFF000102030405060708;
        IV  = 80'h00000000000000000000;
        len = 4096;
        reset = 1;
        repeat(1) @(negedge clk);
        reset = 0;
        // while(reset) @(negedge clk);
        // @(negedge clk);
        repeat(15000) @(negedge clk);
        $finish;
    end

    initial begin
        $monitor($time , "\nKEY=%h, IV=%h\nOUT=%h", KEY, IV, OUT);
        $dumpfile("tri.vcd");
        $dumpvars(0, test);
    end

endmodule
