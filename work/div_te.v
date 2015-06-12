`timescale 1ns/1ns

module test;
    reg [31:0] word;
    wire [7:0] s0, s1, s2, s3;

    divid32to8 div (word, s0, s1, s2, s3);
    initial begin
                word=32'h890abcdf;
        #100    $finish;
    end

    initial begin
        #0      $display($time, "word=%h, s0=%h, s1=%h, s2=%h, s3=%h", word, s0, s1, s2, s3);
        #100    $display($time, "word=%h, s0=%h, s1=%h, s2=%h, s3=%h", word, s0, s1, s2, s3);
    end

    initial begin
        $dumpfile("div.vcd");
        $dumpvars(0, test);
    end

endmodule
