`timescale 1ns/1ns

module test;
    reg [127:0] word, key;
    wire [127:0] str;

    addRoundKey add (word, key, str);
    initial begin
                word = 127'h000102030405060708090a0b0c0d0e0f;
                key  = 127'h0123456789abcdef0123456789abcdef;
        #100    word = word + 8'h01;
        #100    word = word + 8'h01;
        #100    word = word + 8'h01;
        #100    word = word + 8'h01;
        #100    word = word + 8'h01;
        #100    word = word + 8'h01;
        #100    $finish;
    end

    initial begin
        #0      $display($time, "word=%h, str=%h", word, str);
        #100    $display($time, "word=%h, str=%h", word, str);
        #100    $display($time, "word=%h, str=%h", word, str);
        #100    $display($time, "word=%h, str=%h", word, str);
        #100    $display($time, "word=%h, str=%h", word, str);
        #100    $display($time, "word=%h, str=%h", word, str);
        #100    $display($time, "word=%h, str=%h", word, str);
        #100    $display($time, "word=%h, str=%h", word, str);
    end

    initial begin
        $dumpfile("add.vcd");
        $dumpvars(0, test);
    end

endmodule
