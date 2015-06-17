`timescale 1ns/1ns

module test;
reg [127:0] key;
reg [7:0] count;
wire [127:0] exkey;
integer i;

expandKey expand (key, count, exkey);
initial begin
    key  = 127'h010102030405060708090a0b0c0d0e0f;   count = 8'h01;
    for (i = 0; i < 10; i = i + 1) begin
        #100;
        count = count + 8'h01;
        key = exkey;
    end
    #100    $finish;
end

initial begin
    #0      $display($time, "key=%h, exkey=%h", key, exkey);
    #100    $display($time, "key=%h, exkey=%h", key, exkey);
    #100    $display($time, "key=%h, exkey=%h", key, exkey);
    #100    $display($time, "key=%h, exkey=%h", key, exkey);
    #100    $display($time, "key=%h, exkey=%h", key, exkey);
    #100    $display($time, "key=%h, exkey=%h", key, exkey);
    #100    $display($time, "key=%h, exkey=%h", key, exkey);
    #100    $display($time, "key=%h, exkey=%h", key, exkey);
    #100    $display($time, "key=%h, exkey=%h", key, exkey);
    #100    $display($time, "key=%h, exkey=%h", key, exkey);
    #100    $display($time, "key=%h, exkey=%h", key, exkey);
end

initial begin
    $dumpfile("add.vcd");
    $dumpvars(0, test);
end

endmodule
