// kakuninn
module garoaCal (x, y, d);
    input [7:0] x, y;
    output [7:0] d;
    wire [14:0] c;

    assign c[0]  = x[0] & y[0];
    assign c[1]  = x[1] & y[0] ^ x[0] & y[1];
    assign c[2]  = x[2] & y[0] ^ x[1] & y[1] ^ x[0] & y[2];
    assign c[3]  = x[3] & y[0] ^ x[2] & y[1] ^ x[1] & y[2] ^ x[0] & y[3];
    assign c[4]  = x[4] & y[0] ^ x[3] & y[1] ^ x[2] & y[2] ^ x[1] & y[3] ^ x[0] & y[4];
    assign c[5]  = x[5] & y[0] ^ x[4] & y[1] ^ x[3] & y[2] ^ x[2] & y[3] ^ x[1] & y[4] ^ x[0] & y[5];
    assign c[6]  = x[6] & y[0] ^ x[5] & y[1] ^ x[4] & y[2] ^ x[3] & y[3] ^ x[2] & y[4] ^ x[1] & y[5] ^ x[0] & y[6];
    assign c[7]  = x[7] & y[0] ^ x[6] & y[1] ^ x[5] & y[2] ^ x[4] & y[3] ^ x[3] & y[4] ^ x[2] & y[5] ^ x[1] & y[6] ^ x[0] & y[7];
    assign c[8]  = x[7] & y[1] ^ x[6] & y[2] ^ x[5] & y[3] ^ x[4] & y[4] ^ x[3] & y[5] ^ x[2] & y[6] ^ x[1] & y[7];
    assign c[9]  = x[7] & y[2] ^ x[6] & y[3] ^ x[5] & y[4] ^ x[4] & y[5] ^ x[3] & y[6] ^ x[2] & y[7];
    assign c[10] = x[7] & y[3] ^ x[6] & y[4] ^ x[5] & y[5] ^ x[4] & y[6] ^ x[3] & y[7];
    assign c[11] = x[7] & y[4] ^ x[6] & y[5] ^ x[5] & y[6] ^ x[4] & y[7];
    assign c[12] = x[7] & y[5] ^ x[6] & y[6] ^ x[5] & y[7];
    assign c[13] = x[7] & y[6] ^ x[6] & y[7];
    assign c[14] = x[7] & y[7];

    assign d[0] = c[0] ^ c[ 8] ^ c[12] ^ c[13];
    assign d[1] = c[1] ^ c[ 8] ^ c[ 9] ^ c[12] ^ c[14];
    assign d[2] = c[2] ^ c[ 9] ^ c[10] ^ c[13];
    assign d[3] = c[3] ^ c[ 8] ^ c[10] ^ c[11] ^ c[12] ^ c[13] ^ c[14];
    assign d[4] = c[4] ^ c[ 8] ^ c[ 9] ^ c[11] ^ c[14];
    assign d[5] = c[5] ^ c[ 9] ^ c[10] ^ c[12];
    assign d[6] = c[6] ^ c[10] ^ c[11] ^ c[13];
    assign d[7] = c[7] ^ c[11] ^ c[12] ^ c[14];

endmodule
