`timescale 1ns/1ns

module test;
    reg [7:0] x0, x1, x2, x3;
    wire [7:0] y0, y1, y2, y3;

    mixCol mixCol (x0, x1, x2, x3, y0, y1, y2, y3);
    initial begin
                x0 = 8'h87;    x1 = 8'h6E;
                x2 = 8'h46;    x3 = 8'hA6;

        #100    x0 = 8'hF2;    x1 = 8'h4C;
                x2 = 8'hE7;    x3 = 8'h8C;

        #100    x0 = 8'h4D;    x1 = 8'h90;
                x2 = 8'h4A;    x3 = 8'hD8;

        #100    x0 = 8'h97;    x1 = 8'hEC;
                x2 = 8'hC3;    x3 = 8'h95;

        #100    $finish;
    end

    initial begin
        #0      $display($time, "y0=%h, y1=%h, y2=%h, y3=%h", y0, y1, y2, y3);
        #100    $display($time, "y0=%h, y1=%h, y2=%h, y3=%h", y0, y1, y2, y3);
        #100    $display($time, "y0=%h, y1=%h, y2=%h, y3=%h", y0, y1, y2, y3);
        #100    $display($time, "y0=%h, y1=%h, y2=%h, y3=%h", y0, y1, y2, y3);
        #100    $display($time, "y0=%h, y1=%h, y2=%h, y3=%h", y0, y1, y2, y3);
    end

    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0, test);
    end

endmodule
