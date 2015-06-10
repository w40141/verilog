`timescale 1ns/1ns
module SEL_TEST;
    reg [3:0] IN;
    reg [1:0] SEL_IN;
    wire OUT;

    SEL     SEL     (IN[0], IN[1], IN[2], IN[3], SEL_IN, OUT);
    always  #100    SEL_IN = SEL_IN + 1;
    always  #40     IN = IN + 1;
    initial begin
                    IN = 0;SEL_IN = 0;
            #700    $finish;
    end

    initial begin
        $dumpfile("sel4-1.vcd");
        $dumpvars(0, SEL_TEST);
    end
endmodule
