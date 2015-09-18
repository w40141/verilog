module ENCRIPT (KEY, clk, reset, OUT_1, OUT_2, OUT_3);
input [3:0] KEY;
input clk, reset;
output OUT_1, OUT_2, OUT_3;
reg [3:0] SET;
reg OUT_1, OUT_2, OUT_3;

always @(posedge clk or negedge reset) begin
    if(!reset) begin
        OUT_1 = SET[0] ^ SET[1] & SET[2];
        OUT_2 = OUT_1 ^ SET[3];
        OUT_3 = OUT_2 & OUT_1;
        SET   = {SET[2:0], OUT_3};
    end else begin
        SET <= KEY;
    end
end

endmodule

