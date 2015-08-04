module INIT_1 (KEY, IV, OUT);
    input [79:0] KEY, IV;
    output [287:0] OUT;

    assign OUT[79:0]    = KEY;
    assign OUT[92:80]   = 0;
    assign OUT[172:93]  = IV;
    assign OUT[284:173] = 0;
    assign OUT[287:285] = 3'b111;
endmodule
