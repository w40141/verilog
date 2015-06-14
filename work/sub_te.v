`timescale 1ns/1ns

module test;
    reg [7:0] x0;
    wire [7:0] y0;

    subBytes_inv sub (x0, y0);
    initial begin
        #0      x0 = 8'h17;
        #100    x0 = 8'h40;
        #100    x0 = 8'ha3;
        #100    x0 = 8'h9c;
        #100    $finish;
    end

    initial begin
        #0      $display($time, "x0=%h, y0=%h", x0, y0);
        #100    $display($time, "x0=%h, y0=%h", x0, y0);
        #100    $display($time, "x0=%h, y0=%h", x0, y0);
        #100    $display($time, "x0=%h, y0=%h", x0, y0);
        #100    $display($time, "x0=%h, y0=%h", x0, y0);
    end

    initial begin
        $dumpfile("sub_inv.vcd");
        $dumpvars(0, test);
    end

endmodule
