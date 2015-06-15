`timescale 1ns/1ns

module test;
    reg [127:0] word, key;
    wire [127:0] str;

    addRoundKey add (word, key, str);
    initial begin
                word = 127'h0102030405060708090a0b0c0d0e0f;
                key  = 127'h111111111111111111111111111111;
        #100    $finish;
    end

    initial begin
        #0      $display($time, "word=%h, key=%h, str=%h", word, key, str);
        #100    $display($time, "word=%h, key=%h, str=%h", word, key, str);
        #100    $display($time, "word=%h, key=%h, str=%h", word, key, str);
    end

    initial begin
        $dumpfile("add.vcd");
        $dumpvars(0, test);
    end

endmodule
