`timescale 100ps/100ps
module KIT_dynaQ_tb();
reg	clk;
reg	reset;
reg	start;
reg	next;
reg	[4:0]start_location;
wire	UART_TXD;

dynaQ_demon_toplevel           dynaQ_demon_toplevel(
.CLOCK_50           (clk),
.KEY                ({next, start, reset, reset}),
.SW                 ({3'd0, start_location}),

.UART_TXD           (UART_TXD),
.HEX0               (),
.HEX1               (),
.LEDR               ()
);

initial begin
 clk = 1'b0;
 forever #1 clk = !clk;
end

initial begin
 start_location = 4'd0;
 reset = 1'b0;
 start = 1'b0;
 next  = 1'b0;
 #1;
 reset = 1'b1;
 #4;
 start = 1'b1;
 #80000;
 next  = 1'b1;
 start = 1'b1;
 #50;
 start = 1'b0;
end
endmodule 