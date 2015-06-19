`timescale 1ns/1ns

module test;
reg [127:0] word, key;
wire [127:0] roundWord;
// wire [127:0] round, addword, subword, shiftword, mixword, exkey;
// integer i;

// addRoundKey     add0    (word, key, addword);
// subBytes128     sub     (addword, subword);
// leftShift128    shift   (subword, shiftword);
// mixCol128       mix     (shiftword, mixword);
// expandKey       expand  (key, 8'h01, exkey);
// addRoundKey     add1    (mixword, exkey, round);
roundFunc round (word, key, roundWord);
initial begin
    word  = 127'h00112233445566778899aabbccddeeff;
    key   = 127'h000102030405060708090a0b0c0d0e0f;
    #100;   $finish;
end

initial begin
    #0      $display("word=%h, key=%h, roundWord=%h", word, key, roundWord);
    #100    $display("word=%h, key=%h, roundWord=%h", word, key, roundWord);
end

initial begin
    $dumpfile("test.vcd");
    $dumpvars(0, test);
end

endmodule
