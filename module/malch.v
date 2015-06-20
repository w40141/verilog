// addroundkey.v
// subbytes128.v
// expandkey.v
// mixcol128.v
// shift128.v

`define RES 3'b000
`define STL 3'b001
`define ADD 3'b010
`define SUB 3'b011
`define SHI 3'b100
`define MIX 3'b101
`define FIN 3'b111

module malch (IN, KEY, cs, clk, count, OUT, EXKEY);
input [127:0] IN, KEY;
input [2:0] cs;
input [7:0] count;
input clk;
output [127:0] OUT, EXKEY;
reg [127:0] OUT, EXKEY;
wire [127:0] add_out, sub_out, shi_out, mix_out, tmp_key;

addRoundKey add (IN, KEY, add_out);
subBytes128 sub (IN, sub_out);
expandKey   exp (KEY, count, tmp_key);
shift128    shi (IN, shi_out);
mixCol128   mix (IN, mix_out);
// always @(posedge clk) begin
always @(negedge clk) begin
    if(cs == `RES) begin
        OUT     <= IN;
        EXKEY   <= KEY;
    end else begin
        case (cs)
            `ADD:   OUT     <= add_out;
            `SUB:   OUT     <= sub_out;
            `SHI:begin
                    OUT     <= shi_out;
                    EXKEY   <= tmp_key;
                end
            `MIX:   OUT     <= mix_out;
            `FIN:   OUT     <= IN;
            default:begin
                    OUT     <= 127'hxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
                    EXKEY   <= 127'hxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
            end
        endcase
    end
end
endmodule
