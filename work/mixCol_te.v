`timescale 1ns/1ns

module test;
    reg [7:0] x0, x1, x2, x3;
    wire [7:0] y0, y1, y2, y3;

    mixCol_inv mixCol_inv (x0, x1, x2, x3, y0, y1, y2, y3);
    initial begin
                x0 = 8'h47; x1 = 8'h37; x2 = 8'h94; x3 = 8'hed;
        #100    x0 = 8'h40; x1 = 8'hd4; x2 = 8'he4; x3 = 8'ha5;
        #100    x0 = 8'ha3; x1 = 8'h70; x2 = 8'h3a; x3 = 8'h42;
        #100    x0 = 8'h4c; x1 = 8'h9f; x2 = 8'h42; x3 = 8'hbc;
        #100    $finish;
    end

    initial begin
        #0      $display($time, "x0=%h, x1=%h, x2=%h, x3=%h, y0=%h, y1=%h, y2=%h, y3=%h", x0, x1, x2, x3, y0, y1, y2, y3);
        #100    $display($time, "x0=%h, x1=%h, x2=%h, x3=%h, y0=%h, y1=%h, y2=%h, y3=%h", x0, x1, x2, x3, y0, y1, y2, y3);
        #100    $display($time, "x0=%h, x1=%h, x2=%h, x3=%h, y0=%h, y1=%h, y2=%h, y3=%h", x0, x1, x2, x3, y0, y1, y2, y3);
        #100    $display($time, "x0=%h, x1=%h, x2=%h, x3=%h, y0=%h, y1=%h, y2=%h, y3=%h", x0, x1, x2, x3, y0, y1, y2, y3);
        #100    $display($time, "x0=%h, x1=%h, x2=%h, x3=%h, y0=%h, y1=%h, y2=%h, y3=%h", x0, x1, x2, x3, y0, y1, y2, y3);
    end

    initial begin
        $dumpfile("mixCol_inv.vcd");
        $dumpvars(0, test);
    end

endmodule
