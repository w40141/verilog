`timescale 1ns/1ns

module mix;
    reg [7:0] x, y;
    wire [7:0] d;

    mixCol_inv pol(x0, x1, x2, x3, y0, y1, y2, y3);
    reg [7:0] x0, x1, x2, x3;
    wire [7:0] y0, y1, y2, y3;
    initial begin
                x0 = 8'h12; x1 = 8'h56; x2 = 8'h30; x3 = 8'h0f;
        #100    x0 = 8'h14; x1 = 8'h56; x2 = 8'h30; x3 = 8'h0f;
        #100    x0 = 8'h02; x1 = 8'h56; x2 = 8'h30; x3 = 8'h0f;
        #100    x0 = 8'h3b; x1 = 8'h56; x2 = 8'h30; x3 = 8'h0f;
        #100    $finish;
    end

    // $display ("x=%b, y=%b, d=%b", x, y, d);

    initial begin
        $dumpfile("mix.vcd");
        $dumpvars(0, mix);
    end

endmodule
