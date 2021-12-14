module q_block
#(
 parameter         DATA_LENGTH            = 32,
 parameter         KQFACTOR_LENGTH        = 16
)
(
 input  wire                                 clk,
 input  wire                                 reset,
 input  wire                                 w_en,
 input  wire [3                   : 0]       action_decode,
 input  wire [DATA_LENGTH     - 1 : 0]       w_data,
 
 output wire [DATA_LENGTH*4   - 1 : 0]       r_data
);
 reg         [DATA_LENGTH     - 1 : 0]       register    [3 : 0];
 assign                                      r_data = {register[3], register[2], register[1], register[0]};  // {0 - LEFT, 1 - UP, 2 - RIGHT, 3 - DOWN}
 
 always @ (posedge clk or negedge reset)
  if (!reset) begin
    register[0] = {DATA_LENGTH{1'b0}};
	 register[1] = {DATA_LENGTH{1'b0}};
	 register[2] = {DATA_LENGTH{1'b0}};
	 register[3] = {DATA_LENGTH{1'b0}};
   /*
    register[0] = {{(DATA_LENGTH - KQFACTOR_LENGTH - 1){1'b0}}, 1'b1, {KQFACTOR_LENGTH{1'b0}}};
	 register[1] = {{(DATA_LENGTH - KQFACTOR_LENGTH - 1){1'b0}}, 1'b1, {KQFACTOR_LENGTH{1'b0}}};
	 register[2] = {{(DATA_LENGTH - KQFACTOR_LENGTH - 1){1'b0}}, 1'b1, {KQFACTOR_LENGTH{1'b0}}};
	 register[3] = {{(DATA_LENGTH - KQFACTOR_LENGTH - 1){1'b0}}, 1'b1, {KQFACTOR_LENGTH{1'b0}}};
   */
   /*
   register[0] = {DATA_LENGTH{1'b0}};
	 register[1] = {DATA_LENGTH{1'b0}};
	 register[2] = {DATA_LENGTH{1'b0}};
	 register[3] = {DATA_LENGTH{1'b0}};
   */
   end
  else begin
    if (w_en & action_decode[0]) register[0] = w_data;
	 if (w_en & action_decode[1]) register[1] = w_data;
	 if (w_en & action_decode[2]) register[2] = w_data;
	 if (w_en & action_decode[3]) register[3] = w_data;
  end
 
endmodule 