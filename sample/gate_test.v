`timescale  1ns/1ns

module gate_test;
    reg     IN1, IN2, IN3;
    wire    OUT_and, OUT_or, OUT_nand, OUT_nor, OUT_not, OUT_buf;

    parameter STEP = 100;

    gate gate (IN1, IN2, IN3, OUT_and, OUT_or, OUT_nand, OUT_nor, OUT_not, OUT_buf);

    initial begin
                IN1 = 0;    IN2 = 0;    IN3 = 0;
        #STEP   IN1 = 1;
        #STEP   IN1 = 0;    IN2 = 1;
        #STEP   IN1 = 1;
        #STEP   IN1 = 0;    IN2 = 0;    IN3 = 1;
        #STEP   IN1 = 1;
        #STEP   IN1 = 0;    IN2 = 1;
        #STEP   IN1 = 1;
        #STEP   $finish;
    end

    initial begin
        $dumpfile("gate_waves.vcd");
        $dumpvars(0, gate_test);
    end
endmodule
