module ENCRIPT (KEY, IV, clk, reset, len, STRM);
    input [79:0] KEY, IV;
    input clk, reset, len;
    output [287:0] STRM;
    reg [287:0] STRM;
    reg [11:0] count;
    reg [287:0] SET;
    reg t1, t2, t3, z;

    always @(posedge clk or negedge reset) begin
        if(reset == 1'b0) begin
            if(12'h480 <= count) begin
                if(len) begin
                    t1 <= SET[65]  ^ SET[93];
                    t2 <= SET[161] ^ SET[176];
                    t3 <= SET[242] ^ SET[287];
                    z  <= t1 ^ t2 ^ t3;
                    t1 <= t1 ^ SET[90]  & SET[91]  ^ SET[170];
                    t2 <= t2 ^ SET[174] & SET[175] ^ SET[263];
                    t3 <= t3 ^ SET[285] & SET[286] ^ SET[68];
                    SET[92:0]    <= {t3, SET[91:0]};
                    SET[176:93]  <= {t1, SET[175:93]};
                    SET[287:177] <= {t2, SET[286:177]};
                end else
                    STRM <= SET;
            end else if(count == 1'b0) begin
                SET[79:0]    <= KEY;
                SET[91:80]   <= 0;
                SET[171:92]  <= IV;
                SET[284:172] <= 0;
                SET[287:285] <= 3'b111;
                count        <= 1;
            end else begin
                count <= count + 1;
                SET[92:0]    <= {SET[91:0]   , SET[242] ^ (SET[285] & SET[286]) ^ SET[287] ^ SET[68]};
                SET[176:93]  <= {SET[175:93] , SET[65]  ^ (SET[90]  & SET[91] ) ^ SET[92]  ^ SET[170]};
                SET[287:177] <= {SET[286:177], SET[161] ^ (SET[174] & SET[175]) ^ SET[176] ^ SET[263]};
            end
        end else begin
            count        <= 0;
            SET[79:0]    <= KEY;
            SET[91:80]   <= 0;
            SET[171:92]  <= IV;
            SET[284:172] <= 0;
            SET[287:285] <= 3'b111;
        end
    end

endmodule

