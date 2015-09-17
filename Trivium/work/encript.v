module ENCRIPT (KEY, IV, clk, reset, OUT);
// module ENCRIPT (KEY, IV, len, clk, reset, OUT);
input [79:0] KEY, IV;
// input [11:0] len;
input clk, reset;
output [511:0] OUT;
reg [11:0] key_cot, str_cot;
reg [287:0] SET;
reg [511:0] STRM;
reg [511:0] OUT;
reg t1, t2, t3;

always @(posedge clk or negedge reset) begin
    if(!reset) begin
        if(key_cot < 4 * 288) begin
            if(key_cot == 0) begin
                SET     <= {KEY, 13'b0, IV, 111'b0, 3'b111};
                str_cot <= 512;
            end
            SET[92:0]    <= {SET[91:0], SET[242] ^ SET[285] & SET[286] ^ SET[287] ^ SET[68]};
            SET[176:93]  <= {SET[175:93], SET[65] ^ SET[90] & SET[91] ^ SET[92] ^ SET[170]};
            SET[287:177] <= {SET[286:177], SET[161] ^ SET[174] & SET[175] ^ SET[176] ^ SET[263]};
            key_cot      <= key_cot + 1;
        end else begin
            if(0 <= str_cot) begin
                STRM[str_cot] <= SET[65] ^ SET[92] ^ SET[161] ^ SET[176] ^ SET[242] ^ SET[287];
                SET[92:0]     <= {SET[91:0]   , SET[242] ^ SET[287] ^ (SET[285] & SET[286]) ^ SET[68]};
                SET[176:93]   <= {SET[175:93] , SET[65]  ^ SET[93]  ^ (SET[90]  & SET[91] ) ^ SET[170]};
                SET[287:177]  <= {SET[286:177], SET[161] ^ SET[176] ^ (SET[174] & SET[175]) ^ SET[263]};
                str_cot       <= str_cot - 1;
            end else OUT <= STRM;
        end
    end else key_cot <= 0;
end

endmodule

