module polyCal (x, y, d);
    input [7:0] x, y;
    output [7:0] d;
    wire [7:0] f0, f1, f2, f3, f4, f5, f6, f7;

    assign f0 = (y[0] == 1)? (x) : (8'b0);
    assign f1 = (y[1] == 1)? ((f0[7] == 1)? () : (f0[6:0], 1'b0)) : (8'b0);
    assign f1 = FUNC_CAL(f0, y[1]);


    assign d = f0 ^ f1 ^ f2 ^ f3 ^ f4 ^ f5 ^ f6 ^ f7;<`4`>

    function FUNC_CAL;
        input [7:0] x;
        input y;

        if(y)
            if(x[7])
                (x[6:0], 1'b0)
            else
                <`3:/* code */`>
        else if(<`3:condition`>)
            <`4:/* code */`>
        else
            <`5:/* code */`>;
    endfunction
endmodule
