`timescale 1ns/1ns

module test;
    reg  [79:0] KEY;
    reg  [79:0] IV;
    reg [11:0] len;
    reg clk;
    reg reset;
    wire [511:0] OUT;
    parameter times = 0.5;
    always #(times)   clk = ~clk;

    ENCRIPT ENCRIPT (KEY, IV, len, clk, reset, OUT);
    // ENCRIPT ENCRIPT (KEY, IV, clk, reset, OUT);

    initial begin
// Set 2, vector# 16:
//                          key = 10101010101010101010
//                           IV = 00000000000000000000
//                stream[0..63] = 4567A95BDBA94E17A52438D060DC8EF8
//                                20A7DA9E51E6F1D67247D3807F41338E
//                                3F8DE39BEF9E04BB9EE9F952B411A007
//                                D2F0E295B255A831C264C47D1C078A2B
//             stream[192..255] = F5393FE158303A91214E77B9A76FE062
//                                FD25B7F186137F0D5673B3E3B53CA3CF
//                                2F8B823820EA9646B77D4DBC4A22EF52
//                                D1498698229EAFD28EA151BF581481B6
//             stream[256..319] = C934D399C84DD90EBB1274208437C97C
//                                BDB3C43F65469D131BAD9B49800A9186
//                                EC066A6291706A792398EACF43D97F94
//                                3033B0A1FF96CE8448E37260D740D36D
//             stream[448..511] = EF7226C691BC2EE81DC34FBEAB365944
//                                4A7C976A4894CCFC6D558E73B2FBF33A
//                                1DB9FAAB1D11DB6293D7AC126399057D
//                                C1711DD057FE13395F69D69D37614134
//                   xor-digest = AB585980991C6ACD1889A72ECF42D41E
//                                6BB1EC325FFAD62E7A8514AA87ADAB84
//                                873B44D96413F3AF9AE1A93C02F3E591
//                                E2C4320B3BEA6BE96B1A9337E81AF2B7
        clk = 1'b0;
        // KEY = 80'h80000000000000000000;
        // IV  = 80'h00000000000000000000;
        KEY = 80'h10101010101010101010;
        IV  = 80'h00000000000000000000;
        len = 512;
        reset = 1;
        repeat(2) @(negedge clk);
        reset = 0;
        while(reset) @(negedge clk);
        @(negedge clk);
        repeat(2000) @(negedge clk);
        $finish;
    end

    initial begin
        $dumpfile("trivium.vcd");
        $dumpvars(0, test);
    end

endmodule
