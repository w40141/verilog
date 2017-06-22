/******************************************************************************
 * Copyright 2010 Sony Corporation
 *
 * CLEFIA.v
 *
 * "The 128-bit Blockcipher CLEFIA"
 * Reference Verilog-HDL code
 *
 * Version 1.0.0 (January 29, 2010)
 *
 * NOTICE
 * This reference code is written for a clear understanding of the CLEFIA
 * blockcipher algorithm based on the specification of CLEFIA.
 * Therefore, this code does not include any optimizations for
 * high-speed or low-cost implementations or any countermeasures against
 * implementation attacks.
 *
 *****************************************************************************/

// -------------------------------------------------------------------
// CLEFIA top module
// -------------------------------------------------------------------
module CLEFIA ( CLK, SRST, MODE, ENCDEC, KEYSET, DATASET, KEY, DIN, BSY, DVLD, DOUT );
  
  input            CLK;      // system clock
  input            SRST;     // synchronous reset
  input   [1:0]    MODE;     // 00: 128-bit key, 01: 192-bit key, 10: 256-bit key
  input            ENCDEC;   // 0:encryption, 1:decryption
  input            KEYSET;   // key set signal
  input            DATASET;  // data set signal
  input   [255:0]  KEY;      // key input
  input   [127:0]  DIN;      // data input
  output           BSY;      // busy signal
  output           DVLD;     // data output valid signal
  output  [127:0]  DOUT;     // data output
  
  // -------------------------------------------------------------------
  // reg
  // -------------------------------------------------------------------
  reg   [1:0]    MODE_reg;     // latch MODE singal when valid key/data set singal is asserted
  // -------------------------------------------------------------------
  // wire
  // -------------------------------------------------------------------
  wire           KEYSET_vld;   // valid key set singal (assert only when BSY == 0)
  wire           DATASET_vld;  // valid data set signal (assert only when BSY == 0)
  // wire for CLEFIA-128 module
  wire           MODE_128;     // CLEFIA-128 mode
  wire           KEYSET_128;   // key set signal for CLEFIA-128 module
  wire           DATASET_128;  // data set signal for CLEFIA-128 module
  wire           BSY_128;      // busy singal for CLEFIA-128 module
  wire           DVLD_128;     // data output valid signal for CLEFIA-128 module
  wire  [127:0]  DOUT_128;     // data output for CLEFIA-128 module
  // wire for CLEFIA-192 module 
  wire           MODE_192;     // CLEFIA-192 mode
  wire           KEYSET_192;   // key set signal for CLEFIA-192 module
  wire           DATASET_192;  // data set signal for CLEFIA-192 module
  wire           BSY_192;      // busy singal for CLEFIA-192 module
  wire           DVLD_192;     // data output valid signal for CLEFIA-192 module
  wire  [127:0]  DOUT_192;     // data output for CLEFIA-192 module
  // wire for CLEFIA-256 module
  wire           MODE_256;     // CLEFIA-256 mode
  wire           KEYSET_256;   // key set signal for CLEFIA-256 module
  wire           DATASET_256;  // data set signal for CLEFIA-256 module
  wire           BSY_256;      // busy singal for CLEFIA-256 module
  wire           DVLD_256;     // data output valid signal for CLEFIA-256 module
  wire  [127:0]  DOUT_256;     // data output for CLEFIA-256 module
  
  always @ ( posedge CLK ) begin
    if ( SRST ) begin
      MODE_reg <= 2'b00;
    end
    else if ( KEYSET_vld == 1'b1 || DATASET_vld == 1'b1 ) begin
      MODE_reg <= MODE;
    end
  end
  
  assign KEYSET_vld  = KEYSET & ~BSY;
  assign DATASET_vld = DATASET & ~BSY;
  assign MODE_128    = ( MODE == 2'b00 )? 1'b1: 1'b0;
  assign MODE_192    = ( MODE == 2'b01 )? 1'b1: 1'b0;
  assign MODE_256    = ( MODE == 2'b10 )? 1'b1: 1'b0;
  assign KEYSET_128  = KEYSET_vld & MODE_128;
  assign KEYSET_192  = KEYSET_vld & MODE_192;
  assign KEYSET_256  = KEYSET_vld & MODE_256;
  assign DATASET_128 = DATASET_vld & MODE_128;
  assign DATASET_192 = DATASET_vld & MODE_192;
  assign DATASET_256 = DATASET_vld & MODE_256;
  
  CLEFIA128 i_CLEFIA128 (
    .CLK( CLK ),
    .SRST( SRST ),
    .ENCDEC( ENCDEC ),
    .KEYSET( KEYSET_128 ),
    .DATASET( DATASET_128 ),
    .KEY( KEY[127:0] ),
    .DIN( DIN ),
    .BSY( BSY_128 ),
    .DVLD( DVLD_128 ),
    .DOUT( DOUT_128 )
  );
  
  CLEFIA192 i_CLEFIA192 (
    .CLK( CLK ),
    .SRST( SRST ),
    .ENCDEC( ENCDEC ),
    .KEYSET( KEYSET_192 ),
    .DATASET( DATASET_192 ),
    .KEY( KEY[191:0] ),
    .DIN( DIN ),
    .BSY( BSY_192 ),
    .DVLD( DVLD_192 ),
    .DOUT( DOUT_192 )
  );
  
  CLEFIA256 i_CLEFIA256 (
    .CLK( CLK ),
    .SRST( SRST ),
    .ENCDEC( ENCDEC ),
    .KEYSET( KEYSET_256 ),
    .DATASET( DATASET_256 ),
    .KEY( KEY ),
    .DIN( DIN ),
    .BSY( BSY_256 ),
    .DVLD( DVLD_256 ),
    .DOUT( DOUT_256 )
  );
  
  assign BSY  = BSY_128 | BSY_192 | BSY_256;
  assign DVLD = ( MODE_reg == 2'b00 )? DVLD_128: ( MODE_reg == 2'b01 )? DVLD_192: DVLD_256;
  assign DOUT = ( MODE_reg == 2'b00 )? DOUT_128: ( MODE_reg == 2'b01 )? DOUT_192: DOUT_256;
  
endmodule


// -------------------------------------------------------------------
// CLEFIA-128 main module
// -------------------------------------------------------------------
module CLEFIA128 ( CLK, SRST, ENCDEC, KEYSET, DATASET, KEY, DIN, BSY, DVLD, DOUT );
  
  input            CLK;      // system clock
  input            SRST;     // synchronous reset
  input            ENCDEC;   // 0:encryption, 1:decryption
  input            KEYSET;   // key set signal
  input            DATASET;  // data set signal
  input   [127:0]  KEY;      // key input
  input   [127:0]  DIN;      // data input
  output           BSY;      // busy signal
  output           DVLD;     // data output valid signal
  output  [127:0]  DOUT;     // data output
  
  // -------------------------------------------------------------------
  // Parameter
  // -------------------------------------------------------------------
  // 1. Controler
  parameter ST_WAIT   = 2'b00;     // wait state
  parameter ST_KEY    = 2'b01;     // KEY(keyset) state
  parameter ST_ENC    = 2'b10;     // ENC(encryption) state
  parameter ST_DEC    = 2'b11;     // DEC(decryption) state
  parameter CON_T_KEY = 16'h428a;  // T_{0}  for constant values of KEY
  parameter CON_T_ENC = 16'hcb8e;  // T_{12} for constant values of ENC
  parameter CON_T_DEC = 16'ha7b3;  // T_{29} for constant values of DEC
  // 2. Key Scheduling Block
  parameter CON_P     = 16'hb7e1;  // P for constant values
  parameter CON_Q     = 16'h243f;  // Q for constant values
  // -------------------------------------------------------------------
  // reg
  // -------------------------------------------------------------------
  // 1. Controler
  reg   [1:0]    state_reg;   // state register
  reg            BSY_reg;     // register for busy signal
  reg            DVLD_reg;    // register for data output valid signal
  reg   [4:0]    rndcnt_reg;  // round counter (KEY: 0->11, ENC: 0->17, DEC: 17->0)
  reg   [15:0]   CON_T_reg;   // T_{i} (i = 0, ..., 29) for constant values
  // 2. Key Scheduling Block
  reg   [127:0]  keyK_reg;    // register for key K
  reg   [127:0]  keyL_reg;    // register for intermediate key \Sigma^{i}(L) (i = 0, ..., 8)
  // 3. Data Processing Block
  reg   [31:0]   data0_reg;   // 32-bit data register of line 0 (T0 of GFN_{4,12} and GFN_{4,18})
  reg   [31:0]   data1_reg;   // 32-bit data register of line 1 (T1 of GFN_{4,12} and GFN_{4,18})
  reg   [31:0]   data2_reg;   // 32-bit data register of line 2 (T2 of GFN_{4,12} and GFN_{4,18})
  reg   [31:0]   data3_reg;   // 32-bit data register of line 3 (T3 of GFN_{4,12} and GFN_{4,18})
  // -------------------------------------------------------------------
  // wire
  // -------------------------------------------------------------------
  // 1. Controler
  wire           BSY_KEY;        // busy in KEY
  wire           BSY_ENC;        // busy in ENC
  wire           BSY_DEC;        // busy in DEC
  wire  [4:0]    rndcnt_inc;     // rndcnt + 4'b0001
  wire  [4:0]    rndcnt_dec;     // rndcnt - 4'b0001
  wire  [15:0]   CON_T_x;        // T_{i} \cdot 0x0002
  wire  [15:0]   CON_T_xi;       // T_{i} \cdot 0x0002^{-1}
  // 2. Key Scheduling Block
  wire  [127:0]  keyK;           // K
  wire  [127:0]  keyL;           // \Sigma^{i}(L) (i = 0, ..., 8)
  wire  [127:0]  keyL_DP;        // GFN_{4,12}(CON_{0}, ..., CON_{23}, K_0, ..., K_3)
  wire  [127:0]  keyL_Sigma_1;   // \Sigma^{1}(keyL)
  wire  [127:0]  keyL_Sigma_8;   // \Sigma^{8}(keyL)
  wire  [127:0]  keyL_Sigma_1i;  // \Sigma^{-1}(keyL)
  wire  [127:0]  keyL_Sigma_8i;  // \Sigma^{-8}(keyL)
  wire  [31:0]   WK0;            // WK_0
  wire  [31:0]   WK1;            // WK_1
  wire  [31:0]   WK2;            // WK_2
  wire  [31:0]   WK3;            // WK_3
  wire  [63:0]   CON;	         // CON_{2i}||CON_{2i+1} (i = 0, ..., 29) for KEY/ENC/DEC
  wire  [63:0]   RK;             // RK_{2i}||RK_{2i+1} (i = 0, ..., 17) for ENC/DEC
  wire  [31:0]   RK0;            // CON_{2i}   for KEY, RK_{2i}   for ENC/DEC
  wire  [31:0]   RK1;            // CON_{2i+1} for KEY, RK_{2i+1} for ENC/DEC
  // 3. Data Processing Block
  wire  [31:0]   F0_Din0;        // T0
  wire  [31:0]   F0_Din1;        // T1
  wire  [31:0]   F0_Dout;        // F_0(RK0, T0) ^ T1
  wire  [31:0]   F1_Din0;        // T2
  wire  [31:0]   F1_Din1;        // T3
  wire  [31:0]   F1_Dout;        // F_1(RK1, T2) ^ T3
  
  // -------------------------------------------------------------------
  // 1. Controler
  // -------------------------------------------------------------------
  
  assign BSY_KEY = ( state_reg == ST_KEY  )? 1'b1: 1'b0;
  assign BSY_ENC = ( state_reg == ST_ENC  )? 1'b1: 1'b0;
  assign BSY_DEC = ( state_reg == ST_DEC  )? 1'b1: 1'b0;
  
  assign rndcnt_inc = rndcnt_reg + 5'b00001;
  assign rndcnt_dec = rndcnt_reg - 5'b00001;
  
  assign CON_T_x[0]     = CON_T_reg[15];
  assign CON_T_x[3:1]   = CON_T_reg[2:0];
  assign CON_T_x[4]     = CON_T_reg[3]  ^ CON_T_reg[15];
  assign CON_T_x[5]     = CON_T_reg[4]  ^ CON_T_reg[15];
  assign CON_T_x[10:6]  = CON_T_reg[9:5];
  assign CON_T_x[11]    = CON_T_reg[10] ^ CON_T_reg[15];
  assign CON_T_x[12]    = CON_T_reg[11];
  assign CON_T_x[13]    = CON_T_reg[12] ^ CON_T_reg[15];
  assign CON_T_x[14]    = CON_T_reg[13];
  assign CON_T_x[15]    = CON_T_reg[14] ^ CON_T_reg[15];

  assign CON_T_xi[2:0]  = CON_T_reg[3:1];
  assign CON_T_xi[3]    = CON_T_reg[4]  ^ CON_T_reg[0];
  assign CON_T_xi[4]    = CON_T_reg[5]  ^ CON_T_reg[0];
  assign CON_T_xi[9:5]  = CON_T_reg[10:6];
  assign CON_T_xi[10]   = CON_T_reg[11] ^ CON_T_reg[0];
  assign CON_T_xi[11]   = CON_T_reg[12];
  assign CON_T_xi[12]   = CON_T_reg[13] ^ CON_T_reg[0];
  assign CON_T_xi[13]   = CON_T_reg[14];
  assign CON_T_xi[14]   = CON_T_reg[15] ^ CON_T_reg[0];
  assign CON_T_xi[15]   = CON_T_reg[0];
  
  always @( posedge CLK ) begin
    if ( SRST ) begin
      state_reg  <= ST_WAIT;
      BSY_reg    <= 1'b0;
      DVLD_reg   <= 1'b0;
      rndcnt_reg <= 5'b00000;
    end
    else begin
      case ( state_reg )
        
        ST_WAIT: begin
          if ( KEYSET == 1'b1 ) begin
            state_reg  <= ST_KEY;
            BSY_reg    <= 1'b1;
            DVLD_reg   <= 1'b0;
            CON_T_reg  <= CON_T_KEY;
          end
          else if ( DATASET == 1'b1 ) begin
            if ( ENCDEC == 1'b0 ) begin
              state_reg  <= ST_ENC;
              CON_T_reg  <= CON_T_ENC;
            end
            else begin
              state_reg  <= ST_DEC;
              rndcnt_reg <= 5'b10001;
              CON_T_reg  <= CON_T_DEC;
            end
            BSY_reg    <= 1'b1;
            DVLD_reg   <= 1'b0;
          end
        end
        
        ST_KEY: begin  // key setup
          if ( rndcnt_reg == 5'b01011 ) begin
            state_reg  <= ST_WAIT;
            BSY_reg    <= 1'b0;
            rndcnt_reg <= 5'b00000;
          end
          else begin
            rndcnt_reg <= rndcnt_inc;
            CON_T_reg  <= CON_T_xi;
          end
        end
        
        ST_ENC: begin  // encryption
          if ( rndcnt_reg == 5'b10001 ) begin
            state_reg  <= ST_WAIT;
            BSY_reg    <= 1'b0;
            DVLD_reg   <= 1'b1;
            rndcnt_reg <= 5'b00000;
          end
          else begin
            rndcnt_reg <= rndcnt_inc;
            CON_T_reg  <= CON_T_xi;
          end
        end
        
        ST_DEC: begin  // decryption
          if ( rndcnt_reg == 5'b00000 ) begin
            state_reg  <= ST_WAIT;
            BSY_reg    <= 1'b0;
            DVLD_reg   <= 1'b1;
          end
          else begin
            rndcnt_reg <= rndcnt_dec;
            CON_T_reg  <= CON_T_x;
          end
        end
      
      endcase
    end
  end
  
  // -------------------------------------------------------------------
  // 2. Key Scheduling Block
  // -------------------------------------------------------------------
  
  assign keyK          =  keyK_reg;
  assign keyL          =  keyL_reg;
  assign keyL_DP       = {data0_reg, F0_Dout, data2_reg, F1_Dout};
  assign keyL_Sigma_1  = {keyL[120:64], keyL[6:0],     keyL[127:121], keyL[63:7]};
  assign keyL_Sigma_8  = {keyL[71:64],  keyL[6:0],     keyL[13:7],    keyL[20:14],   keyL[27:21],   keyL[34:28],
                          keyL[41:35],  keyL[48:42],   keyL[55:49],   keyL[78:72],   keyL[85:79],   keyL[92:86],
                          keyL[99:93],  keyL[106:100], keyL[113:107], keyL[120:114], keyL[127:121], keyL[63:56]};
  assign keyL_Sigma_1i = {keyL[63:57],  keyL[127:71],  keyL[56:0],    keyL[70:64]};
  assign keyL_Sigma_8i = {keyL[14:8],   keyL[21:15],   keyL[28:22],   keyL[35:29],   keyL[42:36],   keyL[49:43],
                          keyL[56:50],  keyL[63:57],   keyL[127:120], keyL[7:0],     keyL[70:64],   keyL[77:71],
                          keyL[84:78],  keyL[91:85],   keyL[98:92],   keyL[105:99],  keyL[112:106], keyL[119:113]};
  
  // WAIT: KEYSET
  //         K <- K0|K1|K2|K3
  //       DATASET & DEC
  //         L <- \Sigma^{8}(L)
  // KEY:  round 11 (final round)
  //         L <- GFN_{4,12}(CON_{0}, ..., CON_{23}, K_0, ..., K_3))
  // ENC:  round 1/3/5/7/9/11/13/15
  //         L <- \Sigma^{1}(L)
  //       round 17 (final round)
  //         L <- \Sigma^{-8}(L)
  // DEC:  round 16/14/12/10/8/6/4/2
  //         L <- \Sigma^{-1}(L)
  always @( posedge CLK ) begin
    if ( BSY_reg == 1'b0 ) begin
      if ( KEYSET == 1'b1 ) begin  // start of KEY
        keyK_reg <= KEY;
      end
      else if ( DATASET == 1'b1 && ENCDEC == 1'b1 ) begin  // start of DEC
        keyL_reg <= keyL_Sigma_8;
      end
    end
    else if ( BSY_KEY == 1'b1 && rndcnt_reg == 5'b01011 ) begin  // round 11 of KEY
      keyL_reg <= keyL_DP;
    end
    else if ( BSY_ENC == 1'b1 && rndcnt_reg[0] == 1'b1 ) begin  // round 17 of ENC
      if ( rndcnt_reg[4:1] == 4'b1000 ) begin
        keyL_reg <= keyL_Sigma_8i;
      end
      else begin  // round 1/3/7/9/11/13/15 of ENC
        keyL_reg <= keyL_Sigma_1;
      end
    end
    else if ( BSY_DEC == 1'b1 && rndcnt_reg[0] == 1'b0 && rndcnt_reg[4:1] != 4'b0000 ) begin  // round 16/14/12/10/8/6/4/2 of DEC
      keyL_reg <= keyL_Sigma_1i;
    end
  end
  
  assign WK0 = keyK[127:96];
  assign WK1 = keyK[95:64];
  assign WK2 = keyK[63:32];
  assign WK3 = keyK[31:0];
  
  assign CON[63:48] =   CON_T_reg ^ CON_P;                   // ( T_{i}^P)
  assign CON[47:32] = {~CON_T_reg[14:0], ~CON_T_reg[15]};    // (~T_{i}<<<1)
  assign CON[31:16] =  ~CON_T_reg ^ CON_Q;                   // (~T_{i}^Q)
  assign CON[15:0]  = { CON_T_reg[7:0],   CON_T_reg[15:8]};  // ( T_{i}<<<8)
  
  function  [63:0]   sel_RK;
  input     [1:0]    sel;
  input     [127:0]  keyL;
  input     [127:0]  keyK;
    case ( sel )
      2'b00: sel_RK = keyL[127:64];
      2'b01: sel_RK = keyL[63:0];
      2'b10: sel_RK = keyL[127:64] ^ keyK[127:64];
      2'b11: sel_RK = keyL[63:0]   ^ keyK[63:0];
    endcase
  endfunction
  
  assign RK  = sel_RK( rndcnt_reg[1:0], keyL, keyK ) ^ CON;
  assign RK0 = ( BSY_ENC == 1'b1 || BSY_DEC == 1'b1 )? RK[63:32]: CON[63:32];
  assign RK1 = ( BSY_ENC == 1'b1 || BSY_DEC == 1'b1 )? RK[31:0] : CON[31:0];
  
  // -------------------------------------------------------------------
  // 3. Data Processing Block
  // -------------------------------------------------------------------
  
  assign F0_Din0 = data0_reg;
  assign F0_Din1 = data1_reg;
  assign F1_Din0 = data2_reg;
  assign F1_Din1 = data3_reg;
  
  CLEFIA_F0Xor i_CLEFIA_F0Xor ( .RK( RK0 ), .Din0( F0_Din0 ), .Din1( F0_Din1 ), .Dout( F0_Dout ) );
  CLEFIA_F1Xor i_CLEFIA_F1Xor ( .RK( RK1 ), .Din0( F1_Din0 ), .Din1( F1_Din1 ), .Dout( F1_Dout ) );
  
  // WAIT: KEYSET
  //         T0|T1|T2|T3 <- K0|K1|K2|K3
  //       DATASET & ENC
  //         T0|T1|T2|T3 <- P0|(P1^WK0)|P2|(P3^WK1)
  //       DATASET & DEC
  //         T0|T1|T2|T3 <- C0|(C1^WK2)|C2|(C3^WK3)
  // KEY:  round 0...11
  //         T0|T1|T2|T3 <- (T1^F0)|T2|(T3^F1)|T0
  // ENC:  round 0...16
  //         T0|T1|T2|T3 <- (T1^F0)|T2|(T3^F1)|T0
  //       round 17 (final round)
  //         T0|T1|T2|T3 <- T0|(T1^F0^WK2)|T2|(T3^F1^WK3)
  // DEC:  round 17...1
  //         T0|T1|T2|T3 <- (T3^F1)|T0|(T1^F0)|T2
  //       round 0 (final round)
  //         T0|T1|T2|T3 <- T0|(T1^F0^WK0)|T2|(T3^F1^WK1)
  always @ ( posedge CLK ) begin
    if ( BSY_reg == 1'b0 ) begin
      if ( KEYSET == 1'b1 ) begin  // start of KEY
        data0_reg <= KEY[127:96];
        data1_reg <= KEY[95:64];
        data2_reg <= KEY[63:32];
        data3_reg <= KEY[31:0];
      end
      else if ( DATASET == 1'b1 ) begin  // start of ENC/DEC
        if ( ENCDEC == 1'b0 ) begin  // start of ENC
          data1_reg <= DIN[95:64] ^ WK0;
          data3_reg <= DIN[31:0]  ^ WK1;
        end
        else begin  // start of DEC
          data1_reg <= DIN[95:64] ^ WK2;
          data3_reg <= DIN[31:0]  ^ WK3;
        end
        data0_reg <= DIN[127:96];
        data2_reg <= DIN[63:32];
      end
    end
    else if ( BSY_DEC == 1'b1 ) begin
      if ( rndcnt_reg == 5'b00000 ) begin  // round 0 of DEC
        data1_reg <= F0_Dout ^ WK0;
        data3_reg <= F1_Dout ^ WK1;
      end
      else begin  // round 17...1 of DEC
        data0_reg <= F1_Dout;
        data1_reg <= data0_reg;
        data2_reg <= F0_Dout;
        data3_reg <= data2_reg;
      end
    end
    else if ( BSY_ENC == 1'b1 && rndcnt_reg == 5'b10001 ) begin  // round 17 of ENC
        data1_reg <= F0_Dout ^ WK2;
        data3_reg <= F1_Dout ^ WK3;
    end
    else begin  // round  0...11 of KEY, round 0...16 of ENC
        data0_reg <= F0_Dout;
        data1_reg <= data2_reg;
        data2_reg <= F1_Dout;
        data3_reg <= data0_reg;
    end
  end
  
  // -------------------------------------------------------------------
  // Output
  // -------------------------------------------------------------------
  
  assign BSY  = BSY_reg;
  assign DVLD = DVLD_reg;
  assign DOUT = {data0_reg, data1_reg, data2_reg, data3_reg};
  
endmodule


// -------------------------------------------------------------------
// CLEFIA-192 main module
// -------------------------------------------------------------------
module CLEFIA192 ( CLK, SRST, ENCDEC, KEYSET, DATASET, KEY, DIN, BSY, DVLD, DOUT );
  
  input            CLK;      // system clock
  input            SRST;     // synchronous reset
  input            ENCDEC;   // 0:encryption, 1:decryption
  input            KEYSET;   // key set signal
  input            DATASET;  // data set signal
  input   [191:0]  KEY;      // key input
  input   [127:0]  DIN;      // data input
  output           BSY;      // busy signal
  output           DVLD;     // data output valid signal
  output  [127:0]  DOUT;     // data output
  
  // -------------------------------------------------------------------
  // Parameter
  // -------------------------------------------------------------------
  // 1. Controler
  parameter ST_WAIT   = 2'b00;     // wait state
  parameter ST_KEY    = 2'b01;     // KEY(keyset) state
  parameter ST_ENC    = 2'b10;     // ENC(encryption) state
  parameter ST_DEC    = 2'b11;     // DEC(decryption) state
  parameter CON_T_KEY = 16'h7137;  // T_{0}  for constant values of KEY
  parameter CON_T_ENC = 16'h21df;  // T_{20} for constant values of ENC
  parameter CON_T_DEC = 16'h89b0;  // T_{41} for constant values of DEC
  // 2. Key Scheduling Block
  parameter CON_P     = 16'hb7e1;  // P for constant values
  parameter CON_Q     = 16'h243f;  // Q for constant values
  // -------------------------------------------------------------------
  // reg
  // -------------------------------------------------------------------
  // 1. Controler
  reg   [1:0]    state_reg;   // state register
  reg            BSY_reg;     // register for busy signal
  reg            DVLD_reg;    // register for data output valid signal
  reg   [4:0]    rndcnt_reg;  // round counter (KEY: 0->19, ENC: 0->21, DEC: 21->0)
  reg   [15:0]   CON_T_reg;   // T_{i} (i = 0, ..., 41) for constant values
  // 2. Key Scheduling Block
  reg   [127:0]  keyKL_reg;   // register for key K_L
  reg   [127:0]  keyKR_reg;   // register for key K_R
  reg   [127:0]  keyLL_reg;   // register for intermediate key \Sigma^{i}(L_L) (i = 0, ..., 5)
  reg   [127:0]  keyLR_reg;   // register for intermediate key \Sigma^{i}(L_R) (i = 0, ..., 4)
  // 3. Data Processing Block
  reg   [31:0]   data0_reg;   // 32-bit data register of line 0 (T_0 of GFN_{8,10} and GFN_{4,22})
  reg   [31:0]   data1_reg;   // 32-bit data register of line 1 (T_1 of GFN_{8,10} and GFN_{4,22})
  reg   [31:0]   data2_reg;   // 32-bit data register of line 2 (T_2 of GFN_{8,10} and GFN_{4,22})
  reg   [31:0]   data3_reg;   // 32-bit data register of line 3 (T_3 of GFN_{8,10} and GFN_{4,22})
  reg   [31:0]   data4_reg;   // 32-bit data register of line 4 (T_4 of GFN_{8,10})
  reg   [31:0]   data5_reg;   // 32-bit data register of line 5 (T_5 of GFN_{8,10})
  reg   [31:0]   data6_reg;   // 32-bit data register of line 6 (T_6 of GFN_{8,10})
  reg   [31:0]   data7_reg;   // 32-bit data register of line 7 (T_7 of GFN_{8,10})
  // -------------------------------------------------------------------
  // wire
  // -------------------------------------------------------------------
  // 1. Controler
  wire           BSY_KEY;         // busy in KEY
  wire           BSY_ENC;         // busy in ENC
  wire           BSY_DEC;         // busy in DEC
  wire  [4:0]    rndcnt_inc;      // rndcnt + 4'b0001
  wire  [4:0]    rndcnt_dec;      // rndcnt - 4'b0001
  wire  [15:0]   CON_T_x;         // T_{i} \cdot 0x0002
  wire  [15:0]   CON_T_xi;        // T_{i} \cdot 0x0002^{-1}
  // 2. Key Scheduling Block
  wire  [127:0]  keyKL;           // K_L
  wire  [127:0]  keyLL;           // \Sigma^{i}(L_L) (i = 0, ..., 5)
  wire  [127:0]  keyLL_DP;        // leftmost 128-bit of GFN_{8,10}
  wire  [127:0]  keyLL_Sigma_1;   // \Sigma^{1}(keyLL)
  wire  [127:0]  keyLL_Sigma_5;   // \Sigma^{5}(keyLL)
  wire  [127:0]  keyLL_Sigma_1i;  // \Sigma^{-1}(keyLL)
  wire  [127:0]  keyLL_Sigma_5i;  // \Sigma^{-5}(keyLL)
  wire  [127:0]  keyKR;           // K_R
  wire  [127:0]  keyLR;           // \Sigma^{i}(L_R) (i = 0, ..., 4)
  wire  [127:0]  keyLR_DP;        // rightmost 128-bit of GFN_{8,10}
  wire  [127:0]  keyLR_Sigma_1;   // \Sigma^{1}(keyLR)
  wire  [127:0]  keyLR_Sigma_4;   // \Sigma^{4}(keyLR)
  wire  [127:0]  keyLR_Sigma_1i;  // \Sigma^{-1}(keyLR)
  wire  [127:0]  keyLR_Sigma_4i;  // \Sigma^{-4}(keyLR)
  wire  [31:0]   WK0;             // WK_0
  wire  [31:0]   WK1;             // WK_1
  wire  [31:0]   WK2;             // WK_2
  wire  [31:0]   WK3;             // WK_3
  wire  [63:0]   CON;	          // CON_{2i}||CON_{2i+1} (i = 0, ..., 41) for KEY/ENC/DEC
  wire  [63:0]   RK;              // RK_{2i}||RK_{2i+1} (i = 0, ..., 21) for ENC/DEC
  wire  [31:0]   RK0;             // CON_{2i}   for KEY, RK_{2i}   for ENC/DEC
  wire  [31:0]   RK1;             // CON_{2i+1} for KEY, RK_{2i+1} for ENC/DEC
  // 3. Data Processing Block
  wire  [31:0]   F0_Din0;         // T_0 or T_4 (round 1/3/5/7/9/11/13/15/17/19 of KEY)
  wire  [31:0]   F0_Din1;         // T_1 or T_5 (round 1/3/5/7/9/11/13/15/17/19 of KEY)
  wire  [31:0]   F0_Dout;         // F_0(RK0, (T_0 or T_4)) ^ (T_1 or T_5)
  wire  [31:0]   F1_Din0;         // T_2 or T_6 (round 1/3/5/7/9/11/13/15/17/19 of KEY)
  wire  [31:0]   F1_Din1;         // T_3 or T_7 (round 1/3/5/7/9/11/13/15/17/19 of KEY)
  wire  [31:0]   F1_Dout;         // F_1(RK1, (T_2 or T_6)) ^ (T_3 or T_7)
  // -------------------------------------------------------------------
  // 1. Controler
  // -------------------------------------------------------------------
  
  assign BSY_KEY = ( state_reg == ST_KEY  )? 1'b1: 1'b0;
  assign BSY_ENC = ( state_reg == ST_ENC  )? 1'b1: 1'b0;
  assign BSY_DEC = ( state_reg == ST_DEC  )? 1'b1: 1'b0;
  
  assign rndcnt_inc = rndcnt_reg + 5'b00001;
  assign rndcnt_dec = rndcnt_reg - 5'b00001;
  
  assign CON_T_x[0]     = CON_T_reg[15];
  assign CON_T_x[3:1]   = CON_T_reg[2:0];
  assign CON_T_x[4]     = CON_T_reg[3]  ^ CON_T_reg[15];
  assign CON_T_x[5]     = CON_T_reg[4]  ^ CON_T_reg[15];
  assign CON_T_x[10:6]  = CON_T_reg[9:5];
  assign CON_T_x[11]    = CON_T_reg[10] ^ CON_T_reg[15];
  assign CON_T_x[12]    = CON_T_reg[11];
  assign CON_T_x[13]    = CON_T_reg[12] ^ CON_T_reg[15];
  assign CON_T_x[14]    = CON_T_reg[13];
  assign CON_T_x[15]    = CON_T_reg[14] ^ CON_T_reg[15];

  assign CON_T_xi[2:0]  = CON_T_reg[3:1];
  assign CON_T_xi[3]    = CON_T_reg[4]  ^ CON_T_reg[0];
  assign CON_T_xi[4]    = CON_T_reg[5]  ^ CON_T_reg[0];
  assign CON_T_xi[9:5]  = CON_T_reg[10:6];
  assign CON_T_xi[10]   = CON_T_reg[11] ^ CON_T_reg[0];
  assign CON_T_xi[11]   = CON_T_reg[12];
  assign CON_T_xi[12]   = CON_T_reg[13] ^ CON_T_reg[0];
  assign CON_T_xi[13]   = CON_T_reg[14];
  assign CON_T_xi[14]   = CON_T_reg[15] ^ CON_T_reg[0];
  assign CON_T_xi[15]   = CON_T_reg[0];
  
  always @( posedge CLK ) begin
    if ( SRST ) begin
      state_reg  <= ST_WAIT;
      BSY_reg    <= 1'b0;
      DVLD_reg   <= 1'b0;
      rndcnt_reg <= 5'b00000;
    end
    else begin
      case ( state_reg )
        
        ST_WAIT: begin
          if ( KEYSET == 1'b1 ) begin
            state_reg  <= ST_KEY;
            BSY_reg    <= 1'b1;
            DVLD_reg   <= 1'b0;
            CON_T_reg  <= CON_T_KEY;
          end
          else if ( DATASET == 1'b1 ) begin
            if ( ENCDEC == 1'b0 ) begin
              state_reg  <= ST_ENC;
              CON_T_reg  <= CON_T_ENC;
            end
            else begin
              state_reg  <= ST_DEC;
              rndcnt_reg <= 5'b10101;
              CON_T_reg  <= CON_T_DEC;
            end
            BSY_reg    <= 1'b1;
            DVLD_reg   <= 1'b0;
          end
        end
        
        ST_KEY: begin  // key setup
          if ( rndcnt_reg == 5'b10011 ) begin
            state_reg  <= ST_WAIT;
            BSY_reg    <= 1'b0;
            rndcnt_reg <= 5'b00000;
          end
          else begin
            rndcnt_reg <= rndcnt_inc;
            CON_T_reg  <= CON_T_xi;
          end
        end
        
        ST_ENC: begin  // encryption
          if ( rndcnt_reg == 5'b10101 ) begin
            state_reg  <= ST_WAIT;
            BSY_reg    <= 1'b0;
            DVLD_reg   <= 1'b1;
            rndcnt_reg <= 5'b00000;
          end
          else begin
            rndcnt_reg <= rndcnt_inc;
            CON_T_reg  <= CON_T_xi;
          end
        end
        
        ST_DEC: begin  // decryption
          if ( rndcnt_reg == 5'b00000 ) begin
            state_reg  <= ST_WAIT;
            BSY_reg    <= 1'b0;
            DVLD_reg   <= 1'b1;
          end
          else begin
            rndcnt_reg <= rndcnt_dec;
            CON_T_reg  <= CON_T_x;
          end
        end
      
      endcase
    end
  end
  
  // -------------------------------------------------------------------
  // 2. Key Scheduling Block
  // -------------------------------------------------------------------
  
  assign keyKL          =  keyKL_reg;
  assign keyLL          =  keyLL_reg;
  assign keyLL_DP       = {data0_reg, data1_reg, data2_reg, data3_reg};
  assign keyLL_Sigma_1  = {keyLL[120:64],  keyLL[6:0],     keyLL[127:121], keyLL[63:7]};
  assign keyLL_Sigma_5  = {keyLL[92:64],   keyLL[6:0],     keyLL[13:7],    keyLL[20:14],   keyLL[27:21],   keyLL[34:28],
                           keyLL[99:93],   keyLL[106:100], keyLL[113:107], keyLL[120:114], keyLL[127:121], keyLL[63:35]};
  assign keyLL_Sigma_1i = {keyLL[63:57],   keyLL[127:71],  keyLL[56:0],    keyLL[70:64]};
  assign keyLL_Sigma_5i = {keyLL[35:29],   keyLL[42:36],   keyLL[49:43],   keyLL[56:50],   keyLL[63:57],   keyLL[127:99],
                           keyLL[28:0],    keyLL[70:64],   keyLL[77:71],   keyLL[84:78],   keyLL[91:85],   keyLL[98:92]};
  
  assign keyKR          =  keyKR_reg;
  assign keyLR          =  keyLR_reg;
  assign keyLR_DP       = {data4_reg, F0_Dout, data6_reg, F1_Dout};
  assign keyLR_Sigma_1  = {keyLR[120:64],  keyLR[6:0],     keyLR[127:121], keyLR[63:7]};
  assign keyLR_Sigma_4  = {keyLR[99:64],   keyLR[6:0],     keyLR[13:7],    keyLR[20:14],   keyLR[27:21],
                           keyLR[106:100], keyLR[113:107], keyLR[120:114], keyLR[127:121], keyLR[63:28]};
  assign keyLR_Sigma_1i = {keyLR[63:57],   keyLR[127:71],  keyLR[56:0],    keyLR[70:64]};
  assign keyLR_Sigma_4i = {keyLR[42:36],   keyLR[49:43],   keyLR[56:50],   keyLR[63:57],   keyLR[127:92],
                           keyLR[35:0],    keyLR[70:64],   keyLR[77:71],   keyLR[84:78],   keyLR[91:85]};
  
  // WAIT: KEYSET
  //         KL <- K0|K1|K2|K3
  //         KR <- K4|K5|~K0|~K1
  //       DATASET & DEC
  //         LL <- \Sigma^{5}(LL)
  //         LR <- \Sigma^{4}(LR) 
  // KEY:  round 19 (final round)
  //         LL|LR <- GFN_{8,10}(CON_{0}, ..., CON_{39}, K_{L0}, ..., K_{R3}))
  // ENC:  round 1/3/9/11/17
  //         LL <- \Sigma^{1}(LL)
  //       round 19
  //         LL <- \Sigma^{-5}(LL)
  //       round 5/7/13/15
  //         LR <- \Sigma^{1}(LR)
  //       round 21 (final round)
  //         LR <- \Sigma^{-4}(LR)
  // DEC:  round 18/16/10/8/2
  //         LL <- \Sigma^{-1}(LL)
  //       round 20/14/12/6
  //         LR <- \Sigma^{-1}(LR)
  always @( posedge CLK ) begin
    if ( BSY_reg == 1'b0 ) begin
      if ( KEYSET == 1'b1 ) begin  // start of KEY
        keyKL_reg <=  KEY[191:64];
        keyKR_reg <= {KEY[63:0], ~KEY[191:128]};
      end
      else if ( DATASET == 1'b1 && ENCDEC == 1'b1 ) begin  // start of DEC
        keyLL_reg <= keyLL_Sigma_5;
        keyLR_reg <= keyLR_Sigma_4;
      end
    end
    else if ( BSY_KEY == 1'b1 && rndcnt_reg == 5'b10011 ) begin  // round 19 of KEY
      keyLL_reg <= keyLL_DP;
      keyLR_reg <= keyLR_DP;
    end
    else if ( BSY_ENC == 1'b1 && rndcnt_reg[0] == 1'b1 ) begin  
      if ( rndcnt_reg[2] == 1'b0 ) begin
        if ( rndcnt_reg[4:3] == 2'b10 && rndcnt_reg[1] == 1'b1 ) begin  // round 19 of ENC
          keyLL_reg <= keyLL_Sigma_5i;
        end
        else begin  // round 1/3/9/11/17 of ENC
          keyLL_reg <= keyLL_Sigma_1;
        end
      end
      else begin
        if ( rndcnt_reg[4:3] == 2'b10 && rndcnt_reg[1] == 1'b0 ) begin  // round 21 of ENC
          keyLR_reg <= keyLR_Sigma_4i;
        end
        else begin  // round 5/7/13/15 of ENC
          keyLR_reg <= keyLR_Sigma_1;
        end
      end
    end
    else if ( BSY_DEC == 1'b1 && rndcnt_reg[0] == 1'b0 && ( rndcnt_reg[4:3] != 2'b00 || rndcnt_reg[1] != 1'b0 ) ) begin
      if( rndcnt_reg[2] == 1'b0 ) begin  // round 18/16/10/8/2 of DEC
        keyLL_reg <= keyLL_Sigma_1i;
      end
      else begin  // round 20/14/12/6 of DEC
        keyLR_reg <= keyLR_Sigma_1i;
      end
    end
  end
  
  assign WK0 = keyKL[127:96] ^ keyKR[127:96];  // KL ^ KR
  assign WK1 = keyKL[95:64]  ^ keyKR[95:64];
  assign WK2 = keyKL[63:32]  ^ keyKR[63:32];
  assign WK3 = keyKL[31:0]   ^ keyKR[31:0];
  
  assign CON[63:48] =   CON_T_reg ^ CON_P;                   // ( T_{i}^P)
  assign CON[47:32] = {~CON_T_reg[14:0], ~CON_T_reg[15]};    // (~T_{i}<<<1)
  assign CON[31:16] =  ~CON_T_reg ^ CON_Q;                   // (~T_{i}^Q)
  assign CON[15:0]  = { CON_T_reg[7:0],   CON_T_reg[15:8]};  // ( T_{i}<<<8)
  
  function  [63:0]   sel_RK;
  input     [3:0]    sel;
  input     [127:0]  keyLL;
  input     [127:0]  keyLR;
  input     [127:0]  keyKL;
  input     [127:0]  keyKR;
    case ( sel )
      3'b000: sel_RK = keyLL[127:64];
      3'b001: sel_RK = keyLL[63:0];
      3'b010: sel_RK = keyLL[127:64] ^ keyKR[127:64];
      3'b011: sel_RK = keyLL[63:0]   ^ keyKR[63:0];
      3'b100: sel_RK = keyLR[127:64];
      3'b101: sel_RK = keyLR[63:0];
      3'b110: sel_RK = keyLR[127:64] ^ keyKL[127:64];
      3'b111: sel_RK = keyLR[63:0]   ^ keyKL[63:0];
    endcase
  endfunction
  
  assign RK  = sel_RK( rndcnt_reg[2:0], keyLL, keyLR, keyKL, keyKR ) ^ CON;
  assign RK0 = ( BSY_ENC == 1'b1 || BSY_DEC == 1'b1 )? RK[63:32]: CON[63:32];
  assign RK1 = ( BSY_ENC == 1'b1 || BSY_DEC == 1'b1 )? RK[31:0] : CON[31:0];
  
  // -------------------------------------------------------------------
  // 3. Data Processing Block
  // -------------------------------------------------------------------
  
  assign F0_Din0 = ( BSY_KEY == 1'b1 && rndcnt_reg[0] == 1'b1 )? data4_reg: data0_reg;
  assign F0_Din1 = ( BSY_KEY == 1'b1 && rndcnt_reg[0] == 1'b1 )? data5_reg: data1_reg;
  assign F1_Din0 = ( BSY_KEY == 1'b1 && rndcnt_reg[0] == 1'b1 )? data6_reg: data2_reg;
  assign F1_Din1 = ( BSY_KEY == 1'b1 && rndcnt_reg[0] == 1'b1 )? data7_reg: data3_reg;
  
  CLEFIA_F0Xor i_CLEFIA_F0Xor ( .RK( RK0 ), .Din0( F0_Din0 ), .Din1( F0_Din1 ), .Dout( F0_Dout ) );
  CLEFIA_F1Xor i_CLEFIA_F1Xor ( .RK( RK1 ), .Din0( F1_Din0 ), .Din1( F1_Din1 ), .Dout( F1_Dout ) );
  
  // WAIT: KEYSET
  //         T0|T1|T2|T3|T4|T5|T6|T7 <- K0|K1|K2|K3|K4|K5|~K0|~K1
  //       DATASET & ENC
  //         T0|T1|T2|T3 <- P0|(P1^WK0)|P2|(P3^WK1)
  //       DATASET & DEC
  //         T0|T1|T2|T3 <- C0|(C1^WK2)|C2|(C3^WK3)
  // KEY:  round 0/2/4/6/8/10/12/14/16/18
  //         T0|T1|T2|T3|T4|T5|T6|T7 <- T0|(T1^F0)|T2|(T3^F1)|T4|T5|T6|T7
  //       round 1/3/5/7/9/11/13/15/17/19
  //         T0|T1|T2|T3|T4|T5|T6|T7 <- T1|T2|T3|T4|(T5^F0)|T6|(T7^F1)|T0
  // ENC:  round 0...20
  //         T0|T1|T2|T3 <- (T1^F0)|T2|(T3^F1)|T0
  //       round 21 (final round)
  //         T0|T1|T2|T3 <- T0|(T1^F0^WK2)|T2|(T3^F1^WK3)
  // DEC:  round 21...1
  //         T0|T1|T2|T3 <- (T3^F1)|T0|(T1^F0)|T2
  //       round 0 (final round)
  //         T0|T1|T2|T3 <- T0|(T1^F0^WK0)|T2|(T3^F1^WK1)
  always @ ( posedge CLK ) begin
    if ( BSY_reg == 1'b0 ) begin
      if ( KEYSET == 1'b1 ) begin  // start of KEY
        data0_reg <=  KEY[191:160];
        data1_reg <=  KEY[159:128];
        data2_reg <=  KEY[127:96];
        data3_reg <=  KEY[95:64];
        data4_reg <=  KEY[63:32];
        data5_reg <=  KEY[31:0];
        data6_reg <= ~KEY[191:160];
        data7_reg <= ~KEY[159:128];
      end
      else if ( DATASET == 1'b1 ) begin  // start of ENC/DEC
        if ( ENCDEC == 1'b0 ) begin  // start of ENC
          data1_reg <= DIN[95:64] ^ WK0;
          data3_reg <= DIN[31:0]  ^ WK1;
        end
        else begin  // start of DEC
          data1_reg <= DIN[95:64] ^ WK2;
          data3_reg <= DIN[31:0]  ^ WK3;
        end
        data0_reg <= DIN[127:96];
        data2_reg <= DIN[63:32];
      end
    end
    else if ( BSY_KEY == 1'b1 ) begin
      if ( rndcnt_reg[0] == 1'b0 ) begin  // round 0/2/4/6/8/10/12/14/16/18 of KEY
        data1_reg <= F0_Dout;
        data3_reg <= F1_Dout;
      end
      else begin  // round 1/3/5/7/9/11/13/15/17/19 of KEY
        data0_reg <= data1_reg;
        data1_reg <= data2_reg;
        data2_reg <= data3_reg;
        data3_reg <= data4_reg;
        data4_reg <= F0_Dout;
        data5_reg <= data6_reg;
        data6_reg <= F1_Dout;
        data7_reg <= data0_reg;
      end
    end
    else if ( BSY_ENC == 1'b1 ) begin
      if ( rndcnt_reg == 5'b10101 ) begin  // round 21 of ENC
        data1_reg <= F0_Dout ^ WK2;
        data3_reg <= F1_Dout ^ WK3;
      end
      else begin  // round 0...20 of ENC
        data0_reg <= F0_Dout;
        data1_reg <= data2_reg;
        data2_reg <= F1_Dout;
        data3_reg <= data0_reg;
      end
    end
    else begin
      if ( rndcnt_reg == 5'b00000 ) begin  // round 0 of DEC
        data1_reg <= F0_Dout ^ WK0;
        data3_reg <= F1_Dout ^ WK1;
      end
      else begin  // round 21...1 of DEC
        data0_reg <= F1_Dout;
        data1_reg <= data0_reg;
        data2_reg <= F0_Dout;
        data3_reg <= data2_reg;
      end
    end
  end
  
  // -------------------------------------------------------------------
  // Output
  // -------------------------------------------------------------------
  
  assign BSY  = BSY_reg;
  assign DVLD = DVLD_reg;
  assign DOUT = {data0_reg, data1_reg, data2_reg, data3_reg};
  
endmodule


// -------------------------------------------------------------------
// CLEFIA-256 main module
// -------------------------------------------------------------------
module CLEFIA256 ( CLK, SRST, ENCDEC, KEYSET, DATASET, KEY, DIN, BSY, DVLD, DOUT );
  
  input            CLK;      // system clock
  input            SRST;     // synchronous reset
  input            ENCDEC;   // 0:encryption, 1:decryption
  input            KEYSET;   // key set signal
  input            DATASET;  // data set signal
  input   [255:0]  KEY;      // key input
  input   [127:0]  DIN;      // data input
  output           BSY;      // busy signal
  output           DVLD;     // data output valid signal
  output  [127:0]  DOUT;     // data output
  
  // -------------------------------------------------------------------
  // Parameter
  // -------------------------------------------------------------------
  // 1. Controler
  parameter ST_WAIT   = 2'b00;     // wait state
  parameter ST_KEY    = 2'b01;     // KEY(keyset) state
  parameter ST_ENC    = 2'b10;     // ENC(encryption) state
  parameter ST_DEC    = 2'b11;     // DEC(decryption) state
  parameter CON_T_KEY = 16'hb5c0;  // T_{0}  for constant values of KEY
  parameter CON_T_ENC = 16'ha86f;  // T_{20} for constant values of ENC
  parameter CON_T_DEC = 16'hb32e;  // T_{45} for constant values of DEC
  // 2. Key Scheduling Block
  parameter CON_P     = 16'hb7e1;  // P for constant values
  parameter CON_Q     = 16'h243f;  // Q for constant values
  // -------------------------------------------------------------------
  // reg
  // -------------------------------------------------------------------
  // 1. Controler
  reg   [1:0]    state_reg;   // state register
  reg            BSY_reg;     // register for busy signal
  reg            DVLD_reg;    // register for data output valid signal
  reg   [4:0]    rndcnt_reg;  // round counter (KEY: 0->19, ENC: 0->25, DEC: 25->0)
  reg   [15:0]   CON_T_reg;   // T_{i} (i = 0, ..., 45) for constant values
  // 2. Key Scheduling Block
  reg   [127:0]  keyKL_reg;   // register for key K_L
  reg   [127:0]  keyKR_reg;   // register for key K_R
  reg   [127:0]  keyLL_reg;   // register for intermediate key \Sigma^{i}(L_L) (i = 0, ..., 6)
  reg   [127:0]  keyLR_reg;   // register for intermediate key \Sigma^{i}(L_R) (i = 0, ..., 5)
  // 3. Data Processing Block
  reg   [31:0]   data0_reg;   // 32-bit data register of line 0 (T_0 of GFN_{8,10} and GFN_{4,22})
  reg   [31:0]   data1_reg;   // 32-bit data register of line 1 (T_1 of GFN_{8,10} and GFN_{4,22})
  reg   [31:0]   data2_reg;   // 32-bit data register of line 2 (T_2 of GFN_{8,10} and GFN_{4,22})
  reg   [31:0]   data3_reg;   // 32-bit data register of line 3 (T_3 of GFN_{8,10} and GFN_{4,22})
  reg   [31:0]   data4_reg;   // 32-bit data register of line 4 (T_4 of GFN_{8,10})
  reg   [31:0]   data5_reg;   // 32-bit data register of line 5 (T_5 of GFN_{8,10})
  reg   [31:0]   data6_reg;   // 32-bit data register of line 6 (T_6 of GFN_{8,10})
  reg   [31:0]   data7_reg;   // 32-bit data register of line 7 (T_7 of GFN_{8,10})
  // -------------------------------------------------------------------
  // wire
  // -------------------------------------------------------------------
  // 1. Controler
  wire           BSY_KEY;         // busy in KEY
  wire           BSY_ENC;         // busy in ENC
  wire           BSY_DEC;         // busy in DEC
  wire  [4:0]    rndcnt_inc;      // rndcnt + 4'b0001
  wire  [4:0]    rndcnt_dec;      // rndcnt - 4'b0001
  wire  [15:0]   CON_T_x;         // T_{i} \cdot 0x0002
  wire  [15:0]   CON_T_xi;        // T_{i} \cdot 0x0002^{-1}
  // 2. Key Scheduling Block
  wire  [127:0]  keyKL;           // K_L
  wire  [127:0]  keyLL;           // \Sigma^{i}(L_L) (i = 0, ..., 6)
  wire  [127:0]  keyLL_DP;        // leftmost 128-bit of GFN_{8,10}
  wire  [127:0]  keyLL_Sigma_1;   // \Sigma^{1}(keyLL)
  wire  [127:0]  keyLL_Sigma_6;   // \Sigma^{6}(keyLL)
  wire  [127:0]  keyLL_Sigma_1i;  // \Sigma^{-1}(keyLL)
  wire  [127:0]  keyLL_Sigma_6i;  // \Sigma^{-6}(keyLL)
  wire  [127:0]  keyKR;           // K_R
  wire  [127:0]  keyLR;           // \Sigma^{i}(L_R) (i = 0, ..., 5)
  wire  [127:0]  keyLR_DP;        // leftmost 128-bit of GFN_{8,10}
  wire  [127:0]  keyLR_Sigma_1;   // \Sigma^{1}(keyLR)
  wire  [127:0]  keyLR_Sigma_5;   // \Sigma^{5}(keyLR)
  wire  [127:0]  keyLR_Sigma_1i;  // \Sigma^{-1}(keyLR)
  wire  [127:0]  keyLR_Sigma_5i;  // \Sigma^{-5}(keyLR)
  wire  [31:0]   WK0;             // WK_0
  wire  [31:0]   WK1;             // WK_1
  wire  [31:0]   WK2;             // WK_2
  wire  [31:0]   WK3;             // WK_3
  wire  [63:0]   CON;	          // CON_{2i}||CON_{2i+1} (i = 0, ..., 45) for KEY/ENC/DEC
  wire  [63:0]   RK;              // RK_{2i}||RK_{2i+1} (i = 0, ..., 25) for ENC/DEC
  wire  [31:0]   RK0;             // CON_{2i}   for KEY, RK_{2i}   for ENC/DEC
  wire  [31:0]   RK1;             // CON_{2i+1} for KEY, RK_{2i+1} for ENC/DEC
  // 3. Data Processing Block
  wire  [31:0]   F0_Din0;         // T_0 or T_4 (round 1/3/5/7/9/11/13/15/17/19 of KEY)
  wire  [31:0]   F0_Din1;         // T_1 or T_5 (round 1/3/5/7/9/11/13/15/17/19 of KEY)
  wire  [31:0]   F0_Dout;         // F_0(RK0, (T_0 or T_4)) ^ (T_1 or T_5)
  wire  [31:0]   F1_Din0;         // T_2 or T_6 (round 1/3/5/7/9/11/13/15/17/19 of KEY)
  wire  [31:0]   F1_Din1;         // T_3 or T_7 (round 1/3/5/7/9/11/13/15/17/19 of KEY)
  wire  [31:0]   F1_Dout;         // F_1(RK1, (T_2 or T_6)) ^ (T_3 or T_7)
  // -------------------------------------------------------------------
  // 1. Controler
  // -------------------------------------------------------------------
  
  assign BSY_KEY = ( state_reg == ST_KEY  )? 1'b1: 1'b0;
  assign BSY_ENC = ( state_reg == ST_ENC  )? 1'b1: 1'b0;
  assign BSY_DEC = ( state_reg == ST_DEC  )? 1'b1: 1'b0;
  
  assign rndcnt_inc = rndcnt_reg + 5'b00001;
  assign rndcnt_dec = rndcnt_reg - 5'b00001;
  
  assign CON_T_x[0]     = CON_T_reg[15];
  assign CON_T_x[3:1]   = CON_T_reg[2:0];
  assign CON_T_x[4]     = CON_T_reg[3]  ^ CON_T_reg[15];
  assign CON_T_x[5]     = CON_T_reg[4]  ^ CON_T_reg[15];
  assign CON_T_x[10:6]  = CON_T_reg[9:5];
  assign CON_T_x[11]    = CON_T_reg[10] ^ CON_T_reg[15];
  assign CON_T_x[12]    = CON_T_reg[11];
  assign CON_T_x[13]    = CON_T_reg[12] ^ CON_T_reg[15];
  assign CON_T_x[14]    = CON_T_reg[13];
  assign CON_T_x[15]    = CON_T_reg[14] ^ CON_T_reg[15];

  assign CON_T_xi[2:0]  = CON_T_reg[3:1];
  assign CON_T_xi[3]    = CON_T_reg[4]  ^ CON_T_reg[0];
  assign CON_T_xi[4]    = CON_T_reg[5]  ^ CON_T_reg[0];
  assign CON_T_xi[9:5]  = CON_T_reg[10:6];
  assign CON_T_xi[10]   = CON_T_reg[11] ^ CON_T_reg[0];
  assign CON_T_xi[11]   = CON_T_reg[12];
  assign CON_T_xi[12]   = CON_T_reg[13] ^ CON_T_reg[0];
  assign CON_T_xi[13]   = CON_T_reg[14];
  assign CON_T_xi[14]   = CON_T_reg[15] ^ CON_T_reg[0];
  assign CON_T_xi[15]   = CON_T_reg[0];
  
  always @( posedge CLK ) begin
    if ( SRST ) begin
      state_reg  <= ST_WAIT;
      BSY_reg    <= 1'b0;
      DVLD_reg   <= 1'b0;
      rndcnt_reg <= 5'b00000;
    end
    else begin
      case ( state_reg )
        
        ST_WAIT: begin
          if ( KEYSET == 1'b1 ) begin
            state_reg  <= ST_KEY;
            BSY_reg    <= 1'b1;
            DVLD_reg   <= 1'b0;
            CON_T_reg  <= CON_T_KEY;
          end
          else if ( DATASET == 1'b1 ) begin
            if ( ENCDEC == 1'b0 ) begin
              state_reg  <= ST_ENC;
              CON_T_reg  <= CON_T_ENC;
            end
            else begin
              state_reg  <= ST_DEC;
              rndcnt_reg <= 5'b11001;
              CON_T_reg  <= CON_T_DEC;
            end
            BSY_reg    <= 1'b1;
            DVLD_reg   <= 1'b0;
          end
        end
        
        ST_KEY: begin  // key setup
          if ( rndcnt_reg == 5'b10011 ) begin
            state_reg  <= ST_WAIT;
            BSY_reg    <= 1'b0;
            rndcnt_reg <= 5'b00000;
          end
          else begin
            rndcnt_reg <= rndcnt_inc;
            CON_T_reg  <= CON_T_xi;
          end
        end
        
        ST_ENC: begin  // encryption
          if ( rndcnt_reg == 5'b11001 ) begin
            state_reg  <= ST_WAIT;
            BSY_reg    <= 1'b0;
            DVLD_reg   <= 1'b1;
            rndcnt_reg <= 5'b00000;
          end
          else begin
            rndcnt_reg <= rndcnt_inc;
            CON_T_reg  <= CON_T_xi;
          end
        end
        
        ST_DEC: begin  // decryption
          if ( rndcnt_reg == 5'b00000 ) begin
            state_reg  <= ST_WAIT;
            BSY_reg    <= 1'b0;
            DVLD_reg   <= 1'b1;
          end
          else begin
            rndcnt_reg <= rndcnt_dec;
            CON_T_reg  <= CON_T_x;
          end
        end
      
      endcase
    end
  end
  
  // -------------------------------------------------------------------
  // 2. Key Scheduling Block
  // -------------------------------------------------------------------
  
  assign keyKL          =  keyKL_reg;
  assign keyLL          =  keyLL_reg;
  assign keyLL_DP       = {data0_reg, data1_reg, data2_reg, data3_reg};
  assign keyLL_Sigma_1  = {keyLL[120:64],  keyLL[6:0],     keyLL[127:121], keyLL[63:7]};
  assign keyLL_Sigma_6  = {keyLL[85:64],   keyLL[6:0],     keyLL[13:7],    keyLL[20:14],   keyLL[27:21],   keyLL[34:28],   keyLL[41:35],
                           keyLL[92:86],   keyLL[99:93],   keyLL[106:100], keyLL[113:107], keyLL[120:114], keyLL[127:121], keyLL[63:42]};
  assign keyLL_Sigma_1i = {keyLL[63:57],   keyLL[127:71],  keyLL[56:0],    keyLL[70:64]};
  assign keyLL_Sigma_6i = {keyLL[28:22],   keyLL[35:29],   keyLL[42:36],   keyLL[49:43],   keyLL[56:50],   keyLL[63:57],   keyLL[127:106],
                           keyLL[21:0],    keyLL[70:64],   keyLL[77:71],   keyLL[84:78],   keyLL[91:85],   keyLL[98:92],   keyLL[105:99]};
  assign keyKR          =  keyKR_reg;
  assign keyLR          =  keyLR_reg;
  assign keyLR_DP       = {data4_reg, F0_Dout, data6_reg, F1_Dout};
  assign keyLR_Sigma_1  = {keyLR[120:64],  keyLR[6:0],     keyLR[127:121], keyLR[63:7]};
  assign keyLR_Sigma_5  = {keyLR[92:64],   keyLR[6:0],     keyLR[13:7],    keyLR[20:14],   keyLR[27:21],   keyLR[34:28],
                           keyLR[99:93],   keyLR[106:100], keyLR[113:107], keyLR[120:114], keyLR[127:121], keyLR[63:35]};
  assign keyLR_Sigma_1i = {keyLR[63:57],   keyLR[127:71],  keyLR[56:0],    keyLR[70:64]};
  assign keyLR_Sigma_5i = {keyLR[35:29],   keyLR[42:36],   keyLR[49:43],   keyLR[56:50],   keyLR[63:57],   keyLR[127:99],
                           keyLR[28:0],    keyLR[70:64],   keyLR[77:71],   keyLR[84:78],   keyLR[91:85],   keyLR[98:92]};

  // WAIT: KEYSET
  //         KL <- K0|K1|K2|K3
  //         KR <- K4|K5|~K0|~K1
  //       DATASET & DEC
  //         LL <- \Sigma^{6}(LL)
  //         LR <- \Sigma^{5}(LR) 
  // KEY:  round 19 (final round)
  //         LL|LR <- GFN_{8,10}(CON_{0}, ..., CON_{39}, K_{L0}, ..., K_{R3}))
  // ENC:  round 1/3/9/11/17/19
  //         LL <- \Sigma^{1}(LL)
  //       round 25 (final round)
  //         LL <- \Sigma^{-6}(LL)
  //       round 5/7/13/15/21
  //         LR <- \Sigma^{1}(LR)
  //       round 23
  //         LR <- \Sigma^{-5}(LR)
  // DEC:  round 24/18/16/10/8/2
  //         LL <- \Sigma^{-1}(LL)
  //       round 22/20/14/12/6
  //         LR <- \Sigma^{-1}(LR)
  always @( posedge CLK ) begin
    if ( BSY_reg == 1'b0 ) begin
      if ( KEYSET == 1'b1 ) begin  // start of KEY
        keyKL_reg <= KEY[255:128];
        keyKR_reg <= KEY[127:0];
      end
      else if ( DATASET == 1'b1 && ENCDEC == 1'b1 ) begin  // start of DEC
        keyLL_reg <= keyLL_Sigma_6;
        keyLR_reg <= keyLR_Sigma_5;
      end
    end
    else if ( BSY_KEY == 1'b1 && rndcnt_reg == 5'b10011 ) begin  // round 19 of KEY
      keyLL_reg <= keyLL_DP;
      keyLR_reg <= keyLR_DP;
    end
    else if ( BSY_ENC == 1'b1 && rndcnt_reg[0] == 1'b1 ) begin  
      if ( rndcnt_reg[2] == 1'b0 ) begin
        if ( rndcnt_reg[4:3] == 2'b11 && rndcnt_reg[1] == 1'b0 ) begin  // round 25 of ENC
          keyLL_reg <= keyLL_Sigma_6i;
        end
        else begin  // round 1/3/9/11/17/19 of ENC
          keyLL_reg <= keyLL_Sigma_1;
        end
      end
      else begin
        if ( rndcnt_reg[4:3] == 2'b10 && rndcnt_reg[1] == 1'b1 ) begin  // round 23 of ENC
          keyLR_reg <= keyLR_Sigma_5i;
        end
        else begin  // round 5/7/13/15/21 of ENC
          keyLR_reg <= keyLR_Sigma_1;
        end
      end
    end
    else if ( BSY_DEC == 1'b1 && rndcnt_reg[0] == 1'b0 && ( rndcnt_reg[4:3] != 2'b00 || rndcnt_reg[1] != 1'b0 ) ) begin
      if( rndcnt_reg[2] == 1'b0 ) begin  // round 24/18/16/10/8/2 of DEC
        keyLL_reg <= keyLL_Sigma_1i;
      end
      else begin  // round 22/20/14/12/6 of DEC
        keyLR_reg <= keyLR_Sigma_1i;
      end
    end
  end
  
  assign WK0 = keyKL[127:96] ^ keyKR[127:96];  // KL ^ KR
  assign WK1 = keyKL[95:64]  ^ keyKR[95:64];
  assign WK2 = keyKL[63:32]  ^ keyKR[63:32];
  assign WK3 = keyKL[31:0]   ^ keyKR[31:0];
  
  assign CON[63:48] =   CON_T_reg ^ CON_P;                   // ( T_{i}^P)
  assign CON[47:32] = {~CON_T_reg[14:0], ~CON_T_reg[15]};    // (~T_{i}<<<1)
  assign CON[31:16] =  ~CON_T_reg ^ CON_Q;                   // (~T_{i}^Q)
  assign CON[15:0]  = { CON_T_reg[7:0],   CON_T_reg[15:8]};  // ( T_{i}<<<8)
  
  function  [63:0]   sel_RK;
  input     [3:0]    sel;
  input     [127:0]  keyLL;
  input     [127:0]  keyLR;
  input     [127:0]  keyKL;
  input     [127:0]  keyKR;
    case ( sel )
      3'b000: sel_RK = keyLL[127:64];
      3'b001: sel_RK = keyLL[63:0];
      3'b010: sel_RK = keyLL[127:64] ^ keyKR[127:64];
      3'b011: sel_RK = keyLL[63:0]   ^ keyKR[63:0];
      3'b100: sel_RK = keyLR[127:64];
      3'b101: sel_RK = keyLR[63:0];
      3'b110: sel_RK = keyLR[127:64] ^ keyKL[127:64];
      3'b111: sel_RK = keyLR[63:0]   ^ keyKL[63:0];
    endcase
  endfunction
  
  assign RK  = sel_RK( rndcnt_reg[2:0], keyLL, keyLR, keyKL, keyKR ) ^ CON;
  assign RK0 = ( BSY_ENC == 1'b1 || BSY_DEC == 1'b1 )? RK[63:32]: CON[63:32];
  assign RK1 = ( BSY_ENC == 1'b1 || BSY_DEC == 1'b1 )? RK[31:0] : CON[31:0];
  
  // -------------------------------------------------------------------
  // 3. Data Processing Block
  // -------------------------------------------------------------------
  
  assign F0_Din0 = ( BSY_KEY == 1'b1 && rndcnt_reg[0] == 1'b1 )? data4_reg: data0_reg;
  assign F0_Din1 = ( BSY_KEY == 1'b1 && rndcnt_reg[0] == 1'b1 )? data5_reg: data1_reg;
  assign F1_Din0 = ( BSY_KEY == 1'b1 && rndcnt_reg[0] == 1'b1 )? data6_reg: data2_reg;
  assign F1_Din1 = ( BSY_KEY == 1'b1 && rndcnt_reg[0] == 1'b1 )? data7_reg: data3_reg;
  
  CLEFIA_F0Xor i_CLEFIA_F0Xor ( .RK( RK0 ), .Din0( F0_Din0 ), .Din1( F0_Din1 ), .Dout( F0_Dout ) );
  CLEFIA_F1Xor i_CLEFIA_F1Xor ( .RK( RK1 ), .Din0( F1_Din0 ), .Din1( F1_Din1 ), .Dout( F1_Dout ) );
  
  // WAIT: KEYSET
  //         T0|T1|T2|T3|T4|T5|T6|T7 <- K0|K1|K2|K3|K4|K5|~K0|~K1
  //       DATASET & ENC
  //         T0|T1|T2|T3 <- P0|(P1^WK0)|P2|(P3^WK1)
  //       DATASET & DEC
  //         T0|T1|T2|T3 <- C0|(C1^WK2)|C2|(C3^WK3)
  // KEY:  round 0/2/4/6/8/10/12/14/16/18
  //         T0|T1|T2|T3 <- T0|(T1^F0)|T2|(T3^F1)
  //       round 1/3/5/7/9/11/13/15/17/19
  //         T0|T1|T2|T3|T4|T5|T6|T7 <- T1|T2|T3|T4|(T5^F0)|T6|(T7^F1)|T0
  // ENC:  round 0...24
  //         T0|T1|T2|T3 <- (T1^F0)|T2|(T3^F1)|T0
  //       round 25 (final round)
  //         T0|T1|T2|T3 <- T0|(T1^F0^WK2)|T2|(T3^F1^WK3)
  // DEC:  round 25...1
  //         T0|T1|T2|T3 <- (T3^F1)|T0|(T1^F0)|T2
  //       round 0 (final round)
  //         T0|T1|T2|T3 <- T0|(T1^F0^WK0)|T2|(T3^F1^WK1)
  always @ ( posedge CLK ) begin
    if ( BSY_reg == 1'b0 ) begin
      if ( KEYSET == 1'b1 ) begin  // start of KEY
        data0_reg <= KEY[255:224];
        data1_reg <= KEY[223:192];
        data2_reg <= KEY[191:160];
        data3_reg <= KEY[159:128];
        data4_reg <= KEY[127:96];
        data5_reg <= KEY[95:64];
        data6_reg <= KEY[63:32];
        data7_reg <= KEY[31:0];
      end
      else if ( DATASET == 1'b1 ) begin  // start of ENC/DEC
        if ( ENCDEC == 1'b0 ) begin  // start of ENC
          data1_reg <= DIN[95:64] ^ WK0;
          data3_reg <= DIN[31:0]  ^ WK1;
        end
        else begin  // start of DEC
          data1_reg <= DIN[95:64] ^ WK2;
          data3_reg <= DIN[31:0]  ^ WK3;
        end
        data0_reg <= DIN[127:96];
        data2_reg <= DIN[63:32];
      end
    end
    else if ( BSY_KEY == 1'b1 ) begin
      if ( rndcnt_reg[0] == 1'b0 ) begin  // round 0/2/4/6/8/10/12/14/16/18 of KEY
        data1_reg <= F0_Dout;
        data3_reg <= F1_Dout;
      end
      else begin  // round 1/3/5/7/9/11/13/15/17/19 of KEY
        data0_reg <= data1_reg;
        data1_reg <= data2_reg;
        data2_reg <= data3_reg;
        data3_reg <= data4_reg;
        data4_reg <= F0_Dout;
        data5_reg <= data6_reg;
        data6_reg <= F1_Dout;
        data7_reg <= data0_reg;
      end
    end
    else if ( BSY_ENC == 1'b1 ) begin
      if ( rndcnt_reg == 5'b11001 ) begin  // round 25 of ENC
        data1_reg <= F0_Dout ^ WK2;
        data3_reg <= F1_Dout ^ WK3;
      end
      else begin  // round 0...24 of ENC
        data0_reg <= F0_Dout;
        data1_reg <= data2_reg;
        data2_reg <= F1_Dout;
        data3_reg <= data0_reg;
      end
    end
    else begin
      if ( rndcnt_reg == 5'b00000 ) begin  // round 0 of DEC
        data1_reg <= F0_Dout ^ WK0;
        data3_reg <= F1_Dout ^ WK1;
      end
      else begin  // round 25...1 of DEC
        data0_reg <= F1_Dout;
        data1_reg <= data0_reg;
        data2_reg <= F0_Dout;
        data3_reg <= data2_reg;
      end
    end
  end
  
  // -------------------------------------------------------------------
  // Output
  // -------------------------------------------------------------------
  
  assign BSY  = BSY_reg;
  assign DVLD = DVLD_reg;
  assign DOUT = {data0_reg, data1_reg, data2_reg, data3_reg};
  
endmodule


// -------------------------------------------------------------------
// F_0 and XOR of Feistel Structure
//   Dout = F_0(RK, Din0) ^ Din1
// -------------------------------------------------------------------
module CLEFIA_F0Xor ( RK, Din0, Din1, Dout );
  
  input   [31:0]  RK;
  input   [31:0]  Din0;
  input   [31:0]  Din1;
  output  [31:0]  Dout;
  
  wire    [31:0]  F0_KA;  // after key addition in F-function F_0
  wire    [31:0]  F0_SB;  // after S-box in F-function F_0
  wire    [31:0]  F0_DM;  // after diffusion matrix M_0 in F-function F_0
  
  assign F0_KA = RK ^ Din0;
  
  CLEFIA_S0 i_CLEFIA_S0_F0_0 ( .Din( F0_KA[31:24] ), .Dout( F0_SB[31:24] ) );
  CLEFIA_S1 i_CLEFIA_S1_F0_1 ( .Din( F0_KA[23:16] ), .Dout( F0_SB[23:16] ) );
  CLEFIA_S0 i_CLEFIA_S0_F0_2 ( .Din( F0_KA[15:8]  ), .Dout( F0_SB[15:8]  ) );
  CLEFIA_S1 i_CLEFIA_S1_F0_3 ( .Din( F0_KA[7:0]   ), .Dout( F0_SB[7:0]   ) );
  
  CLEFIA_M0 i_CLEFIA_M0 ( .Din( F0_SB ), .Dout( F0_DM ) );
  
  assign Dout = F0_DM ^ Din1;
  
endmodule


// -------------------------------------------------------------------
// F_1 and XOR of Feistel Structure
//   Dout = F_1(RK, Din0) ^ Din1
// -------------------------------------------------------------------
module CLEFIA_F1Xor ( RK, Din0, Din1, Dout );
  
  input   [31:0]  RK;
  input   [31:0]  Din0;
  input   [31:0]  Din1;
  output  [31:0]  Dout;
  
  wire    [31:0]  F1_KA;  // after key addition in F-function F_1
  wire    [31:0]  F1_SB;  // after S-box in F-function F_1
  wire    [31:0]  F1_DM;  // after diffusion matrix M_1 in F-function F_1
  
  assign F1_KA = RK ^ Din0;
  
  CLEFIA_S1 i_CLEFIA_S1_F1_0 ( .Din( F1_KA[31:24] ), .Dout( F1_SB[31:24] ) );
  CLEFIA_S0 i_CLEFIA_S0_F1_1 ( .Din( F1_KA[23:16] ), .Dout( F1_SB[23:16] ) );
  CLEFIA_S1 i_CLEFIA_S1_F1_2 ( .Din( F1_KA[15:8]  ), .Dout( F1_SB[15:8]  ) );
  CLEFIA_S0 i_CLEFIA_S0_F1_3 ( .Din( F1_KA[7:0]   ), .Dout( F1_SB[7:0]   ) );
  
  CLEFIA_M1 i_CLEFIA_M1 ( .Din( F1_SB ), .Dout( F1_DM ) );
  
  assign Dout = F1_DM ^ Din1;
  
endmodule


// -------------------------------------------------------------------
// S-box S_0
// -------------------------------------------------------------------
module CLEFIA_S0 ( Din, Dout );
  
  input   [7:0]  Din;
  output  [7:0]  Dout;
  
  function  [7:0]  S0;
  input     [7:0]  in;
    case ( in )
      8'h00: S0 = 8'h57;  8'h01: S0 = 8'h49;  8'h02: S0 = 8'hd1;  8'h03: S0 = 8'hc6;
      8'h04: S0 = 8'h2f;  8'h05: S0 = 8'h33;  8'h06: S0 = 8'h74;  8'h07: S0 = 8'hfb;
      8'h08: S0 = 8'h95;  8'h09: S0 = 8'h6d;  8'h0a: S0 = 8'h82;  8'h0b: S0 = 8'hea;
      8'h0c: S0 = 8'h0e;  8'h0d: S0 = 8'hb0;  8'h0e: S0 = 8'ha8;  8'h0f: S0 = 8'h1c;
      8'h10: S0 = 8'h28;  8'h11: S0 = 8'hd0;  8'h12: S0 = 8'h4b;  8'h13: S0 = 8'h92;
      8'h14: S0 = 8'h5c;  8'h15: S0 = 8'hee;  8'h16: S0 = 8'h85;  8'h17: S0 = 8'hb1;
      8'h18: S0 = 8'hc4;  8'h19: S0 = 8'h0a;  8'h1a: S0 = 8'h76;  8'h1b: S0 = 8'h3d;
      8'h1c: S0 = 8'h63;  8'h1d: S0 = 8'hf9;  8'h1e: S0 = 8'h17;  8'h1f: S0 = 8'haf;
      8'h20: S0 = 8'hbf;  8'h21: S0 = 8'ha1;  8'h22: S0 = 8'h19;  8'h23: S0 = 8'h65;
      8'h24: S0 = 8'hf7;  8'h25: S0 = 8'h7a;  8'h26: S0 = 8'h32;  8'h27: S0 = 8'h20;
      8'h28: S0 = 8'h06;  8'h29: S0 = 8'hce;  8'h2a: S0 = 8'he4;  8'h2b: S0 = 8'h83;
      8'h2c: S0 = 8'h9d;  8'h2d: S0 = 8'h5b;  8'h2e: S0 = 8'h4c;  8'h2f: S0 = 8'hd8;
      8'h30: S0 = 8'h42;  8'h31: S0 = 8'h5d;  8'h32: S0 = 8'h2e;  8'h33: S0 = 8'he8;
      8'h34: S0 = 8'hd4;  8'h35: S0 = 8'h9b;  8'h36: S0 = 8'h0f;  8'h37: S0 = 8'h13;
      8'h38: S0 = 8'h3c;  8'h39: S0 = 8'h89;  8'h3a: S0 = 8'h67;  8'h3b: S0 = 8'hc0;
      8'h3c: S0 = 8'h71;  8'h3d: S0 = 8'haa;  8'h3e: S0 = 8'hb6;  8'h3f: S0 = 8'hf5;
      8'h40: S0 = 8'ha4;  8'h41: S0 = 8'hbe;  8'h42: S0 = 8'hfd;  8'h43: S0 = 8'h8c;
      8'h44: S0 = 8'h12;  8'h45: S0 = 8'h00;  8'h46: S0 = 8'h97;  8'h47: S0 = 8'hda;
      8'h48: S0 = 8'h78;  8'h49: S0 = 8'he1;  8'h4a: S0 = 8'hcf;  8'h4b: S0 = 8'h6b;
      8'h4c: S0 = 8'h39;  8'h4d: S0 = 8'h43;  8'h4e: S0 = 8'h55;  8'h4f: S0 = 8'h26;
      8'h50: S0 = 8'h30;  8'h51: S0 = 8'h98;  8'h52: S0 = 8'hcc;  8'h53: S0 = 8'hdd;
      8'h54: S0 = 8'heb;  8'h55: S0 = 8'h54;  8'h56: S0 = 8'hb3;  8'h57: S0 = 8'h8f;
      8'h58: S0 = 8'h4e;  8'h59: S0 = 8'h16;  8'h5a: S0 = 8'hfa;  8'h5b: S0 = 8'h22;
      8'h5c: S0 = 8'ha5;  8'h5d: S0 = 8'h77;  8'h5e: S0 = 8'h09;  8'h5f: S0 = 8'h61;
      8'h60: S0 = 8'hd6;  8'h61: S0 = 8'h2a;  8'h62: S0 = 8'h53;  8'h63: S0 = 8'h37;
      8'h64: S0 = 8'h45;  8'h65: S0 = 8'hc1;  8'h66: S0 = 8'h6c;  8'h67: S0 = 8'hae;
      8'h68: S0 = 8'hef;  8'h69: S0 = 8'h70;  8'h6a: S0 = 8'h08;  8'h6b: S0 = 8'h99;
      8'h6c: S0 = 8'h8b;  8'h6d: S0 = 8'h1d;  8'h6e: S0 = 8'hf2;  8'h6f: S0 = 8'hb4;
      8'h70: S0 = 8'he9;  8'h71: S0 = 8'hc7;  8'h72: S0 = 8'h9f;  8'h73: S0 = 8'h4a;
      8'h74: S0 = 8'h31;  8'h75: S0 = 8'h25;  8'h76: S0 = 8'hfe;  8'h77: S0 = 8'h7c;
      8'h78: S0 = 8'hd3;  8'h79: S0 = 8'ha2;  8'h7a: S0 = 8'hbd;  8'h7b: S0 = 8'h56;
      8'h7c: S0 = 8'h14;  8'h7d: S0 = 8'h88;  8'h7e: S0 = 8'h60;  8'h7f: S0 = 8'h0b;
      8'h80: S0 = 8'hcd;  8'h81: S0 = 8'he2;  8'h82: S0 = 8'h34;  8'h83: S0 = 8'h50;
      8'h84: S0 = 8'h9e;  8'h85: S0 = 8'hdc;  8'h86: S0 = 8'h11;  8'h87: S0 = 8'h05;
      8'h88: S0 = 8'h2b;  8'h89: S0 = 8'hb7;  8'h8a: S0 = 8'ha9;  8'h8b: S0 = 8'h48;
      8'h8c: S0 = 8'hff;  8'h8d: S0 = 8'h66;  8'h8e: S0 = 8'h8a;  8'h8f: S0 = 8'h73;
      8'h90: S0 = 8'h03;  8'h91: S0 = 8'h75;  8'h92: S0 = 8'h86;  8'h93: S0 = 8'hf1;
      8'h94: S0 = 8'h6a;  8'h95: S0 = 8'ha7;  8'h96: S0 = 8'h40;  8'h97: S0 = 8'hc2;
      8'h98: S0 = 8'hb9;  8'h99: S0 = 8'h2c;  8'h9a: S0 = 8'hdb;  8'h9b: S0 = 8'h1f;
      8'h9c: S0 = 8'h58;  8'h9d: S0 = 8'h94;  8'h9e: S0 = 8'h3e;  8'h9f: S0 = 8'hed;
      8'ha0: S0 = 8'hfc;  8'ha1: S0 = 8'h1b;  8'ha2: S0 = 8'ha0;  8'ha3: S0 = 8'h04;
      8'ha4: S0 = 8'hb8;  8'ha5: S0 = 8'h8d;  8'ha6: S0 = 8'he6;  8'ha7: S0 = 8'h59;
      8'ha8: S0 = 8'h62;  8'ha9: S0 = 8'h93;  8'haa: S0 = 8'h35;  8'hab: S0 = 8'h7e;
      8'hac: S0 = 8'hca;  8'had: S0 = 8'h21;  8'hae: S0 = 8'hdf;  8'haf: S0 = 8'h47;
      8'hb0: S0 = 8'h15;  8'hb1: S0 = 8'hf3;  8'hb2: S0 = 8'hba;  8'hb3: S0 = 8'h7f;
      8'hb4: S0 = 8'ha6;  8'hb5: S0 = 8'h69;  8'hb6: S0 = 8'hc8;  8'hb7: S0 = 8'h4d;
      8'hb8: S0 = 8'h87;  8'hb9: S0 = 8'h3b;  8'hba: S0 = 8'h9c;  8'hbb: S0 = 8'h01;
      8'hbc: S0 = 8'he0;  8'hbd: S0 = 8'hde;  8'hbe: S0 = 8'h24;  8'hbf: S0 = 8'h52;
      8'hc0: S0 = 8'h7b;  8'hc1: S0 = 8'h0c;  8'hc2: S0 = 8'h68;  8'hc3: S0 = 8'h1e;
      8'hc4: S0 = 8'h80;  8'hc5: S0 = 8'hb2;  8'hc6: S0 = 8'h5a;  8'hc7: S0 = 8'he7;
      8'hc8: S0 = 8'had;  8'hc9: S0 = 8'hd5;  8'hca: S0 = 8'h23;  8'hcb: S0 = 8'hf4;
      8'hcc: S0 = 8'h46;  8'hcd: S0 = 8'h3f;  8'hce: S0 = 8'h91;  8'hcf: S0 = 8'hc9;
      8'hd0: S0 = 8'h6e;  8'hd1: S0 = 8'h84;  8'hd2: S0 = 8'h72;  8'hd3: S0 = 8'hbb;
      8'hd4: S0 = 8'h0d;  8'hd5: S0 = 8'h18;  8'hd6: S0 = 8'hd9;  8'hd7: S0 = 8'h96;
      8'hd8: S0 = 8'hf0;  8'hd9: S0 = 8'h5f;  8'hda: S0 = 8'h41;  8'hdb: S0 = 8'hac;
      8'hdc: S0 = 8'h27;  8'hdd: S0 = 8'hc5;  8'hde: S0 = 8'he3;  8'hdf: S0 = 8'h3a;
      8'he0: S0 = 8'h81;  8'he1: S0 = 8'h6f;  8'he2: S0 = 8'h07;  8'he3: S0 = 8'ha3;
      8'he4: S0 = 8'h79;  8'he5: S0 = 8'hf6;  8'he6: S0 = 8'h2d;  8'he7: S0 = 8'h38;
      8'he8: S0 = 8'h1a;  8'he9: S0 = 8'h44;  8'hea: S0 = 8'h5e;  8'heb: S0 = 8'hb5;
      8'hec: S0 = 8'hd2;  8'hed: S0 = 8'hec;  8'hee: S0 = 8'hcb;  8'hef: S0 = 8'h90;
      8'hf0: S0 = 8'h9a;  8'hf1: S0 = 8'h36;  8'hf2: S0 = 8'he5;  8'hf3: S0 = 8'h29;
      8'hf4: S0 = 8'hc3;  8'hf5: S0 = 8'h4f;  8'hf6: S0 = 8'hab;  8'hf7: S0 = 8'h64;
      8'hf8: S0 = 8'h51;  8'hf9: S0 = 8'hf8;  8'hfa: S0 = 8'h10;  8'hfb: S0 = 8'hd7;
      8'hfc: S0 = 8'hbc;  8'hfd: S0 = 8'h02;  8'hfe: S0 = 8'h7d;  8'hff: S0 = 8'h8e;
    endcase
  endfunction
  
  assign Dout = S0( Din );
  
endmodule


// -------------------------------------------------------------------
// S-box S_1
// -------------------------------------------------------------------
module CLEFIA_S1 ( Din, Dout );
  
  input   [7:0]  Din;
  output  [7:0]  Dout;
  
  function  [7:0]  S1;
  input     [7:0]  in;
    case ( in )
      8'h00: S1 = 8'h6c;  8'h01: S1 = 8'hda;  8'h02: S1 = 8'hc3;  8'h03: S1 = 8'he9;
      8'h04: S1 = 8'h4e;  8'h05: S1 = 8'h9d;  8'h06: S1 = 8'h0a;  8'h07: S1 = 8'h3d;
      8'h08: S1 = 8'hb8;  8'h09: S1 = 8'h36;  8'h0a: S1 = 8'hb4;  8'h0b: S1 = 8'h38;
      8'h0c: S1 = 8'h13;  8'h0d: S1 = 8'h34;  8'h0e: S1 = 8'h0c;  8'h0f: S1 = 8'hd9;
      8'h10: S1 = 8'hbf;  8'h11: S1 = 8'h74;  8'h12: S1 = 8'h94;  8'h13: S1 = 8'h8f;
      8'h14: S1 = 8'hb7;  8'h15: S1 = 8'h9c;  8'h16: S1 = 8'he5;  8'h17: S1 = 8'hdc;
      8'h18: S1 = 8'h9e;  8'h19: S1 = 8'h07;  8'h1a: S1 = 8'h49;  8'h1b: S1 = 8'h4f;
      8'h1c: S1 = 8'h98;  8'h1d: S1 = 8'h2c;  8'h1e: S1 = 8'hb0;  8'h1f: S1 = 8'h93;
      8'h20: S1 = 8'h12;  8'h21: S1 = 8'heb;  8'h22: S1 = 8'hcd;  8'h23: S1 = 8'hb3;
      8'h24: S1 = 8'h92;  8'h25: S1 = 8'he7;  8'h26: S1 = 8'h41;  8'h27: S1 = 8'h60;
      8'h28: S1 = 8'he3;  8'h29: S1 = 8'h21;  8'h2a: S1 = 8'h27;  8'h2b: S1 = 8'h3b;
      8'h2c: S1 = 8'he6;  8'h2d: S1 = 8'h19;  8'h2e: S1 = 8'hd2;  8'h2f: S1 = 8'h0e;
      8'h30: S1 = 8'h91;  8'h31: S1 = 8'h11;  8'h32: S1 = 8'hc7;  8'h33: S1 = 8'h3f;
      8'h34: S1 = 8'h2a;  8'h35: S1 = 8'h8e;  8'h36: S1 = 8'ha1;  8'h37: S1 = 8'hbc;
      8'h38: S1 = 8'h2b;  8'h39: S1 = 8'hc8;  8'h3a: S1 = 8'hc5;  8'h3b: S1 = 8'h0f;
      8'h3c: S1 = 8'h5b;  8'h3d: S1 = 8'hf3;  8'h3e: S1 = 8'h87;  8'h3f: S1 = 8'h8b;
      8'h40: S1 = 8'hfb;  8'h41: S1 = 8'hf5;  8'h42: S1 = 8'hde;  8'h43: S1 = 8'h20;
      8'h44: S1 = 8'hc6;  8'h45: S1 = 8'ha7;  8'h46: S1 = 8'h84;  8'h47: S1 = 8'hce;
      8'h48: S1 = 8'hd8;  8'h49: S1 = 8'h65;  8'h4a: S1 = 8'h51;  8'h4b: S1 = 8'hc9;
      8'h4c: S1 = 8'ha4;  8'h4d: S1 = 8'hef;  8'h4e: S1 = 8'h43;  8'h4f: S1 = 8'h53;
      8'h50: S1 = 8'h25;  8'h51: S1 = 8'h5d;  8'h52: S1 = 8'h9b;  8'h53: S1 = 8'h31;
      8'h54: S1 = 8'he8;  8'h55: S1 = 8'h3e;  8'h56: S1 = 8'h0d;  8'h57: S1 = 8'hd7;
      8'h58: S1 = 8'h80;  8'h59: S1 = 8'hff;  8'h5a: S1 = 8'h69;  8'h5b: S1 = 8'h8a;
      8'h5c: S1 = 8'hba;  8'h5d: S1 = 8'h0b;  8'h5e: S1 = 8'h73;  8'h5f: S1 = 8'h5c;
      8'h60: S1 = 8'h6e;  8'h61: S1 = 8'h54;  8'h62: S1 = 8'h15;  8'h63: S1 = 8'h62;
      8'h64: S1 = 8'hf6;  8'h65: S1 = 8'h35;  8'h66: S1 = 8'h30;  8'h67: S1 = 8'h52;
      8'h68: S1 = 8'ha3;  8'h69: S1 = 8'h16;  8'h6a: S1 = 8'hd3;  8'h6b: S1 = 8'h28;
      8'h6c: S1 = 8'h32;  8'h6d: S1 = 8'hfa;  8'h6e: S1 = 8'haa;  8'h6f: S1 = 8'h5e;
      8'h70: S1 = 8'hcf;  8'h71: S1 = 8'hea;  8'h72: S1 = 8'hed;  8'h73: S1 = 8'h78;
      8'h74: S1 = 8'h33;  8'h75: S1 = 8'h58;  8'h76: S1 = 8'h09;  8'h77: S1 = 8'h7b;
      8'h78: S1 = 8'h63;  8'h79: S1 = 8'hc0;  8'h7a: S1 = 8'hc1;  8'h7b: S1 = 8'h46;
      8'h7c: S1 = 8'h1e;  8'h7d: S1 = 8'hdf;  8'h7e: S1 = 8'ha9;  8'h7f: S1 = 8'h99;
      8'h80: S1 = 8'h55;  8'h81: S1 = 8'h04;  8'h82: S1 = 8'hc4;  8'h83: S1 = 8'h86;
      8'h84: S1 = 8'h39;  8'h85: S1 = 8'h77;  8'h86: S1 = 8'h82;  8'h87: S1 = 8'hec;
      8'h88: S1 = 8'h40;  8'h89: S1 = 8'h18;  8'h8a: S1 = 8'h90;  8'h8b: S1 = 8'h97;
      8'h8c: S1 = 8'h59;  8'h8d: S1 = 8'hdd;  8'h8e: S1 = 8'h83;  8'h8f: S1 = 8'h1f;
      8'h90: S1 = 8'h9a;  8'h91: S1 = 8'h37;  8'h92: S1 = 8'h06;  8'h93: S1 = 8'h24;
      8'h94: S1 = 8'h64;  8'h95: S1 = 8'h7c;  8'h96: S1 = 8'ha5;  8'h97: S1 = 8'h56;
      8'h98: S1 = 8'h48;  8'h99: S1 = 8'h08;  8'h9a: S1 = 8'h85;  8'h9b: S1 = 8'hd0;
      8'h9c: S1 = 8'h61;  8'h9d: S1 = 8'h26;  8'h9e: S1 = 8'hca;  8'h9f: S1 = 8'h6f;
      8'ha0: S1 = 8'h7e;  8'ha1: S1 = 8'h6a;  8'ha2: S1 = 8'hb6;  8'ha3: S1 = 8'h71;
      8'ha4: S1 = 8'ha0;  8'ha5: S1 = 8'h70;  8'ha6: S1 = 8'h05;  8'ha7: S1 = 8'hd1;
      8'ha8: S1 = 8'h45;  8'ha9: S1 = 8'h8c;  8'haa: S1 = 8'h23;  8'hab: S1 = 8'h1c;
      8'hac: S1 = 8'hf0;  8'had: S1 = 8'hee;  8'hae: S1 = 8'h89;  8'haf: S1 = 8'had;
      8'hb0: S1 = 8'h7a;  8'hb1: S1 = 8'h4b;  8'hb2: S1 = 8'hc2;  8'hb3: S1 = 8'h2f;
      8'hb4: S1 = 8'hdb;  8'hb5: S1 = 8'h5a;  8'hb6: S1 = 8'h4d;  8'hb7: S1 = 8'h76;
      8'hb8: S1 = 8'h67;  8'hb9: S1 = 8'h17;  8'hba: S1 = 8'h2d;  8'hbb: S1 = 8'hf4;
      8'hbc: S1 = 8'hcb;  8'hbd: S1 = 8'hb1;  8'hbe: S1 = 8'h4a;  8'hbf: S1 = 8'ha8;
      8'hc0: S1 = 8'hb5;  8'hc1: S1 = 8'h22;  8'hc2: S1 = 8'h47;  8'hc3: S1 = 8'h3a;
      8'hc4: S1 = 8'hd5;  8'hc5: S1 = 8'h10;  8'hc6: S1 = 8'h4c;  8'hc7: S1 = 8'h72;
      8'hc8: S1 = 8'hcc;  8'hc9: S1 = 8'h00;  8'hca: S1 = 8'hf9;  8'hcb: S1 = 8'he0;
      8'hcc: S1 = 8'hfd;  8'hcd: S1 = 8'he2;  8'hce: S1 = 8'hfe;  8'hcf: S1 = 8'hae;
      8'hd0: S1 = 8'hf8;  8'hd1: S1 = 8'h5f;  8'hd2: S1 = 8'hab;  8'hd3: S1 = 8'hf1;
      8'hd4: S1 = 8'h1b;  8'hd5: S1 = 8'h42;  8'hd6: S1 = 8'h81;  8'hd7: S1 = 8'hd6;
      8'hd8: S1 = 8'hbe;  8'hd9: S1 = 8'h44;  8'hda: S1 = 8'h29;  8'hdb: S1 = 8'ha6;
      8'hdc: S1 = 8'h57;  8'hdd: S1 = 8'hb9;  8'hde: S1 = 8'haf;  8'hdf: S1 = 8'hf2;
      8'he0: S1 = 8'hd4;  8'he1: S1 = 8'h75;  8'he2: S1 = 8'h66;  8'he3: S1 = 8'hbb;
      8'he4: S1 = 8'h68;  8'he5: S1 = 8'h9f;  8'he6: S1 = 8'h50;  8'he7: S1 = 8'h02;
      8'he8: S1 = 8'h01;  8'he9: S1 = 8'h3c;  8'hea: S1 = 8'h7f;  8'heb: S1 = 8'h8d;
      8'hec: S1 = 8'h1a;  8'hed: S1 = 8'h88;  8'hee: S1 = 8'hbd;  8'hef: S1 = 8'hac;
      8'hf0: S1 = 8'hf7;  8'hf1: S1 = 8'he4;  8'hf2: S1 = 8'h79;  8'hf3: S1 = 8'h96;
      8'hf4: S1 = 8'ha2;  8'hf5: S1 = 8'hfc;  8'hf6: S1 = 8'h6d;  8'hf7: S1 = 8'hb2;
      8'hf8: S1 = 8'h6b;  8'hf9: S1 = 8'h03;  8'hfa: S1 = 8'he1;  8'hfb: S1 = 8'h2e;
      8'hfc: S1 = 8'h7d;  8'hfd: S1 = 8'h14;  8'hfe: S1 = 8'h95;  8'hff: S1 = 8'h1d;

    endcase
  endfunction
  
  assign Dout = S1( Din );
  
endmodule


// -------------------------------------------------------------------
// Diffusion Matrix M_0
// -------------------------------------------------------------------
module CLEFIA_M0 ( Din, Dout );
  
  input   [31:0]  Din;
  output  [31:0]  Dout;
  
  wire    [7:0]   X0, X1, X2, X3;
  wire    [7:0]   Y0, Y1, Y2, Y3;
  wire    [7:0]   A0, A1;
  wire    [7:0]   B0, B1;
  wire    [7:0]   C0, C1;
  wire    [7:0]   D0, D1;
  
  function  [7:0]  func_02times;  // {02} x a
  input     [7:0]  a;
  begin
    func_02times[0] = a[7];
    func_02times[1] = a[0];
    func_02times[2] = a[1] ^ a[7];
    func_02times[3] = a[2] ^ a[7];
    func_02times[4] = a[3] ^ a[7];
    func_02times[5] = a[4];
    func_02times[6] = a[5];
    func_02times[7] = a[6];
  end
  endfunction
  
  function  [7:0]  func_04times;  // {04} x a
  input     [7:0]  a;
  reg              tmp;
  begin
    tmp             = a[6] ^ a[7];
    func_04times[0] = a[6];
    func_04times[1] = a[7];
    func_04times[2] = a[0] ^ a[6];
    func_04times[3] = a[1] ^ tmp;
    func_04times[4] = a[2] ^ tmp;
    func_04times[5] = a[3] ^ a[7];
    func_04times[6] = a[4];
    func_04times[7] = a[5];
  end
  endfunction
  
  // input 
  assign X0 = Din[31:24];
  assign X1 = Din[23:16];
  assign X2 = Din[15:8];
  assign X3 = Din[7:0];
  
  // A0 = X0 + X1, A1 = X2 + X3
  assign A0 = X0 ^ X1;
  assign A1 = X2 ^ X3;
  
  // B0 = X0 + X2, B1 = X1 + X3
  assign B0 = X0 ^ X2;
  assign B1 = X1 ^ X3;
  
  // C0 = {02} x B0, C1 = {02} x B1
  assign C0 = func_02times( B0 );
  assign C1 = func_02times( B1 );
  
  // D0 = {04} x A0, D1 = {04} x A1
  assign D0 = func_04times( A0 );
  assign D1 = func_04times( A1 );
  
  // Y0 = C1 + D1 + X0, Y1 = C0 + D1 + X1, Y2 = C1 + D0 + X2, Y3 = C0 + D0 + X3
  assign Y0 = C1 ^ D1 ^ X0;
  assign Y1 = C0 ^ D1 ^ X1;
  assign Y2 = C1 ^ D0 ^ X2;
  assign Y3 = C0 ^ D0 ^ X3;
  
  // output
  assign Dout = {Y0, Y1, Y2, Y3};
  
endmodule


// -------------------------------------------------------------------
// Diffusion Matrix M_1
// -------------------------------------------------------------------
module CLEFIA_M1 ( Din, Dout );
  
  input   [31:0]  Din;
  output  [31:0]  Dout;
  
  wire    [7:0]   X0, X1, X2, X3;
  wire    [7:0]   Y0, Y1, Y2, Y3;
  wire    [7:0]   A0, A1;
  wire    [7:0]   B0, B1;
  wire    [7:0]   C0, C1;
  wire    [7:0]   D0, D1;
  
  function  [7:0]  func_02times;  // {02} x a
  input     [7:0]  a;
  begin
    func_02times[0] = a[7];
    func_02times[1] = a[0];
    func_02times[2] = a[1] ^ a[7];
    func_02times[3] = a[2] ^ a[7];
    func_02times[4] = a[3] ^ a[7];
    func_02times[5] = a[4];
    func_02times[6] = a[5];
    func_02times[7] = a[6];
  end
  endfunction
  
  function  [7:0]  func_08times;  // {08} x a
  input     [7:0]  a;
  reg              tmp;
  begin
    tmp             = a[6] ^ a[7];
    func_08times[0] = a[5];
    func_08times[1] = a[6];
    func_08times[2] = a[5] ^ a[7];
    func_08times[3] = a[0] ^ a[5] ^ a[6];
    func_08times[4] = a[1] ^ a[5] ^ tmp;
    func_08times[5] = a[2] ^ tmp;
    func_08times[6] = a[3] ^ a[7];
    func_08times[7] = a[4];
  end
  endfunction
  
  // input 
  assign X0 = Din[31:24];
  assign X1 = Din[23:16];
  assign X2 = Din[15:8];
  assign X3 = Din[7:0];
  
  // A0 = X0 + X1, A1 = X2 + X3
  assign A0 = X0 ^ X1;
  assign A1 = X2 ^ X3;
  
  // B0 = X0 + X2, B1 = X1 + X3
  assign B0 = X0 ^ X2;
  assign B1 = X1 ^ X3;
  
  // C0 = {02} x A0, C1 = {02} x A1
  assign C0 = func_02times( A0 );
  assign C1 = func_02times( A1 );
  
  // D0 = {08} x B0, D1 = {08} x B1
  assign D0 = func_08times( B0 );
  assign D1 = func_08times( B1 );
  
  // Y0 = C1 + D1 + X0, Y1 = C0 + D1 + X1, Y2 = C1 + D0 + X2, Y3 = C0 + D0 + X3
  assign Y0 = C1 ^ D1 ^ X0;
  assign Y1 = C1 ^ D0 ^ X1;
  assign Y2 = C0 ^ D1 ^ X2;
  assign Y3 = C0 ^ D0 ^ X3;
  
  // output
  assign Dout = {Y0, Y1, Y2, Y3};
  
endmodule
