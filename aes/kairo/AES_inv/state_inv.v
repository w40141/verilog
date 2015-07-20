`define RES 3'b000
`define STL 3'b001
`define ADD 3'b010
`define SUB 3'b011
`define SHI 3'b100
`define MIX 3'b101
`define INV 3'b110
`define FIN 3'b111

module state_inv (clk, res, cot, cs);
input clk, res;
output [7:0] cot;
output [2:0] cs;
reg [7:0] cot;
reg [2:0] cs;
always @(posedge clk or negedge res) begin
    if(res == 1'b0) begin
        if(cot < 8'h0a) begin
            case (cs)
                `RES:       cs  <= `STL;
                `INV:begin
                            cs <= `INV;
                            cot <= cot + 8'h01;
                    end
                `STL:begin
                            cs <= `INV;
                            cot <= cot + 8'h01;
                    end
                default:    cs  <= `RES;
            endcase
        end else begin
            case (cs)
                `INV:       cs  <= `STL;
                `STL:       cs  <= `ADD;
                `ADD:   if(8'h0a == cot)
                            cs  <= `SHI;
                        else if(cot < 8'h14)
                            cs  <= `MIX;
                        else
                            cs  <= `FIN;
                `MIX:       cs  <= `SHI;
                `SHI:begin
                            cs  <= `SUB;
                            cot <= cot + 8'h01;
                    end
                `SUB:       cs  <= `ADD;
                `FIN:       cs  <= `FIN;
                default:    cs  <= `RES;
            endcase
        end
    end else begin
        cs  <= `RES;
        cot <= 0;
    end
end
endmodule
