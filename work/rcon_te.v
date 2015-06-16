`timescale 1ns/1ns

module test;
reg [31:0] count;
wire [31:0] word;

rotWord rot (count, word);
initial begin
            count = 32'h01020304;
    #100    count = 32'h0a0b0c0d;
    #100    $finish;
end

initial begin
    #0      $display($time, "word=%h, count=%h", word, count);
    #100    $display($time, "word=%h, count=%h", word, count);
    #100    $display($time, "word=%h, count=%h", word, count);
    #100    $display($time, "word=%h, count=%h", word, count);

    $dumpfile("rot.vcd");
    $dumpvars(0, test);
end

endmodule
