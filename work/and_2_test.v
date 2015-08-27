`timescale 1ns/1ns

module and_2_test;
    reg IN1, IN2;
    wire OUT;
    and_2 and_2 (IN1, IN2, OUT);
    initial begin
                IN1=0;  IN2=0;
        #100    IN1=1;
        #100    IN1=0;  IN2=1;
        #100    IN1=1;
        #200    $finish;
    end

    initial begin
        $monitor($time, "IN1=%b, IN2=%b, OUT=%b", IN1, IN2, OUT);
        $dumpfile("waves.vcd");
        $dumpvars(0, and_2_test);
    end
endmodule
