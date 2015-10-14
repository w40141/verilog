module Trivium_Comp (Kin, Din, Dout, Krdy, Drdy, EncDec, RSTn, EN, CLK, BSY, Kvld, Dvld);

// input [159:0]  Kin;
// input [4095:0] Din;
input  [79:0] Kin;  // Key input
input  [79:0] Din;  // Data input
output [4095:0]Dout;// Data output
input  Krdy;        // Key input ready
input  Drdy;        // Data input ready
input  EncDec;      // 0:Encryption 1:Decryption
input  RSTn;        // Reset (Low active)
input  EN;          // Trivium circuit enable
input  CLK;         // System clock
output BSY;         // Busy signal
output Kvld;        // Data output valid
output Dvld;        // Data output valid

wire [15:0] fst, max;
wire [79:0] li_iv, li_key;
reg [15:0] count;
reg [287:0] SET;
reg z, t1, t2, t3;
reg BSYrg, Kvldrg, Dvkdrg;

assign len = 4095;
assign ini = 1152;
assign max = fst + len;
assign li_key = {Kin[7:0],   Kin[15:8],  Kin[23:16],  Kin[31:24],   Kin[39:32],   Kin[47:40],   Kin[55:48],   Kin[63:56],   Kin[71:64],   Kin[79:72]};
assign li_iv  = {Din[7:0],   Din[15:8],  Din[23:16],  Din[31:24],   Din[39:32],   Din[47:40],   Din[55:48],   Din[63:56],   Din[71:64],   Din[79:72]};
// assign li_iv  = {Kin[87:80], Kin[95:88], Kin[103:96], Kin[111:104], Kin[119:112], Kin[127:120], Kin[135:128], Kin[143:136], Kin[151:144], Kin[159:152]};

assign BSY  = BSYrg;
assign Kvld = Kvldrg;
assign Dvld = Dvldrg;
assign Dout[len - count + fst -1] = z;

always @(posedge CLK) begin
    if(RSTn == 0) begin
        SET    <= 0;
        count  <= 0;
        BSYrg  <= 0;
        Kvldrg <= 0;
        Dvldrg <= 0;
    end else if(EN == 1) begin
        if(EncDec == 0) begin
            if(Krdy == 1) begin
                SET    <= {3'b111, 112'b0, li_iv, 13'b0, li_key};
                count  <= count + 1;
                Kvldrg <= 1;
            end else if(Drdy == 1 | BSYrg ==1) begin
                Kvldrg <= 0;
                BSYrg  <= 1;
                if(count < max) begin
                    if(count == 0) begin
                    end
                    t1 = SET[65]  ^ SET[92];
                    t2 = SET[161] ^ SET[176];
                    t3 = SET[242] ^ SET[287];
                    if(fst <= count) begin
                        // z[len - count + fst - 1] = t1 ^ t2 ^ t3;
                        z = t1 ^ t2 ^ t3;
                    end
                    t1 = t1 ^ (SET[90]  & SET[91] ) ^ SET[170];
                    t2 = t2 ^ (SET[174] & SET[175]) ^ SET[263];
                    t3 = t3 ^ (SET[285] & SET[286]) ^ SET[68];
                    SET   <= {SET[286:177], t2, SET[175:93], t1, SET[91:0], t3};
                    count <= count + 1;
                end else begin
                    re_OUT <= z;
                end
            end
        end
    end
end

endmodule

