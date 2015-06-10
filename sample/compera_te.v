`timescale 1ns/1ns
module COMP_TE;
    reg [1:0] X, Y;
    wire LG, EQ, RG;

    COMP COMP (X, Y, LG, EQ, RG);
    always #40 X = X + 1;
    always #160 Y = Y + 1;
    initial begin
        X = 0; Y = 0;
        #800 $finish;
    end

    initial begin
        $dumpfile("comp.vcd");
        $dumpvars(0, COMP_TE);
    end
endmodule
