// SASEBO checker でやる時は右詰めで80bit
`timescale 1ns/1ns

module Trivium_Test;
    reg  [79:0] Kin;  // Key input
    reg  [79:0] Din;  // Data input
    // wire [127:0]Dout;// Data output
    wire Dout;// Data output
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

    Trivium_Comp Trivium_Comp (Kin, Din, Dout, Krdy, Drdy, EncDec, RSTn, EN, CLK, BSY, Kvld, Dvld);

    initial begin
        // repeat(1)   @(negedge CLK);
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
        Kin  <= 80'h00000000000000000000;
        @(posedge Kvld);
        Krdy <= 0;
        Kin  <= 80'bX;
        Drdy <= 1;
        Din  <= 80'h00000000000000000000;
        @(posedge BSY);
        Drdy <= 0;
        Din  <= 80'bX;
        @(posedge Dvld);
        repeat(10)  @(negedge CLK);
        $finish;
    end

    initial begin
        $monitor($time , "\nKEY=%h, IV=%h\nOUT=%h", Kin, Din, Dout);
        $dumpfile("Test.vcd");
        $dumpvars(0, Trivium_Test);
    end

endmodule
