`timescale 1ns/1ns

module test;
    reg [127:0] word, key;
    wire [127:0] str;

    addRoundKey128 add (word, key, str);
    initial begin
                word=127'ha312345689012394;     key=127'h9485413461234514;
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
