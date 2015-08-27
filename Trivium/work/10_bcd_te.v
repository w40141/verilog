`timescale 1ns/1ns

module ENC_TE;
reg [9:0] IN;
wire [3:0] OUT;
integer i, j;

ENC ENC (IN, OUT);
initial begin
    j = {5'b10001, 9'b0, 1'b1};
    for (i = 0; i <= 15; i = i + 1) begin
        j = j << 1;
        IN = j[15:6];
        #100;
    end
    $finish;
end

initial begin
    #0      $display($time, "IN=%h, OUT=%h", IN, OUT);
    #100    $display($time, "IN=%h, OUT=%h", IN, OUT);
    #100    $display($time, "IN=%h, OUT=%h", IN, OUT);
    #100    $display($time, "IN=%h, OUT=%h", IN, OUT);
    #100    $display($time, "IN=%h, OUT=%h", IN, OUT);
    #100    $display($time, "IN=%h, OUT=%h", IN, OUT);
    #100    $display($time, "IN=%h, OUT=%h", IN, OUT);
    #100    $display($time, "IN=%h, OUT=%h", IN, OUT);
    #100    $display($time, "IN=%h, OUT=%h", IN, OUT);
    #100    $display($time, "IN=%h, OUT=%h", IN, OUT);
    #100    $display($time, "IN=%h, OUT=%h", IN, OUT);
    #100    $display($time, "IN=%h, OUT=%h", IN, OUT);
    #100    $display($time, "IN=%h, OUT=%h", IN, OUT);
    #100    $display($time, "IN=%h, OUT=%h", IN, OUT);
    #100    $display($time, "IN=%h, OUT=%h", IN, OUT);
    #100    $display($time, "IN=%h, OUT=%h", IN, OUT);
end

initial begin
    $dumpfile("bcd.vcd");
    $dumpvars(0, ENC_TE);
end
endmodule
