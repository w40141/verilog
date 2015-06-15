`timescale 1ns/1ns

module test;
    reg [127:0] in_ex;
    reg [7:0] count;
    reg [31:0] in_rw;
    wire [127:0] key;
    wire [31:0] out_rw;
    integer i;

    rotWord rw (in_rw, out_rw);
    expandKey ex (in_ex, count, key);
    initial begin
        in_ex = 127'h0102030405060708090a0b0c0d0e0f; count=8'h01; in_rw = in_ex[31:0];
        for (i = 1; i < 10; i = i + 1) begin
            #100    count = count + 1;  in_ex = key; in_rw = in_ex[31:0];
        end
        #100    $finish;
    end

    initial begin
        #0      $display($time, "in_ex=%h, count=%h, key=%h, out_rw=%h", in_ex, count, key, out_rw);
        #100    $display($time, "in_ex=%h, count=%h, key=%h, out_rw=%h", in_ex, count, key, out_rw);
        #100    $display($time, "in_ex=%h, count=%h, key=%h, out_rw=%h", in_ex, count, key, out_rw);
        #100    $display($time, "in_ex=%h, count=%h, key=%h, out_rw=%h", in_ex, count, key, out_rw);
        #100    $display($time, "in_ex=%h, count=%h, key=%h, out_rw=%h", in_ex, count, key, out_rw);
        #100    $display($time, "in_ex=%h, count=%h, key=%h, out_rw=%h", in_ex, count, key, out_rw);
        #100    $display($time, "in_ex=%h, count=%h, key=%h, out_rw=%h", in_ex, count, key, out_rw);
        #100    $display($time, "in_ex=%h, count=%h, key=%h, out_rw=%h", in_ex, count, key, out_rw);
        #100    $display($time, "in_ex=%h, count=%h, key=%h, out_rw=%h", in_ex, count, key, out_rw);
        #100    $display($time, "in_ex=%h, count=%h, key=%h, out_rw=%h", in_ex, count, key, out_rw);
        #100    $display($time, "in_ex=%h, count=%h, key=%h, out_rw=%h", in_ex, count, key, out_rw);
    end

    initial begin
        $dumpfile("expand.vcd");
        $dumpvars(0, test);
    end

endmodule
