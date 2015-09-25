module ENCRIPT (KEY, clk, reset, T1, T2, T3, SET);
input [3:0] KEY;
input clk, reset;
output T1, T2, T3;
output [3:0] SET;
reg T1, T2, T3;
reg [3:0]SET;

always @(posedge clk or negedge reset) begin
    if(!reset) begin
        T1  = SET[0] ^ SET[1];
        T2  <= SET[2] ^ T1;
        T3  = SET[3] ^ T2;
        SET <= {SET[3:0], T1 ^ T2 ^ T3};
    end else begin
        SET <= KEY;
        T1  <= 1;
        T2  <= 1;
        T3  <= 1;
    end
end

endmodule

