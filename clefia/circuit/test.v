// SASEBO checker でやる時は右詰めで80bit
`timescale 1ns/1ns

module test;
	reg            CLK;      // system clock
	reg            SRST;     // synchronous reset
	reg   [1:0]    MODE;     // 00: 128-bit key, 01: 192-bit key, 10: 256-bit key
	reg            ENCDEC;   // 0:encryption, 1:decryption
	reg            KEYSET;   // key set signal
	reg            DATASET;  // data set signal
	reg   [255:0]  KEY;      // key reg
	reg   [127:0]  DIN;      // data input
	wire           BSY;      // busy signal
	wire           DVLD;     // data output valid signal
	wire  [127:0]  DOUT;     // data output
	
	parameter times = 1;
	always #(times)   CLK = ~CLK;
	CLEFIA CLEFIA ( CLK, SRST, MODE, ENCDEC, KEYSET, DATASET, KEY, DIN, BSY, DVLD, DOUT );

	initial begin
		CLK  <= 0;
		repeat(10) @(posedge CLK);
		SRST <= 1;
		KEYSET <= 0;
		KEY <= 255'h0;
		repeat(10) @(posedge CLK);
		SRST <= 0;
		MODE <=2'b00;
		// MODE <=2'b01;
		KEYSET <= 1;
		KEY[127:0] <= 128'hffeeddccbbaa99887766554433221100;
		// KEY[195:0] <= 196'hffeeddccbbaa99887766554433221100f0e0d0c0b0a09080;
		repeat(1) @(posedge CLK);
		KEYSET <= 0;
		MODE <= 2'bz;
		@(negedge BSY)
		// MODE <=2'b01;
		MODE <=2'b00;
		repeat(10) @(posedge CLK);
		DATASET <= 1;
		DIN[127:0] <= 128'h000102030405060708090a0b0c0d0e0f;
		ENCDEC <= 0;
		@(posedge CLK)
		DATASET <= 0;
		@(negedge BSY)
		repeat(10) @(posedge CLK)
		$finish;
	end

	initial begin
		$monitor($time, "Dout=%h", DOUT);
		$dumpfile("Test.vcd");
		$dumpvars(0, test);
	end

endmodule
