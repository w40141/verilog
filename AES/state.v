`define RES 3'b000
`define ADD 3'b001
`define SUB 3'b010
`define EXP 3'b011
`define SHI 3'b100
`define MIX 3'b101
`define FIN 3'b111

module state (clk, res, cot, cs);
input clk, res;
output [7:0] cot;
output [2:0] cs;
reg [7:0] cot;
reg [2:0] cs;
always @(posedge clk or negedge res) begin
    if(res) begin
        cs  <= `RES;
        cot <= 0;
    end else begin
        if(clk) begin
            case (cs)
                `RES:                   cs  <= `ADD;
                `ADD:   if(cot > 8'h09) cs  <= `FIN;
                        else begin
                                        cs  <= `SUB;
                                        cot <= cot + 8'h01;
                        end
                `SUB:                   cs  <= `SHI;
                `SHI:   if(cot >8'h09)  cs  <= `ADD;
                        else            cs  <= `MIX;
                `MIX:                   cs  <= `ADD;
                `FIN:                   cs  <= `FIN;
                default:                cs  <= `RES;
            endcase
        end
    end
end
endmodule
