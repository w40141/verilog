module roundFunc1to9 (word, key, count, roundWord, exkey);
input   [127:0] word, key;
input   [7:0] count;
output  [127:0] roundWord, exkey;
wire    [127:0] sbword, lsword, mixword;

subBytes128     sub     (word, sbword);
leftShift128    lshift  (sbword, lsword);
mixCol128       mix     (lsword, mixword);
expandKey       expand  (key, count, exkey);
addRoundKey     add     (mixword, exkey, roundWord);
endmodule


module roundFunc10 (word, key, roundWord);
input [127:0] word, key;
output [127:0] roundWord;
wire [127:0] sbword, lsword, exkey;

subBytes128     sub     (word, sbword);
leftShift128    lshift  (sbword, lsword);
expandKey       expand  (key, 8'h0a, exkey);
addRoundKey     add     (lsword, exkey, roundWord);
endmodule


module roundFunc (word, key0, roundWord);
input [127:0] word, key0;
output [127:0] roundWord;
wire [127:0] str0, str1, str2, str3, str4, str5, str6, str7, str8, str9;
wire [127:0] key1, key2, key3, key4, key5, key6, key7, key8, key9;

addRoundKey     add     (word, key0, str0);
roundFunc1to9   round1  (str0, key0, 8'h01, str1, key1);
roundFunc1to9   round2  (str1, key1, 8'h02, str2, key2);
roundFunc1to9   round3  (str2, key2, 8'h03, str3, key3);
roundFunc1to9   round4  (str3, key3, 8'h04, str4, key4);
roundFunc1to9   round5  (str4, key4, 8'h05, str5, key5);
roundFunc1to9   round6  (str5, key5, 8'h06, str6, key6);
roundFunc1to9   round7  (str6, key6, 8'h07, str7, key7);
roundFunc1to9   round8  (str7, key7, 8'h08, str8, key8);
roundFunc1to9   round9  (str8, key8, 8'h09, str9, key9);
roundFunc10     round10 (str9, key9, roundWord);

endmodule
