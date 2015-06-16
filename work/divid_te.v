`timescale 1ns/1ns

module test;
    reg [31:0] word;
    wire [7:0] str0, str1, str2, str3;

    divid32to8 div(word, str0, str1, str2, str3);
    initial begin
                word = 32'h11223344;
        #100    $finish;
    end

    initial begin
        #0      $display($time, "word=%h, str0=%h, str1=%h, str2=%h, str3=%h", word, str0, str1, str2, str3);
        #100    $display($time, "word=%h, str0=%h, str1=%h, str2=%h, str3=%h", word, str0, str1, str2, str3);
    end

    initial begin
        $dumpfile("div.vcd");
        $dumpvars(0, test);
    end

endmodule
