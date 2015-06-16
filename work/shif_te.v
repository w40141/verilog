`timescale 1ns/1ns

module test;
    reg [127:0] be;
    wire [127:0] af, str;

    shiftRows       shift       (be, str);
    shiftRows_inv   shift_inv   (str, af);
    initial begin
                be = 128'h000102030405060708090a0b0c0d0e0f;
        #100    $finish;
    end

    initial begin
        #0      $display($time, "be=%h, str=%h, af=%h", be, str, af);
        #100    $display($time, "be=%h, str=%h, af=%h", be, str, af);
    end

    initial begin
        $dumpfile("add.vcd");
        $dumpvars(0, test);
    end

endmodule
