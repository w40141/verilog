`timescale 1ns/1ns

module test;
    reg  [287:0] IN;
    wire [287:0] OUT;

    INIT_2 INIT_2 (IN, OUT);
    always #10 IN = OUT;
    initial begin
        IN  = 288'h01010101010101101010101101010110101010110101020304040;
        #200    $finish;
    end

    initial begin
        $monitor($time, "IN=%h, OUT=%h", IN, OUT);
        $dumpfile("init.vcd");
        $dumpvars(0, test);
    end
endmodule
