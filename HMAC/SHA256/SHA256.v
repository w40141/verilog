//******************************************************************
//* Designer     : 
//* E-Mail       : 
//* Dept         : 
//*
//* Version      : 0.1
//* Created      : June/09/2010
//* Last Updated : June/09/2010
//*
//* File Name    : SHA256.v
//******************************************************************
`timescale 1ns / 1ps

// Standard
`define SHA256_H0 32'h6a09e667
`define SHA256_H1 32'hbb67ae85
`define SHA256_H2 32'h3c6ef372
`define SHA256_H3 32'ha54ff53a
`define SHA256_H4 32'h510e527f
`define SHA256_H5 32'h9b05688c
`define SHA256_H6 32'h1f83d9ab
`define SHA256_H7 32'h5be0cd19

//---------------------------------------------
// MAIN_LOOP : main loop
//---------------------------------------------
//module SHA_CORE (t, Hinit, Hena, ABCena, Wout, clk, en, Hout);
module SHA_CORE ( clk, en, Hinit, Hena, ABCena, MSGin, Wena, MSGsel, t, Hout );
  input          clk;
  input          en;
  input          Hinit;   // Initialize H registers with constants
  input          Hena;    // Enable to load data in H regsters when en = '1'
  input          ABCena;  // Enable to load data in a-h regsters when en = '1'
  input   [31:0] MSGin;
  input          Wena;
  input          MSGsel;
  input    [5:0] t;       // integer range 0 to 63;
  output [255:0] Hout;

  wire    [31:0] sigma0;  // ROTR2(x) + ROTR13(x) + ROTR22(x)
  wire    [31:0] sigma1;  // ROTR6(x) + ROTR11(x) + ROTR25(x)
  wire    [31:0] MJ, CHF;
  wire    [31:0] Kt;
  reg     [31:0] H0, H1, H2, H3, H4, H5, H6, H7;
  reg     [31:0] a, b, c, d, e, f, g, h;
  wire    [31:0] ain, ein;

  reg     [31:0] w[15:0];
  wire    [31:0] del0;    // Delta 0 : ROTR7(x)  + ROTR18(x) + SHR3(x)
  wire    [31:0] del1;    // Delta 1 : ROTR17(x) + ROTR19(x) + SHR10(x)
  wire    [31:0] wt;
  wire    [31:0] Wout;

  integer i;

  function [31:0] Kj;
  input     [5:0] t;
    case ( t )
      // Standard
      0  : Kj = 32'h428a2f98;
      1  : Kj = 32'h71374491;
      2  : Kj = 32'hb5c0fbcf;
      3  : Kj = 32'he9b5dba5;
      4  : Kj = 32'h3956c25b;
      5  : Kj = 32'h59f111f1;
      6  : Kj = 32'h923f82a4;
      7  : Kj = 32'hab1c5ed5;
      8  : Kj = 32'hd807aa98;
      9  : Kj = 32'h12835b01;
      10 : Kj = 32'h243185be;
      11 : Kj = 32'h550c7dc3;
      12 : Kj = 32'h72be5d74;
      13 : Kj = 32'h80deb1fe;
      14 : Kj = 32'h9bdc06a7;
      15 : Kj = 32'hc19bf174;
      16 : Kj = 32'he49b69c1;
      17 : Kj = 32'hefbe4786;
      18 : Kj = 32'h0fc19dc6;
      19 : Kj = 32'h240ca1cc;
      20 : Kj = 32'h2de92c6f;
      21 : Kj = 32'h4a7484aa;
      22 : Kj = 32'h5cb0a9dc;
      23 : Kj = 32'h76f988da;
      24 : Kj = 32'h983e5152;
      25 : Kj = 32'ha831c66d;
      26 : Kj = 32'hb00327c8;
      27 : Kj = 32'hbf597fc7;
      28 : Kj = 32'hc6e00bf3;
      29 : Kj = 32'hd5a79147;
      30 : Kj = 32'h06ca6351;
      31 : Kj = 32'h14292967;
      32 : Kj = 32'h27b70a85;
      33 : Kj = 32'h2e1b2138;
      34 : Kj = 32'h4d2c6dfc;
      35 : Kj = 32'h53380d13;
      36 : Kj = 32'h650a7354;
      37 : Kj = 32'h766a0abb;
      38 : Kj = 32'h81c2c92e;
      39 : Kj = 32'h92722c85;
      40 : Kj = 32'ha2bfe8a1;
      41 : Kj = 32'ha81a664b;
      42 : Kj = 32'hc24b8b70;
      43 : Kj = 32'hc76c51a3;
      44 : Kj = 32'hd192e819;
      45 : Kj = 32'hd6990624;
      46 : Kj = 32'hf40e3585;
      47 : Kj = 32'h106aa070;
      48 : Kj = 32'h19a4c116;
      49 : Kj = 32'h1e376c08;
      50 : Kj = 32'h2748774c;
      51 : Kj = 32'h34b0bcb5;
      52 : Kj = 32'h391c0cb3;
      53 : Kj = 32'h4ed8aa4a;
      54 : Kj = 32'h5b9cca4f;
      55 : Kj = 32'h682e6ff3;
      56 : Kj = 32'h748f82ee;
      57 : Kj = 32'h78a5636f;
      58 : Kj = 32'h84c87814;
      59 : Kj = 32'h8cc70208;
      60 : Kj = 32'h90befffa;
      61 : Kj = 32'ha4506ceb;
      62 : Kj = 32'hbef9a3f7;
      63 : Kj = 32'hc67178f2;
    endcase
  endfunction

  assign sigma0 = { a[1:0], a[31:2] } ^ { a[12:0], a[31:13] } ^ { a[21:0], a[31:22] };
  assign sigma1 = { e[5:0], e[31:6] } ^ { e[10:0], e[31:11] } ^ { e[24:0], e[31:25] };

  assign MJ  = ( a & b ) | ( a & c ) | ( b & c ); // Maj|ity
  assign CHF = ( e & f ) | ( ~e & g );            // Ch & f
  assign Kt  = Kj( t );  
  assign ain = h + CHF + sigma1 + Kt + Wout + MJ + sigma0;
  assign ein = h + CHF + sigma1 + Kt + Wout + d;

  assign Hout = { H0, H1, H2, H3, H4, H5, H6, H7 };

  always @( posedge clk ) begin
    if ( en == 1 ) begin
      if ( Hinit == 1'b1 ) begin
        a <= `SHA256_H0;
        b <= `SHA256_H1;
        c <= `SHA256_H2;
        d <= `SHA256_H3;
        e <= `SHA256_H4;
        f <= `SHA256_H5;
        g <= `SHA256_H6;
        h <= `SHA256_H7;

        H0 <= `SHA256_H0;
        H1 <= `SHA256_H1;
        H2 <= `SHA256_H2;
        H3 <= `SHA256_H3;
        H4 <= `SHA256_H4;
        H5 <= `SHA256_H5;
        H6 <= `SHA256_H6;
        H7 <= `SHA256_H7;
      end
      else if ( Hena == 1'b1 ) begin
        a <= h + H7;
        b <= a;
        c <= b;
        d <= c;
        e <= d;
        f <= e;
        g <= f;
        h <= g;

        H0 <= h + H7;
        H1 <= H0;
        H2 <= H1;
        H3 <= H2;
        H4 <= H3;
        H5 <= H4;
        H6 <= H5;
        H7 <= H6;
      end
      else if ( ABCena == 1'b1 ) begin
        a <= ain;
        b <= a;
        c <= b;
        d <= c;
        e <= ein;
        f <= e;
        g <= f;
        h <= g;

        H0 <= H0;
        H1 <= H1;
        H2 <= H2;
        H3 <= H3;
        H4 <= H4;
        H5 <= H5;
        H6 <= H6;
        H7 <= H7;
      end
    end
  end

  assign del0 = { w[1][6:0], w[1][31:7] } ^ { w[1][17:0], w[1][31:18] } ^ { 3'b000, w[1][31:3] };
  assign del1 = { w[14][16:0], w[14][31:17] } ^ { w[14][18:0], w[14][31:19] } ^ { 10'b0000000000, w[14][31:10] };
  assign wt   = del0 + w[0][31:0] + del1 + w[9][31:0];

  always @( posedge clk ) begin
    if (( en & Wena ) == 1 ) begin
      w[15] <= ( MSGsel == 1'b0 )? MSGin : wt;
      for ( i=0; i<15; i=i+1 ) w[i] <= w[i+1];
    end
  end

  assign Wout = w[15];

endmodule


// ==================================================================================================
// SHA256 : Secure Hash Function SHA-256
// ==================================================================================================
module SHA256( RSTn, CLK, EN, INIT, MSGin, Mrdy, Hout, Hvld, LED_out, Busy );
  input              RSTn;  // Reset
  input              CLK;   // System clock

  input              EN;    // Enable
  input              INIT;  // Initialize
  input       [31:0] MSGin; // Message input
  input              Mrdy;  // Message input is ready
  output     [255:0] Hout;  // Hash value output
  output reg         Hvld;  // Hash value output raedy
  output reg         LED_out;
  output reg         Busy;  // Hash unit busy
  

  parameter [2:0] SHA_WAIT = 0, SHA_INIT = 1, MSG_WAIT = 2, MSG_IN = 3, SHA_GEN = 4, HADD_ST = 5;

  reg          [2:0] sha_state;   // State machine register
  reg          [3:0] mcnt;        // Message counter
  reg          [5:0] t;           // integer range 0 to 80;
  reg                Hinit, Hena, ABCena;
  wire               Wena;        // 'W' register enable
  reg                MSGsel;
  //reg                led1;
  
  function [31:0] MSG_in;
  input     [5:0] mcnt;
    case ( mcnt )
      0  : MSG_in = 32'h61626380;
      1  : MSG_in = 32'h00000000;
      2  : MSG_in = 32'h00000000;
      3  : MSG_in = 32'h00000000;
      4  : MSG_in = 32'h00000000;
      5  : MSG_in = 32'h00000000;
      6  : MSG_in = 32'h00000000;
      7  : MSG_in = 32'h00000000;
      8  : MSG_in = 32'h00000000;
      9  : MSG_in = 32'h00000000;
      10 : MSG_in = 32'h00000000;
      11 : MSG_in = 32'h00000000;
      12 : MSG_in = 32'h00000000;
      13 : MSG_in = 32'h00000000;
      14 : MSG_in = 32'h00000000;
      15 : MSG_in = 32'h00000018;
		default : MSG_in = 32'h00000000;
    endcase
  endfunction
  //assign Kt  = Kj( t );  
  //assign MSGin = MSG_in(mcnt);
  
  SHA_CORE G0( .clk( CLK ), .en( EN ), .Hinit( Hinit ), .Hena( Hena ), .ABCena( ABCena ),
               .MSGin( MSG_in(mcnt) ), .Wena( Wena ), .MSGsel( MSGsel ), .t( t ), .Hout( Hout )
             );

  assign Wena = (( sha_state == MSG_WAIT ) && ( Mrdy == 1 ))? 1 : 0
              ||(( sha_state == MSG_IN   ) && ( Mrdy == 1 ))? 1 : 0
              || ( sha_state == SHA_GEN )? 1 : 0;
  
  always @( posedge CLK or negedge RSTn ) begin
    if ( RSTn == 1'b0 ) begin
      Hinit   <= 1'b0;
      Hena    <= 1'b0;
      ABCena  <= 1'b0;
      MSGsel  <= 1'b0;
      Hvld    <= 1'b0;
      Busy    <= 1'b0;
      mcnt    <= 4'h0;
      t       <= 6'h00;
      sha_state <= SHA_WAIT;
	   LED_out <= 1'b0;
    end
    else if ( EN == 1'b1 ) begin
      case ( sha_state )
        SHA_WAIT: begin
                    Hinit     <= 1'b1;
                    Hena      <= 1'b0;
                    ABCena    <= 1'b0;
                    sha_state <= SHA_INIT;
                  end
        SHA_INIT: begin     // H and a-h registers initialize
                    Hinit     <= 1'b0;
                    Hena      <= 1'b0;
                    ABCena    <= 1'b0;
                    MSGsel    <= 1'b0;
                    mcnt      <= 4'h0;
                    t         <= 6'h00;
                    sha_state <= MSG_WAIT;
                  end

        MSG_WAIT: begin       // Message input wait
		              if ( INIT == 1'b1 ) sha_state <= SHA_WAIT;
                    else if ( Mrdy == 1'b1 ) begin
                      ABCena    <= 1'b1;
                      mcnt      <= mcnt + 1;
                      sha_state <= MSG_IN;
                    end
                    else sha_state <= MSG_WAIT;
                  end

        MSG_IN  : begin       // 16-word message input
                    if ( Mrdy == 1'b1 ) begin
                      if ( mcnt == 15 ) begin
                        MSGsel    <= 1'b1;
                        Busy      <= 1'b1;
                        sha_state <= SHA_GEN;
                      end

                      ABCena <= 1'b1;
                      mcnt   <= mcnt + 1;
                      t      <= t + 1;
                    end
                    else ABCena <= 1'b0;

                    Hinit  <= 1'b0;
                    Hena   <= 1'b0;
                    Hvld   <= 1'b0;
                  end

        SHA_GEN : begin
                    if ( t == 6'd63 ) begin
                      Hinit     <= 1'b0;
                      Hena      <= 1'b1;
                      ABCena    <= 1'b1;
                      mcnt      <= 4'h0;
                      t         <= 6'h00;
                      sha_state <= HADD_ST;
							 //led1      <= 1'b1;
							 //if
							 if(Hout == 512'hba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad)begin
							    //LED_out <= led1;
								 LED_out <= 1'b1;
							 end
                    end
                    else begin
                      mcnt <= 0;
                      t  <= t + 1;
                      sha_state <= SHA_GEN;
                    end
                  end

        HADD_ST : begin
                    if ( mcnt == 4'h7 ) begin
                      Hinit     <= 1'b0;
                      Hena      <= 1'b0;
                      Hvld      <= 1'b1;
                      Busy      <= 1'b0;
                      ABCena    <= 1'b0;
                      MSGsel    <= 1'b0;
                      t         <= 6'h00;
                      sha_state <= MSG_WAIT;
                    end
                    else begin
                      mcnt <= mcnt + 1;
                      sha_state <= HADD_ST;
                    end
                  end
      endcase
    end
  end

endmodule
