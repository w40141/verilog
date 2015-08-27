`define FIN 3'b111

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

//always @(cs or negedge reset) begin
always @(posedge clk or negedge reset) begin
    if(reset == 1'b0) begin
        inp  <= IN;
        keyp <= KEY;
    end else begin
        if(cs == `FIN) begin
          ENC <= OUT;
      end
        else begin
            ENC  <= 127'bz;
            inp  <= OUT;
            keyp <= EXKEY;
        end
    end
end
endmodule
