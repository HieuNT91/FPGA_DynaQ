// Copyright (C) 1991-2013 Altera Corporation
// Your use of Altera Corporation's design tools, logic functions 
// and other software and tools, and its AMPP partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License 
// Subscription Agreement, Altera MegaCore Function License 
// Agreement, or other applicable license agreement, including, 
// without limitation, that your use is for the sole purpose of 
// programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the 
// applicable agreement for further details.

// PROGRAM		"Quartus II 64-Bit"
// VERSION		"Version 13.0.1 Build 232 06/12/2013 Service Pack 1 SJ Web Edition"
// CREATED		"Tue Jan 26 12:19:06 2021"

module KIT_dynaQ(
	CLOCK_50,
	KEY,
	SW,
	UART_TXD,
	HEX0,
	HEX1,
	LEDR
);


input wire	CLOCK_50;
input wire	[2:0] KEY;
input wire	[7:0] SW;
output wire	UART_TXD;
output wire	[6:0] HEX0;
output wire	[6:0] HEX1;
output wire	[16:16] LEDR;

wire	[3:0] ONES;
wire	[7:0] STEPS;
wire	[3:0] TENS;
wire	SYNTHESIZED_WIRE_0;
wire	SYNTHESIZED_WIRE_1;
wire	SYNTHESIZED_WIRE_2;
wire	SYNTHESIZED_WIRE_3;
wire	[7:0] SYNTHESIZED_WIRE_4;





dynaQ_demon_toplevel	b2v_inst(
	.clk(CLOCK_50),
	.reset(KEY[0]),
	.start(SYNTHESIZED_WIRE_0),
	.next(SYNTHESIZED_WIRE_1),
	.tx_done(SYNTHESIZED_WIRE_2),
	.start_location(SW),
	.tx_dv(SYNTHESIZED_WIRE_3),
	.completed(LEDR),
	
	.o_current_location(SYNTHESIZED_WIRE_4),
	
	.step_count_data(STEPS[4:0]));
	defparam	b2v_inst.DATA_LENGTH = 16;
	defparam	b2v_inst.EPSILON_LENGTH = 7;
	defparam	b2v_inst.LOCATION_LENGTH = 8;
	defparam	b2v_inst.MAP_SIZE = 25;
	defparam	b2v_inst.REWARD_LENGTH = 2;
	defparam	b2v_inst.STEP_LENGTH = 5;


my_uart_tx	b2v_inst1(
	.i_Clock(CLOCK_50),
	.i_RST(KEY[0]),
	.i_Tx_DV(SYNTHESIZED_WIRE_3),
	.i_Tx_Byte(SYNTHESIZED_WIRE_4),
	.o_Tx_Serial(UART_TXD),
	.o_Tx_Done(SYNTHESIZED_WIRE_2)
	
	);
	defparam	b2v_inst1.CLKS_PER_BIT = 5209;
	defparam	b2v_inst1.s_CLEANUP = 3'b100;
	defparam	b2v_inst1.s_IDLE = 3'b000;
	defparam	b2v_inst1.s_TX_DATA_BITS = 3'b010;
	defparam	b2v_inst1.s_TX_START_BIT = 3'b001;
	defparam	b2v_inst1.s_TX_STOP_BIT = 3'b011;


binary_to_BCD	b2v_inst2(
	.A(STEPS),
	
	.ONES(ONES),
	.TENS(TENS));

assign	SYNTHESIZED_WIRE_0 =  ~KEY[1];

assign	SYNTHESIZED_WIRE_1 =  ~KEY[2];


\7447 	b2v_inst5(
	
	.B(ONES[1]),
	.C(ONES[2]),
	.D(ONES[3]),
	
	
	.A(ONES[0]),
	.OB(HEX0[1]),
	.OC(HEX0[2]),
	.OE(HEX0[4]),
	.OD(HEX0[3]),
	.OF(HEX0[5]),
	.OG(HEX0[6]),
	.OA(HEX0[0])
	);


\7447 	b2v_inst6(
	
	.B(TENS[1]),
	.C(TENS[2]),
	.D(TENS[3]),
	
	
	.A(TENS[0]),
	.OB(HEX1[1]),
	.OC(HEX1[2]),
	.OE(HEX1[4]),
	.OD(HEX1[3]),
	.OF(HEX1[5]),
	.OG(HEX1[6]),
	.OA(HEX1[0])
	);


assign	STEPS[7:5] = 3'b000;

endmodule
