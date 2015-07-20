`timescale 1ns/1ns

module state_inv_te;
reg clk, reset;
reg [127:0] IN, KEY;
wire [127:0] ENC;
parameter times = 0.5;
always #(times)   clk = ~clk;

round_inv round (IN, KEY, clk, reset, ENC);

initial begin
    clk = 1'b0;
    IN  = 128'h69c4e0d86a7b0430d8cdb78070b4c55a;
    KEY = 128'h000102030405060708090a0b0c0d0e0f;
    reset = 1;
    repeat(2) @(negedge clk);
    reset = 0;
    @(negedge clk);
    while(reset) @(negedge clk);
    repeat(100) @(negedge clk);
    $finish;
end

initial begin
    $dumpfile("state_inv.vcd");
    $dumpvars(0, state_inv_te);
end

endmodule
