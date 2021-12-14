module mux_2to1
#(
 parameter DATA_LENGTH = 32
)
(
 input  wire [DATA_LENGTH - 1 : 0] in_0,
 input  wire [DATA_LENGTH - 1 : 0] in_1,
 input  wire                       select,
 // Output
 output wire [DATA_LENGTH - 1 : 0] out
 );
 
 assign out = (select) ? in_1 : in_0;
 
 /*
 always @ (*)
  case (select)
   1'b0 : out = in_0;
	1'b1 : out = in_1;
  endcase
 */
endmodule 