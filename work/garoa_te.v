`timescale 1ns/1ns

module test;
    reg [7:0] x, y;
    wire [7:0] d;

    garoaCal garoaCal (x, y, d);
    initial begin
                x = 8'h56;    y = 8'h12;
        #100    x = 8'h46;    y = 8'h4C;
        #100    x = 8'h02;    y = 8'h4C;
        #100    x = 8'h13;    y = 8'h5C;
        #100    $finish;
    end

    initial begin
        #0      $display($time, "x=%h, y=%h, d=%h", x, y, d);
        #100    $display($time, "x=%h, y=%h, d=%h", x, y, d);
        #100    $display($time, "x=%h, y=%h, d=%h", x, y, d);
        #100    $display($time, "x=%h, y=%h, d=%h", x, y, d);
        #100    $display($time, "x=%h, y=%h, d=%h", x, y, d);
        #100    $display($time, "x=%h, y=%h, d=%h", x, y, d);
    end

    initial begin
        $dumpfile("garoa.vcd");
        $dumpvars(0, test);
    end

endmodule
