// subbytes128.v
// shift128.v
// mixcol128.v
// expandkey.v
// addroundkey.v

module roundFunc1to9 (word, key, count, roundWord, exkey);
input   [127:0] word, key;
input   [7:0] count;
output  [127:0] roundWord, exkey;
wire    [127:0] sbword, lsword, mixword;

subBytes128 sub     (word, sbword);
shift128    lshift  (sbword, lsword);
mixCol128   mix     (lsword, mixword);
expandKey   expand  (key, count, exkey);
addRoundKey add     (mixword, exkey, roundWord);
endmodule
