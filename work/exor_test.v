`timescale 1ns/1ns
module EXOR_TE;
    reg     [1:0]IN;
    wire    OUT;
    integer i;

    EXOR    EXOR    (IN[0], IN[1], OUT);
    initial begin
        IN = 0;
        for (i = 0; i <= 4; i = i + 1) begin
            #100    IN = IN + 1;
        end
        $finish;
    end

    initial begin
        $dumpfile("exor.vcd");
        $dumpvars(0, EXOR_TE);
    end

endmodule
