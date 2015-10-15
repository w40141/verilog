`timescale 1ns/1ns

module Trivium_Test;
    reg  [79:0] Kin;  // Key input
    reg  [79:0] Din;  // Data input
    wire [4095:0]Dout;// Data output
    // wire Dout;        // Data output
    reg  Krdy;        // Key input ready
    reg  Drdy;        // Data input ready
    reg  EncDec;      // 0:Encryption 1:Decryption
    reg  RSTn;        // Reset (Low active)
    reg  EN;          // Trivium circuit enable
    reg  CLK;         // System clock
    wire BSY;         // Busy signal
    wire Kvld;        // Data output valid
    wire Dvld;        // Data output valid
    parameter times = 1;
    always #(times)   CLK = ~CLK;

    Trivium_Comp Trivium_Comp (Kin, Din, Dout, Krdy, Drdy, EncDec, RSTn, EN, CLK, BSY, Kvld, Dvld);

    initial begin
        Kin    = 80'hFF000102030405060708;
        Din    = 80'h00000000000000000000;
        Krdy   = 0;
        Drdy   = 0;
        EncDec = 0;
        RSTn   = 1;
        CLK    = 0;
        EN     = 0;
        repeat(1)   @(negedge CLK);
        RSTn <= 0;
        repeat(1)   @(negedge CLK);
        RSTn <= 1;
        EN   <= 1;
        repeat(1)   @(negedge CLK);
        Krdy <= 1;
        @(posedge Kvld);
        @(negedge CLK);
        Krdy <= 0;
        Drdy <= 1;
        @(posedge BSY)
        Drdy <= 0;
        while(BSY)  @(negedge CLK);
        repeat(10) @(negedge CLK);
        $finish;
    end

    initial begin
        $monitor($time , "\nKEY=%h, IV=%h\nOUT=%h", Kin, Din, Dout);
        $dumpfile("Test.vcd");
        $dumpvars(0, Trivium_Test);
    end

endmodule
