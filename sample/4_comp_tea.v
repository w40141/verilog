`timescale 1ns/1ns

module COMP_TEST;
    reg [3:0] X, Y;
    wire LG, EQ, RG;

    COMP COMP (X, Y, LG, EQ, RG);
    always  #50     X = X + 1;
    initial begin
            X = 0;  Y = 8;
            #800    $finish;
    end

    initial begin
        $dumpfile("compa.vcd");
        $dumpvars(0, COMP_TEST);
    end
endmodule
