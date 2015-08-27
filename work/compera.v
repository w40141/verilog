module COMP(X, Y, LG, EQ, RL);
    input [1:0] X, Y;
    output LG, EQ, RL;
    assign {LG, EQ, RL} = FUNC_COMP(X, Y);

    function [2:0]FUNC_COMP;
        input [1:0] X, Y;
        begin
            if(X > Y) begin
                FUNC_COMP = 3'b100;
            end else if(X < Y) begin
                FUNC_COMP = 3'b001;
            end else begin
                FUNC_COMP = 3'b010;
            end
        end
    endfunction

endmodule

