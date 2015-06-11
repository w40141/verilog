module shiftRows_inv (i00, i01, i02, i03,
                      i10, i11, i12, i13,
                      i20, i21, i22, i23,
                      i30, i31, i32, i33,
                      o00, o01, o02, o03,
                      o10, o11, o12, o13,
                      o20, o21, o22, o23,
                      o30, o31, o32, o33);

    input   [7:0] i00, i01, i02, i03,
                  i10, i11, i12, i13,
                  i20, i21, i22, i23,
                  i30, i31, i32, i33;

    output  [7:0] o00, o01, o02, o03,
                  o10, o11, o12, o13,
                  o20, o21, o22, o23,
                  o30, o31, o32, o33;

    assign o00 = i00;
    assign o01 = i01;
    assign o02 = i02;
    assign o03 = i03;

    assign o10 = i13;
    assign o11 = i10;
    assign o12 = i11;
    assign o13 = i12;

    assign o20 = i22;
    assign o21 = i23;
    assign o22 = i20;
    assign o23 = i21;

    assign o30 = i33;
    assign o31 = i30;
    assign o32 = i31;
    assign o33 = i32;

endmodule
