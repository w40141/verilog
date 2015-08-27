module ENCRIPT (KEY, IV, clk, reset, STR);
    input [79:0] KEY, IV;
    input clk, reset;
    output [287:0] STR;
    reg [287:0] STR;

    reg [11:0] count;
    reg [287:0] SET;

    always @(posedge clk or negedge reset) begin
        if(reset == 1'b0) begin
            if(12'h480 <= count) begin
                STR <= SET;
            end else if(0 == count) begin
                SET[79:0]    <= KEY;
                SET[91:80]   <= 0;
                SET[171:92]  <= IV;
                SET[284:172] <= 0;
                SET[287:285] <= 3'b111;
                count        <= count + 1;
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

