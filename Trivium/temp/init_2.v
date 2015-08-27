module INIT_2 (IN, OUT);
    input [287:0] IN;
    output [287:0] OUT;
    wire t1, t2, t3;

    assign t1 = IN[65]  ^ (IN[90]  & IN[91] ) ^ IN[92]  ^ IN[170];
    assign t2 = IN[161] ^ (IN[174] & IN[175]) ^ IN[176] ^ IN[263];
    assign t3 = IN[242] ^ (IN[285] & IN[286]) ^ IN[287] ^ IN[68];

    assign OUT[92:0]    = {IN[91:0]   , t3};
    assign OUT[176:93]  = {IN[175:93] , t1};
    assign OUT[287:177] = {IN[286:177], t2};
endmodule
