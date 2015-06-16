`timescale 1ns/1ns

module test;
    reg [127:0] word;
    wire [127:0] str;

    mixCol128 mix (word, str);
    initial begin
                word = 128'h000102030405060708090a0b0c0d0e0f;
        #100    $finish;
    end

    initial begin
        #0      $display($time, "word=%h, str=%h", word, str);
        #100    $display($time, "word=%h, str=%h", word, str);
    end

    initial begin
        $dumpfile("add.vcd");
        $dumpvars(0, test);
    end

endmodule
