//******************************************************************************//* Designer     : Akashi Satoh
//* E-Mail       : akashi.satoh@aist.go.jp
//* Version      : 0.1
//* Created      : June/09/2007
//* Updated      : June/09/2007
//*
//* File Name    : SHA256_TB.v
//******************************************************************************
`timescale 1ns/1ns

module SHA256_TB;

parameter CLOCK = 10;

reg         RSTn;
reg         CLK;
reg         EN;
reg         INIT;
reg  [31:0] MSGin;
reg         Mrdy;
wire [255:0] Hout;
wire        Hvld;

reg  [31:0] W[0:15];
wire        LED_out;

SHA256 C2( RSTn, CLK, EN, INIT, MSGin, Mrdy, Hout, Hvld, LED_out, Busy ); 

initial W[ 0] = 32'h61626380;
initial W[ 1] = 32'h00000000;
initial W[ 2] = 32'h00000000;
initial W[ 3] = 32'h00000000;
initial W[ 4] = 32'h00000000;
initial W[ 5] = 32'h00000000;
initial W[ 6] = 32'h00000000;
initial W[ 7] = 32'h00000000;
initial W[ 8] = 32'h00000000;
initial W[ 9] = 32'h00000000;
initial W[10] = 32'h00000000;
initial W[11] = 32'h00000000;
initial W[12] = 32'h00000000;
initial W[13] = 32'h00000000;
initial W[14] = 32'h00000000;
initial W[15] = 32'h00000018;

initial CLK  = 0;
  always #(CLOCK/2)
    CLK <= ~CLK;

initial begin

// Data Initialize and Sequencer Reset
  RSTn  <= 0;
  EN    <= 0;
  INIT  <= 0;
  MSGin <= 0;
  Mrdy  <= 0;
#(CLOCK*5)  RSTn <= 1;

#(CLOCK/5)
#(CLOCK)    EN     <= 1;

// 1st 32-bit*16 block
#(CLOCK*10) MSGin  <= W[0]; Mrdy <= 1;
#(CLOCK)    MSGin  <= W[1];// Mrdy <= 0;
//#(CLOCK)    Mrdy <= 1;
#(CLOCK*14) MSGin  <= W[15];
#(CLOCK)    Mrdy <= 0;
#(CLOCK*56)
#(CLOCK*14)

// 2nd 32-bit*16 block
            MSGin  <= W[0];  Mrdy <= 1;
#(CLOCK)    MSGin  <= W[15]; Mrdy <= 0;
#(CLOCK)                     Mrdy <= 1;
#(CLOCK*15) MSGin  <= W[15];
#(CLOCK)                     Mrdy <= 0;
#(CLOCK*6000)

$stop;
end
initial begin  
    $dumpfile("sha.vcd");  
    $dumpvars(0, SHA256_TB);  
end
endmodule
