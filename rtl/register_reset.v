module register_reset 
#(
 parameter           DATA_LENGTH = 32,
 parameter           RESET_VALUE = {DATA_LENGTH{1'b0}}
)
( 
 input  wire                          clk,
 input  wire                          enable,
 input  wire                          reset,
 input  wire    [DATA_LENGTH - 1 : 0] w_data,
 output reg     [DATA_LENGTH - 1 : 0] r_data
);

always @ (posedge clk or negedge reset)
 if (!reset) r_data = RESET_VALUE;
 else        r_data = (enable) ? w_data : r_data;
 

endmodule 