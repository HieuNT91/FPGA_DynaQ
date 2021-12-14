// This module included a table which is used for storing the location and action that robot go through and a random generator.

module history_table_v2
#(
 parameter         LOCATION_LENGTH        = 8,
 parameter         STEP_LENGTH            = 5,
 parameter         REGISTER_LENGTH        = 25,
 parameter         REWARD_LENGTH          = 11
)
(
 input  wire                                  clk,
 input  wire                                  reset,
 input  wire                                  w_en,
 input  wire                                  w_en_2,
 input  wire        [LOCATION_LENGTH - 1 : 0] current_location,
 input  wire        [LOCATION_LENGTH - 1 : 0] n_location,
 input  wire        [LOCATION_LENGTH - 1 : 0] next_location,
 input  wire        [REWARD_LENGTH   - 1 : 0] reward,
 input  wire        [1                   : 0] action,
 
 output wire        [1                   : 0] remember_action,
 output wire        [LOCATION_LENGTH - 1 : 0] remember_location,
 output wire        [LOCATION_LENGTH - 1 : 0] remember_n_location,
 output wire        [REWARD_LENGTH   - 1 : 0] remember_reward
);
/************************************************************************************************************************
*
*                                         MODULE DECLARATION
*
*************************************************************************************************************************/
wire true_w_en;
assign true_w_en = (current_location  == n_location);
//assign true_w_en = 1'b0;
// ----------------------------------------------------------------------------------------------------------------------
//--------------------------------------- History Table -----------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------
 register_reset #(
  .DATA_LENGTH                             (LOCATION_LENGTH)
 )
 location_register
 (
  .clk                                     (clk              ),
  .reset                                   (reset            ),
  .enable                                  (w_en & !true_w_en),
  .w_data                                  (current_location ),
  .r_data                                  (remember_location)
 );
 
  register_reset #(
  .DATA_LENGTH                             (2)
 )
 action_register
 (
  .clk                                     (clk            ),
  .reset                                   (reset          ),
  .enable                                  (w_en & !true_w_en),
  .w_data                                  (action         ),
  .r_data                                  (remember_action)
 );
 
 register_reset #(
  .DATA_LENGTH                             (LOCATION_LENGTH)
 )
 nlocation_register
 (
  .clk                                     (clk            ),
  .reset                                   (reset          ),
  .enable                                  (w_en_2),
  .w_data                                  (next_location),
  .r_data                                  (remember_n_location               )
 );
 
  register_reset #(
  .DATA_LENGTH                             (REWARD_LENGTH)
 )
 reward_register
 (
  .clk                                     (clk            ),
  .reset                                   (reset          ),
  .enable                                  (w_en_2),
  .w_data                                  (reward),
  .r_data                                  (remember_reward               )
 );
endmodule  