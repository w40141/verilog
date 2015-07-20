`define RES 3'b000
`define STL 3'b001
`define ADD 3'b010
`define SUB 3'b011
`define SHI 3'b100
`define MIX 3'b101
`define INV 3'b110
`define FIN 3'b111

module round_inv (IN, KEY, clk, reset, ENC);
input [127:0] IN, KEY;
input clk, reset;
output [127:0] ENC;
reg [127:0] ENC;

wire [2:0] cs;
wire [7:0] count;
wire [127:0] OUT, EXKEY;
reg  [127:0] inp, keyp;

state_inv   state   (clk, reset, count, cs);
malch_inv   malch   (inp, keyp, cs, clk, count, OUT, EXKEY);
always @(posedge clk or negedge reset) begin
    if(reset == 1'b0) begin
        if(cs == `FIN) ENC <= OUT;
        else begin
            ENC  <= 127'bz;
            inp  <= OUT;
            keyp <= EXKEY;
        end
    end else begin
        inp  <= IN;
        keyp <= KEY;
    end
end
endmodule
