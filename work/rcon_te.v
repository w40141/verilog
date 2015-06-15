`timescale 1ns/1ns

module test;
    reg [7:0] word;
    wire [7:0] s0;

    rcon rcon (word, s0);
    initial begin
                word = 8'h00;
        #100    word = 8'h01;
        #100    word = 8'h02;
        #100    word = 8'h03;
        #100    word = 8'h04;
        #100    word = 8'h05;
        #100    word = 8'h06;
        #100    word = 8'h07;
        #100    word = 8'h08;
        #100    word = 8'h09;
        #100    word = 8'h0a;
        #100    $finish;
    end

    initial begin
        #0      $display($time, "word=%h, s0=%h", word, s0);
        #100    $display($time, "word=%h, s0=%h", word, s0);
        #100    $display($time, "word=%h, s0=%h", word, s0);
        #100    $display($time, "word=%h, s0=%h", word, s0);
        #100    $display($time, "word=%h, s0=%h", word, s0);
        #100    $display($time, "word=%h, s0=%h", word, s0);
        #100    $display($time, "word=%h, s0=%h", word, s0);
        #100    $display($time, "word=%h, s0=%h", word, s0);
        #100    $display($time, "word=%h, s0=%h", word, s0);
        #100    $display($time, "word=%h, s0=%h", word, s0);
        #100    $display($time, "word=%h, s0=%h", word, s0);
        #100    $display($time, "word=%h, s0=%h", word, s0);
        #100    $display($time, "word=%h, s0=%h", word, s0);
        #100    $display($time, "word=%h, s0=%h", word, s0);
    end

    initial begin
        $dumpfile("rcon.vcd");
        $dumpvars(0, test);
    end

endmodule
