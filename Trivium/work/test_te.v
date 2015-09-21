`timescale 1ns/1ns

module test;
    reg  [79:0] KEY;
    reg  [79:0] IV;
    reg [15:0] len;
    reg clk;
    reg reset;
    wire [4095:0] OUT;
    parameter times = 0.5;
    always #(times)   clk = ~clk;

    ENCRIPT ENCRIPT (KEY, IV, len, clk, reset, OUT);
    // ENCRIPT ENCRIPT (KEY, IV, clk, reset, OUT);

    initial begin
        //              key = 80000000000000000000
        //               IV = 00000000000000000000
        //    stream[0..63] = 7B75CECC2079BD99885A239A9FFC5112
        //                    55A6F0AF4EEEC87E2821D4BF08E6DA86
        //                    EBA76E8002C1AE58F488FA163EAAC3C5
        //                    F2C9BCB13F0B44BB9F9C34C43C7E0ABE
        // stream[192..255] = 2ED7D89766FB87722AA030036B6338D0
        //                    4E09767BF1719456A6E4C4617E2E41A0
        //                    A43111E55544EADC7A1FD43852CD5F68
        //                    2F143C565BB23BEB81FA5A7367E04528
        // stream[256..319] = 7762EA2C11982060398800E34F115A9D
        //                    867874CA8AA3FF128649FC239C26D855
        //                    6E26715C6B91A440E93D12888F3F86F0
        //                    9F565649C490FFC26AC01A1A8D73E069
        // stream[448..511] = 967AFF81855EFF378F543563AC4AE810
        //                    EABAC34346CD636FB55D9AD77BF69E9B
        //                    1797F347572939BA7F10F4AEE4CF1667
        //                    B5D6A1691482C61A6E4518207992E062
        //       xor-digest = D56432523DF30A9A2078D5ECD7D354AE
        //                    F1D8B4AE9685B5A9A24EA72FE03C4E06
        //                    B5565251A7B5738DFE4E696732C1C85B
        //                    8DD628257E606CEBA74D8F0FB3BE169A
        clk = 0;
        // KEY = 80'hffffffffffffffffffff;
        // IV  = 80'hffffffffffffffffffff;
        KEY = 80'h80000000000000000000;
        IV  = 80'h00000000000000000000;
        // len = 512 * 8;
        len = 4096;
        reset = 1;
        repeat(2) @(negedge clk);
        reset = 0;
        while(reset) @(negedge clk);
        @(negedge clk);
        repeat(20000) @(negedge clk);
        $finish;
    end

    initial begin
        $monitor($time, ", KEY=%h, IV=%h, OUT=%h", KEY, IV, OUT);
        $dumpfile("trivium.vcd");
        $dumpvars(0, test);
    end

endmodule
