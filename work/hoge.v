`define def_BUF     3'b000
`define def_AND_2   3'b001
`define def_OR_3    3'b010
`define def_NAND_2  3'b011
`define def_NOR_2   3'b100
`define def_NOT     3'b101
`define def_FIN     3'b111

module state (clk, res, cot, cs);
input clk, res;
output [7:0] cot;
output [2:0] cs;
reg [7:0] cot;
reg [2:0] cs;

always @(posedge clk or negedge res) begin
    if(res) begin
        cs  <= `def_BUF;
        cot <= 0;
    end else begin
        case (cs)
            `def_BUF:                   cs  <= `def_AND_2;
            `def_AND_2: if(cot > 8'h09) cs  <= `def_FIN;
                        else begin
                                        cs  <= `def_OR_3;
                                        cot <= cot + 8'h01;
                        end
            `def_OR_3:                  cs  <= `def_NAND_2;
            `def_NAND_2:                cs  <= `def_NOR_2;
            `def_NOR_2: if(cot >8'h08)  cs  <= `def_AND_2;
                        else            cs  <= `def_NOT;
            `def_NOT:                   cs  <= `def_AND_2;
            `def_FIN:                   cs  <= `def_FIN;
            default:                    cs  <= `def_FIN;
        endcase
    end
end
endmodule


module cal (IN1, IN2, IN3, cs, cot, OUT);
input IN1, IN2, IN3;
input [2:0] cs;
input [7:0] cot;
wire and_out, or_out, nand_out, nor_out, not_out, buf_out;
output OUT;
reg OUT;

AND_2   and_2   (IN1, IN2, and_out);
OR_3    or_3    (IN1, IN2, IN3, or_out);
NAND_2  nand_2  (IN1, IN2, nand_out);
NOR_2   nor_2   (IN1, IN2, nor_out);
NOT     not_0   (IN1, not_out);
BUF     buf_0   (IN1, buf_out);

always @(cs) begin
    case (cs)
        `def_AND_2:     OUT <= and_out;
        `def_OR_3:      OUT <= or_out;
        `def_NAND_2:    OUT <= nand_out;
        `def_NOR_2:     OUT <= nor_out;
        `def_NOT:       OUT <= not_out;
        `def_BUF:       OUT <= buf_out;
        `def_FIN:       OUT <= 1;
        default:        OUT <= 0;
    endcase
end

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
