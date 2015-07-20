// subbytes128.v
// shift128.v
// expandkey.v
// addroundkey.v

module roundFunc10 (word, key, roundWord);
input [127:0] word, key;
output [127:0] roundWord;
wire [127:0] sbword, lsword, exkey;

subBytes128 sub     (word, sbword);
shift128    lshift  (sbword, lsword);
expandKey   expand  (key, 8'h0a, exkey);
addRoundKey add     (lsword, exkey, roundWord);
endmodule
