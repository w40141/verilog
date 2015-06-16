module roundFunc (word, key, count, roundWord);
    input [127:0] word, key;
    input [7:0] count;
    output [127:0] roundWord;
    wire [127:0] sbword, lsword, mixword, exkey;

    subBytes128     sub     (word, sbword);
    leftShift128    lshift  (sbword, lsword);
    mixCol128       mix     (lsword, mixword);
    expandKey       expand  (key, count, exkey);
    addRoundKey     add     (mixword, exkey, roundWord);
endmodule
