`timescale 1ns/1ns

module test;
    reg  [79:0] KEY, IV;
    reg [15:0] len;
    reg clk, reset;
    wire [4095:0] OUT_1;
    wire [4095:0] OUT_2;
    parameter times = 0.5;
    always #(times)   clk = ~clk;

    ENCRIPT ENCRIPT (KEY, IV, len, clk, reset, OUT_1, OUT_2);
    // ENCRIPT ENCRIPT (KEY, IV, len, clk, reset, OUT);

    initial begin
        clk = 1'b0;
        KEY = 80'hFF000102030405060708;
        // KEY = 80'h080706050403020100FF;
        IV  = 80'h00000000000000000000;
        len = 4096;
        reset = 1;
        repeat(1) @(negedge clk);
        reset = 0;
        while(reset) @(negedge clk);
        @(negedge clk);
        repeat(15000) @(negedge clk);
        $finish;
    end

    initial begin
        $monitor($time, ", KEY=%h, IV=%h\n\nOUT_1=%h\n\nOUT_2=%h", KEY, IV, OUT_1, OUT_2);
        // $monitor($time, ", KEY=%h, IV=%h, OUT=%h", KEY, IV, OUT_1, OUT_2);
        $dumpfile("trivium.vcd");
        $dumpvars(0, test);
    end

endmodule
