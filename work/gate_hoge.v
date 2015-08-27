module gate (IN1, IN2, IN3, OUT_and, OUT_or, OUT_nand, OUT_nor, OUT_not, OUT_buf);
    input       IN1, IN2, IN3;
    output      OUT_and, OUT_or, OUT_nand, OUT_nor, OUT_not, OUT_buf;
    AND_2   AND_2   (IN1, IN2, OUT_and);
    OR_3     OR_3     (IN1, IN2, IN3, OUT_or);
    NAND_2  NAND_2  (IN1, IN2, OUT_nand);
    NOR_2   NOR_2   (IN1, IN2, OUT_nor);
    NOT     NOT     (IN1, OUT_not);
    BUF     BUF     (IN1, OUT_buf);
endmodule


module AND_2(IN1, IN2, OUT);
    input   IN1, IN2;
    output  OUT;
    assign  OUT = IN1 & IN2;
endmodule


module OR_3(IN1, IN2, IN3, OUT);
    input   IN1, IN2, IN3;
    output  OUT;
    assign  OUT = IN1 | IN2 | IN3;
endmodule


module NAND_2(IN1, IN2, OUT);
    input   IN1, IN2;
    output  OUT;
    assign  OUT = ~(IN1 & IN2);
endmodule


module NOR_2(IN1, IN2, OUT);
    input   IN1, IN2;
    output  OUT;
    assign  OUT = ~(IN1 | IN2);
endmodule


module NOT(IN, OUT);
    input   IN;
    output  OUT;
    assign  OUT = ~IN;
endmodule


module BUF(IN, OUT);
    input   IN;
    output  OUT;
    assign  OUT = IN;
endmodule
