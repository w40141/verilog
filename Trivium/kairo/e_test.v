module ENCRIPT (KEY, IV, len, clk, reset, OUT);
input [79:0] KEY, IV;
input [15:0] len;
input clk, reset;
output [4095:0] OUT;
wire [15:0] fst, max;
reg [15:0] count;
reg [287:0] SET;
reg [4095:0] STRM, OUT;
reg t1, t2, t3;

assign fst = 4 * 288;
assign max = fst + len;

always @(posedge clk or negedge reset) begin
    if(!reset) begin
        if(count <= max) begin
            if(count == 0) begin
                SET = {3'b111, 112'b0, IV, 13'b0, KEY};
            end
            t1 = SET[65]  ^ SET[92];
            t2 = SET[161] ^ SET[176];
            t3 = SET[242] ^ SET[287];
            if(fst <= count) begin
                STRM[len - count + fst - 1] = t1 ^ t2 ^ t3;
                // STRM[count - fst] = t1 ^ t2 ^ t3;
            end
            t1 = t1 ^ SET[90]  & SET[91]  ^ SET[170];
            t2 = t2 ^ SET[174] & SET[175] ^ SET[263];
            t3 = t3 ^ SET[285] & SET[286] ^ SET[68];
            SET   <= {SET[286:177], t2, SET[175:93], t1, SET[91:0], t3};
            count <= count + 1;
        end else begin
            OUT <= STRM;
        end
    end else begin
        count <= 0;
    end
end

endmodule

