module round (IN, KEY, OUT);
input [127:0] IN, KEY;
output [127:0] OUT;
endmodule


module state (clk, reset, run, cont, halt, cs);
input clk, reset, run, cont, halt;
output [2:0] cs;
reg [2:0] cs;

always @(posedge clk or negedge reset) begin
    if(!reset) cs 
        <`2:/* code */`>
    else
        <`3:/* code */`>
end
endmodule
