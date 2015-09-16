module ENCRIPT (KEY, clk, reset, OUT);
    input [79:0] KEY;
    input clk, reset;
    output [511:0] OUT;
    reg [11:0] key_cot, str_cot;
    reg [287:0] SET;
    reg [511:0] STRM;
    reg [511:0] OUT;
    reg t1, t2, t3;

    always @(posedge clk or negedge reset) begin
        if(reset == 1'b0) begin
            if(key_cot == 1'b0) begin
                SET[79:0]    <= KEY;
                SET[92:80]   <= 0;
                SET[172:93]  <= IV;
                SET[284:173] <= 0;
                SET[287:285] <= 3'b111;
                key_cot      <= 1;
                str_cot      <= 0;
            end else if(key_cot < 1152) begin
                // t1 <= SET[65] ^ (SET[90] & SET[91]) ^ SET[92] ^ SET[170];
                // t2 <= SET[161] ^ SET[174] & SET[175] ^ SET[176] ^ SET[263];
                // t3 <= SET[242] ^ SET[285] & SET[286] ^ SET[287] ^ SET[68];
                // SET[92:0]    <= {SET[91:0], t3};
                // SET[176:93]  <= {SET[175:93], t1};
                // SET[287:177] <= {SET[286:177], t2};
                SET[92:0]    <= {SET[91:0], SET[242] ^ SET[285] & SET[286] ^ SET[287] ^ SET[68]};
                SET[176:93]  <= {SET[175:93], SET[65] ^ SET[90] & SET[91] ^ SET[92] ^ SET[170]};
                SET[287:177] <= {SET[286:177], SET[161] ^ SET[174] & SET[175] ^ SET[176] ^ SET[263]};
                key_cot      <= key_cot + 1;
            end else begin
                // if(str_cot < len) begin
                if(str_cot < 512) begin
                    STRM[str_cot] <= t1 ^ t2 ^ t3;
                    SET[92:0]     <= {SET[91:0], t3 ^ SET[285] & SET[286] ^ SET[68]};
                    SET[176:93]   <= {SET[175:93], t1 ^ SET[90] & SET[91] ^ SET[170]};
                    SET[287:177]  <= {SET[286:177], t2 ^ SET[174] & SET[175] ^ SET[263]};
                    // t1 <= SET[65] ^ SET[92];
                    // t2 <= SET[161] ^ SET[176];
                    // t3 <= SET[242] ^ SET[287];
                    // STRM[str_cot] <= t1 ^ t2 ^ t3;
                    // SET[92:0]     <= {SET[91:0], t3 ^ SET[285] & SET[286] ^ SET[68]};
                    // SET[176:93]   <= {SET[175:93], t1 ^ SET[90] & SET[91] ^ SET[170]};
                    // SET[287:177]  <= {SET[286:177], t2 ^ SET[174] & SET[175] ^ SET[263]};
                    str_cot       <= str_cot + 1;
                end else
                    OUT <= STRM;
            end
        end else begin
            key_cot <= 0;
        end
    end

endmodule

