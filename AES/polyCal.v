module polyCal (x, y, d);
    input [7:0] x, y;
    output [7:0] d;
    wire [7:0] f0, f1, f2, f3, f4, f5, f6, f7;

    assign f0 = (y[0] == 1)? (x) : (0);
    assign f1 = FUNC_CAL(x,  y[1]);
    assign f2 = FUNC_CAL(f1, y[2]);
    assign f3 = FUNC_CAL(f2, y[3]);
    assign f4 = FUNC_CAL(f3, y[4]);
    assign f5 = FUNC_CAL(f4, y[5]);
    assign f6 = FUNC_CAL(f5, y[6]);
    assign f7 = FUNC_CAL(f6, y[7]);

    assign d = f0 ^ f1 ^ f2 ^ f3 ^ f4 ^ f5 ^ f6 ^ f7;

    function [7:0] FUNC_CAL;
        input [7:0] x;
        input y;
        reg [7:0] fx;

        if(y == 1)
            if(x[7] == 0)
                FUNC_CAL = (x[6:0], 1'b0);
            else
                fx = (x[6:0], 1'b0);
                FUNC_CAL = fx ^ 8'b00011011;
        else
            FUNC_CAL = 0;

    endfunction

endmodule
