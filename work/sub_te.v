`timescale 1ns/1ns

module test;
reg [7:0] count;
wire [31:0] word;
integer i;

rcon rcon (count, word);
initial begin
            count = 0;
            for (i = 0; i < 12; i = i + 1) begin
                count = count + 1;
            end
    #100    $finish;
end

initial begin
    #0      $display($time, "word=%h, count=%h", word, count);
    #100    $display($time, "word=%h, count=%h", word, count);
    #100    $display($time, "word=%h, count=%h", word, count);
    #100    $display($time, "word=%h, count=%h", word, count);
    #100    $display($time, "word=%h, count=%h", word, count);
    #100    $display($time, "word=%h, count=%h", word, count);
    #100    $display($time, "word=%h, count=%h", word, count);
    #100    $display($time, "word=%h, count=%h", word, count);
    #100    $display($time, "word=%h, count=%h", word, count);
    #100    $display($time, "word=%h, count=%h", word, count);
    #100    $display($time, "word=%h, count=%h", word, count);
    #100    $display($time, "word=%h, count=%h", word, count);
end

initial begin
    $dumpfile("sub.vcd");
    $dumpvars(0, test);
end

endmodule
