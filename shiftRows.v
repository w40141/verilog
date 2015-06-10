module shiftrows (i00, i01, i02, i03,
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
                  o30, o31, o32, o33;<`4`><`4`>

    assign i00 = o00;
    assign i01 = o01;
    assign i02 = o02;
    assign i03 = o03;

    assign i10 = o11;
    assign i11 = o12;
    assign i12 = o13;
    assign i13 = o00;

    assign i20 = o22;
    assign i21 = o23;
    assign i22 = o20;
    assign i23 = o21;

    assign i30 = o33;
    assign i31 = o30;
    assign i32 = o31;
    assign i33 = o32;

endmodule
