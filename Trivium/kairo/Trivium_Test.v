// SASEBO checker でやる時は右詰めで80bit
`timescale 1ns/1ns

module Trivium_Test;
    reg  [79:0] Kin;  // Key input
    reg  [79:0] Din;  // Data input
    wire [127:0]Dout;// Data output
    // wire [4095:0]Dout;// Data output
    // wire Dout;// Data output
    reg  Krdy;        // Key input ready
    reg  Drdy;        // Data input ready
    reg  EncDec;      // 0:Encryption 1:Decryption
    reg  RSTn;        // Reset (Low active)
    reg  EN;          // Trivium circuit enable
    reg  CLK;         // System clock
    wire BSY;         // Busy signal
    wire Kvld;        // Data output valid
    wire Dvld;        // Data output valid
    parameter times = 0.5;
    always #(times)   CLK = ~CLK;
    integer i;
    reg [79:0] key [0:15];

    Trivium_Comp Trivium_Comp (Kin, Din, Dout, Krdy, Drdy, EncDec, RSTn, EN, CLK, BSY, Kvld, Dvld);

    initial begin
        // repeat(1)   @(negedge CLK);
        key [0] = 80'h06070809000000000000;
        key [1] = 80'h21134a33000000000000;
        key [2] = 80'h489db4b3000000000000;
        key [3] = 80'h5af119a4000000000000;
        key [4] = 80'h5e019ed6000000000000;
        key [5] = 80'h66c6f21f000000000000;
        key [6] = 80'h80000000000000000000;
        key [7] = 80'h8c4effe0000000000000;
        key [8] = 80'ha23c0791000000000000;
        key [9] = 80'had793e5a000000000000;
        for (i = 0; i < 10; i = i + 1) begin
            Krdy   = 0;
            Drdy   = 0;
            EncDec = 0;
            RSTn   = 1;
            CLK    = 0;
            EN     = 0;
            @(negedge CLK);
            RSTn <= 0;
            @(negedge CLK);
            RSTn <= 1;
            EN   <= 1;
            Krdy <= 1;
            Kin  <= key [i];
            @(posedge Kvld);
            Krdy <= 0;
            Kin  <= 80'bX;
            Drdy <= 1;
            Din  <= 80'h00000000000000000000;
            @(posedge BSY);
            Drdy <= 0;
            Din  <= 80'bX;
            @(posedge Dvld);
            repeat(3)  @(negedge CLK);
        end
        $finish;
    end

    initial begin
        // $monitor($time, "\nDout=%h", Dout);
        $dumpfile("Test.vcd");
        $dumpvars(0, Trivium_Test);
    end

endmodule
