module ENCRIPT (clk, reset, OUT);
    input clk, reset;
    output [63:0] OUT;
    reg [63:0] OUT;

    always @(posedge clk or negedge reset) begin
        if(reset == 1'b0) begin
            OUT <= {OUT[62:0], OUT[63]};
        end else begin
            OUT <= 64'h0001;
        end
    end

endmodule

