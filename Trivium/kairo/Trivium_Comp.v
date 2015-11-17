module Trivium_Comp (Kin, Din, Dout, Krdy, Drdy, EncDec, RSTn, EN, CLK, BSY, Kvld, Dvld);

input  [79:0] Kin;  // Key input
input  [79:0] Din;  // Data input
// output [127:0]Dout;// Data output
output Dout;// Data output
input  Krdy;        // Key input ready
input  Drdy;        // Data input ready
input  EncDec;      // 0:Encryption 1:Decryption
input  RSTn;        // Reset (Low active)
input  EN;          // Trivium circuit enable
input  CLK;         // System clock
output BSY;         // Busy signal
output Kvld;        // Data output valid
output Dvld;        // Data output valid

wire [15:0] len, max;
wire [79:0] li_iv, li_key;
reg [15:0] count;
reg [287:0] SET;
reg t1, t2, t3;
reg BSYrg, Kvldrg, Dvldrg;
// reg [127:0]Doutrg;
reg Doutrg;

assign len = 128;
assign max = 1152 + len;
assign li_key = {Kin[7:0], Kin[15:8], Kin[23:16], Kin[31:24], Kin[39:32], Kin[47:40], Kin[55:48], Kin[63:56], Kin[71:64], Kin[79:72]};
assign li_iv  = {Din[7:0], Din[15:8], Din[23:16], Din[31:24], Din[39:32], Din[47:40], Din[55:48], Din[63:56], Din[71:64], Din[79:72]};

assign BSY  = BSYrg;
assign Kvld = Kvldrg;
assign Dvld = Dvldrg;
assign Dout = Doutrg;

always @(posedge CLK) begin
    if(!RSTn) begin
        BSYrg  <= 0;
        Kvldrg <= 0;
        Dvldrg <= 0;
        count  <= 0;
    end else if(EN) begin
        if(Dvldrg) Dvldrg <= 0;
        if(Kvldrg) Kvldrg <= 0;
        if(!EncDec) begin
            if(!BSYrg) begin
                if(Krdy) begin
                    SET    <= {3'b111, 205'b0, li_key};
                    Kvldrg <= 1;
                end else if(Drdy) begin
                    BSYrg       <= 1;
                    SET[172:93] <= li_iv;
                end
            end else begin
                if(max < count) begin
                    Dvldrg <= 1;
                    BSYrg  <= 0;
                    count  <= 0;
                end else begin
                    t1 = SET[65]  ^ SET[92];
                    t2 = SET[161] ^ SET[176];
                    t3 = SET[242] ^ SET[287];
                    // if(1152 <= count) Doutrg[max - count] <= t1 ^ t2 ^ t3;
                    if(1152 <= count) Doutrg <= t1 ^ t2 ^ t3;
                    t1 = t1 ^ (SET[90]  & SET[91] ) ^ SET[170];
                    t2 = t2 ^ (SET[174] & SET[175]) ^ SET[263];
                    t3 = t3 ^ (SET[285] & SET[286]) ^ SET[68];
                    SET   <= {SET[286:177], t2, SET[175:93], t1, SET[91:0], t3};
                    count <= count + 1;
                end
            end
        end
    end
end

endmodule

