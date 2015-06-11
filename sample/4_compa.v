module COMP(X, Y, LG_OUT, EQ_OUT, RG_OUT);
    input [3:0] X, Y;
    output LG_OUT, EQ_OUT, RG_OUT;
    wire [2:0] LG, EQ, RG;
    FULL_COMP   COMP0   (X[0], Y[0], 1'b0, 1'b1, 1'b0, LG[0], EQ[0], RG[0]),
                COMP1   (X[1], Y[1], LG[0], EQ[0], RG[0], LG[1], EQ[1], RG[1]),
                COMP2   (X[2], Y[2], LG[1], EQ[1], RG[1], LG[2], EQ[2], RG[2]),
                COMP3   (X[3], Y[3], LG[2], EQ[2], RG[2], LG_OUT, EQ_OUT, RG_OUT);
endmodule

module FULL_COMP(X, Y, LG_IN, EQ_IN, RG_IN, LG_OUT, EQ_OUT, RG_OUT);
    input X, Y;
    input LG_IN, EQ_IN, RG_IN;
    output LG_OUT, EQ_OUT, RG_OUT;
    assign {LG_OUT, EQ_OUT, RG_OUT} = FUNC_COMP(X, Y, LG_IN, EQ_IN, RG_IN);

    function [2:0]FUNC_COMP;
        input x, y;
        input lg_in, eq_in, rg_in;
        if(x > y)
            FUNC_COMP = 3'b100;
        else if(x < y)
            FUNC_COMP = 3'b001;
        else
            if(lg_in)
                FUNC_COMP = 3'b100;
            else if(eq_in)
                FUNC_COMP = 3'b010;
            else
                FUNC_COMP = 3'b001;
    endfunction

endmodule
