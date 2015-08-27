`define sw_in0 10'b0000000001
`define sw_in1 10'b0000000010
`define sw_in2 10'b0000000100
`define sw_in3 10'b0000001000
`define sw_in4 10'b0000010000
`define sw_in5 10'b0000100000
`define sw_in6 10'b0001000000
`define sw_in7 10'b0010000000
`define sw_in8 10'b0100000000
`define sw_in9 10'b1000000000

module ENC(IN, OUT);
    input [9:0] IN;
    output [3:0] OUT;
    assign OUT = FUNC_ENC(IN);

    function [3:0]FUNC_ENC;
        input [9:0] IN;
        case (IN)
            `sw_in0 : FUNC_ENC = 0;
            `sw_in1 : FUNC_ENC = 1;
            `sw_in2 : FUNC_ENC = 2;
            `sw_in3 : FUNC_ENC = 3;
            `sw_in4 : FUNC_ENC = 4;
            `sw_in5 : FUNC_ENC = 5;
            `sw_in6 : FUNC_ENC = 6;
            `sw_in7 : FUNC_ENC = 7;
            `sw_in8 : FUNC_ENC = 8;
            `sw_in9 : FUNC_ENC = 9;
            default : FUNC_ENC = 15;
        endcase
    endfunction

endmodule

