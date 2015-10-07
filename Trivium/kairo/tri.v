// module ENCRIPT (KEY, IV, len, clk, reset, OUT);
module ENCRIPT (KEY, IV, len, clk, reset, re_OUT);
input [79:0] KEY, IV;
input [15:0] len;
input clk, reset;
// output OUT;
output [4095:0] re_OUT;
wire [15:0] fst, max;
wire [79:0] li_iv, li_key;
reg [15:0] count;
reg [287:0] SET;
reg t1, t2, t3;
// reg bit_out;
reg [4095:0] z, re_OUT;

assign fst = 4 * 288;
assign max = fst + len;
assign li_key = {KEY[7:0], KEY[15:8], KEY[23:16], KEY[31:24], KEY[39:32], KEY[47:40], KEY[55:48], KEY[63:56], KEY[71:64], KEY[79:72]};
assign li_iv  = {IV[7:0], IV[15:8], IV[23:16], IV[31:24], IV[39:32], IV[47:40], IV[55:48], IV[63:56], IV[71:64], IV[79:72]};

always @(posedge clk or negedge reset) begin
    if(!reset) begin
        if(count <= max) begin
            if(count == 0) begin
                SET = {3'b111, 112'b0, li_iv, 13'b0, li_key};
            end
            t1 = SET[65]  ^ SET[92];
            t2 = SET[161] ^ SET[176];
            t3 = SET[242] ^ SET[287];
            if(fst <= count) begin
                // bit_out = t1 ^ t2 ^ t3;
                z[len - count + fst - 1] = t1 ^ t2 ^ t3;
            end
            t1 = t1 ^ (SET[90]  & SET[91] ) ^ SET[170];
            t2 = t2 ^ (SET[174] & SET[175]) ^ SET[263];
            t3 = t3 ^ (SET[285] & SET[286]) ^ SET[68];
            SET   <= {SET[286:177], t2, SET[175:93], t1, SET[91:0], t3};
            count <= count + 1;
        end else begin
            re_OUT <= z;
        end
    end else begin
        count <= 0;
    end
end

// assign OUT = bit_out;

endmodule

