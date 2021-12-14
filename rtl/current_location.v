module current_location
#(
 parameter DATA_LENGTH = 6
)
(
 input  wire                       clk,
 input  wire                       reset,
 input  wire                       enable,
 input  wire [DATA_LENGTH - 1 : 0] start_location,
 input  wire [DATA_LENGTH - 1 : 0] next_location,
 input  wire                       select,
 
 output wire [DATA_LENGTH - 1 : 0] out_data
);
 wire        [DATA_LENGTH - 1 : 0] w_data;

 mux_2to1 #(
  .DATA_LENGTH                     (DATA_LENGTH)
 )
 first_operand_mux(
  .in_0                            (start_location),
  .in_1                            (next_location),
  .select                          (select),
 // Output
  .out                             (w_data)
 );
 
 register_reset                    #(
 .DATA_LENGTH                     (DATA_LENGTH)
 )
 register(
  .clk                            (clk),
  .enable                         (enable),
  .reset                          (reset),
  .w_data                         (w_data),
   // Output
  .r_data                         (out_data)
 );
endmodule 