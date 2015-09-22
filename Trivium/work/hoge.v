module ENCRIPT (KEY, clk, reset, T1, T2, T3);
input [7:0] KEY;
input clk, reset;
output T1, T2, T3;
reg T1, T2, T3;
reg [7:0]SET;

always @(posedge clk or negedge reset) begin
    if(!reset) begin
        T1  <= SET[0] ^ SET[1];
        T2  <= SET[2] ^ SET[3];
        T3  <= SET[4] ^ SET[5];
        SET = {SET[6:0], T1 ^ T2 ^ T3};
    end else SET <= KEY;
end

endmodule

