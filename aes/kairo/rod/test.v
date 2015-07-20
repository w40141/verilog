`timescale 1ns/1ns

module test;
reg [127:0] IN, KEY;
wire [127:0] ENC;
roundFunc round (IN, KEY, ENC);
initial begin
    IN  = 127'h00112233445566778899aabbccddeeff;
    KEY = 127'h000102030405060708090a0b0c0d0e0f;
    #100;   $finish;
end

initial begin
    $dumpfile("test.vcd");
    $dumpvars(0, test);
end

endmodule
