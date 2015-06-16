`timescale 1ns/1ns

module test;
    reg [127:0] word, key;
    reg [7:0] count;
    wire [127:0] str;

    roundFunc round (word, key, count, str);
    initial begin
                word  = 127'h000102030405060708090a0b0c0d0e0f;
                key   = 127'h102030405060708090a0b0c0d0e0f000;
                count = 8'h00;
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
