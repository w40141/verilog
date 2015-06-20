`timescale 1ns/1ns

module test;
reg [127:0] word, key;
wire [127:0] roundWord;
roundFunc round (word, key, roundWord);
initial begin
    word  = 127'h00112233445566778899aabbccddeeff;
    key   = 127'h000102030405060708090a0b0c0d0e0f;
    #100;   $finish;
end

initial begin
    $dumpfile("test.vcd");
    $dumpvars(0, test);
end

endmodule
