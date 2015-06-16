`timescale 1ns/1ns

module test;
reg [127:0] word;
reg [7:0] count;
wire [127:0] key;
integer i = 0;

expandKey ex (word, count, key);
initial begin
    word = 128'h000102030405060708090a0b0c0d0e0f; count = 0;
    for (i = 0; i < 12; i = i + 1) begin
        #100    count = count + 1;     word = key;
    end
    #100    $finish;
end

initial begin
    #0      $display($time, "count=%h, word=%h, str=%h", count, word, key);
    #100    $display($time, "count=%h, word=%h, str=%h", count, word, key);
    #100    $display($time, "count=%h, word=%h, str=%h", count, word, key);
    #100    $display($time, "count=%h, word=%h, str=%h", count, word, key);
    #100    $display($time, "count=%h, word=%h, str=%h", count, word, key);
    #100    $display($time, "count=%h, word=%h, str=%h", count, word, key);
    #100    $display($time, "count=%h, word=%h, str=%h", count, word, key);
    #100    $display($time, "count=%h, word=%h, str=%h", count, word, key);
    #100    $display($time, "count=%h, word=%h, str=%h", count, word, key);
    #100    $display($time, "count=%h, word=%h, str=%h", count, word, key);
    #100    $display($time, "count=%h, word=%h, str=%h", count, word, key);
    #100    $display($time, "count=%h, word=%h, str=%h", count, word, key);

    $dumpfile("expand.vcd");
    $dumpvars(0, test);
end

endmodule
