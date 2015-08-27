`define RES 3'b000
`define ADD 3'b001
`define SUB 3'b010
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
always @(posedge clk) begin
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


module round (IN, KEY, clk, reset, ENC);
input [127:0] IN, KEY;
input clk, reset;
output [127:0] ENC;
reg [127:0] ENC;

wire [2:0] cs;
wire [7:0] count;
wire [127:0] OUT, EXKEY;
reg  [127:0] inp, keyp;

state   state   (clk, reset, count, cs);
malch   malch   (inp, keyp, cs, clk, count, OUT, EXKEY);

always @(cs or negedge reset) begin
    if(reset) begin
        inp  <= IN;
        keyp <= KEY;
    end else begin
        if(cs == `FIN)  ENC <= OUT;
        else begin
            ENC  <= 127'bz;
            inp  <= OUT;
            keyp <= EXKEY;
        end
    end
end
endmodule
