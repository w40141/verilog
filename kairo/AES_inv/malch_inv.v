`define RES 3'b000
`define STL 3'b001
`define ADD 3'b010
`define SUB 3'b011
`define SHI 3'b100
`define MIX 3'b101
`define INV 3'b110
`define FIN 3'b111

module malch_inv (IN, KEY, cs, clk, count, OUT, EXKEY);
input [127:0] IN, KEY;
input [2:0] cs;
input clk;
input [7:0] count;
output [127:0] OUT, EXKEY;
reg [127:0] OUT, EXKEY;
wire [127:0] add_out, sub_out, shi_out, mix_out, tmp_key, inv_key;

addRoundKey     add (IN, KEY, add_out);
subBytes128_inv sub (IN, sub_out);
expandKey       exp (KEY, count, tmp_key);
expandKey_inv   inv (KEY, count, inv_key);
shift128_inv    shi (IN, shi_out);
mixCol128_inv   mix (IN, mix_out);
always @(negedge clk) begin
    case (cs)
        `RES:begin
                OUT     <= IN;
                EXKEY   <= KEY;
            end
        `STL:begin
                OUT     <= IN;
                EXKEY   <= KEY;
            end
        `ADD:   OUT     <= add_out;
        `SUB:   OUT     <= sub_out;
        `SHI:begin
                OUT     <= shi_out;
                EXKEY   <= inv_key;
            end
        `MIX:   OUT     <= mix_out;
        `INV:begin
                EXKEY   <= tmp_key;
                OUT     <= IN;
        end
        `FIN:   OUT     <= IN;
        default:begin
                OUT     <= 127'hxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
                EXKEY   <= 127'hxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
            end
    endcase
end
endmodule
