module selectKey (in_key, cot, out_key);
input clk, res;
output [7:0] cot;
output [2:0] cs;
reg [7:0] cot;
reg [2:0] cs;
always @(posedge clk or negedge res) begin
    if(res) begin
        cs  <= `RES;
        cot <= 10;
    end else begin
        case (cs)
            `RES:                   cs  <= `STL;
            `STL:                   cs  <= `ADD;
            `ADD:   if(cot > 8'h09) cs  <= `SHI;
                    else if(cot > 0) begin
                                    cs  <= `MIX;
                                    cot <= cot - 8'h01;
                    end else        cs  <= `FIN;
            `MIX:                   cs  <= `SHI;
            `SHI:                   cs  <= `SUB;
            `SUB:                   cs  <= `ADD;
            `FIN:                   cs  <= `FIN;
            default:                cs  <= `RES;
        endcase
    end
end
endmodule
