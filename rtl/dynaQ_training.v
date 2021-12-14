module dynaQ_training 
#(
 parameter         LOCATION_LENGTH        = 6,
 parameter         STEP_LENGTH            = 10,
 parameter         REWARD_LENGTH          = 11,
 parameter         KQFACTOR_LENGTH        = 16,
 parameter         EPSILON_LENGTH         = 17,
 parameter         DATA_LENGTH            = 64
)
(
 // ------------------------- Global ------------------------- 
 input  wire                              clk,
 input  wire                              reset,
 // ------------------------- Input -------------------------
 input  wire                              start,
 input  wire                              next,
 input  wire [LOCATION_LENGTH - 1 : 0]    start_location,
 input  wire [LOCATION_LENGTH - 1 : 0]    next_location,
 input  wire [DATA_LENGTH     - 1 : 0]    read_qvalue_0,
 input  wire [DATA_LENGTH     - 1 : 0]    read_qvalue_1,
 input  wire [DATA_LENGTH     - 1 : 0]    read_qvalue_2,
 input  wire [DATA_LENGTH     - 1 : 0]    read_qvalue_3,
 input  wire                              tx_done,
 input  wire [REWARD_LENGTH   - 1 : 0]    reward,
 
 // ------------------------- Output -------------------------
 output wire                              tx_dv,
 output wire [4                   : 0]    current_state,
 output wire [LOCATION_LENGTH - 1 : 0]    current_location,
 output wire [STEP_LENGTH     - 1 : 0]    step_count_data,
 output wire                              completed,
 output wire [7                   : 0]    o_next_location_data,
 output wire [DATA_LENGTH     - 1 : 0]    w_qtable_data,
 output wire                              w_qtable_en,
 output wire [1                   : 0]    action              // action space is (0,1,2,3) - (...)
);
/************************************************************************************************************************
*
*                                         CONNECTION DECLARATION
*
*************************************************************************************************************************/
 wire                                     w_history_table_enable;
 wire                                     w_history_table_enable_2;
 wire                                     update_episode_enable;
 wire                                     w_g_register_enable;
 wire                                     w_max_register_enable;
 wire                                     w_reward_register_enable;
 wire                                     w_qvalue_enable;
 wire                                     w_step_count_enable;
 wire                                     w_action_register_enable;
 wire                                     w_curent_location_enable;
 wire                                     w_next_location_enable;
 wire                                     w_temp_next_location_enable;
 wire                                     w_epsilon_register_enable;
 wire                                     w_epsilon_threshhold_enable;
 wire                                     remember_mode;
 wire                                     naddr_enviroment_register_en;
 // ------------------------- Write-Select -----------------------
 wire                                     tx_sel;
 wire [7                   : 0]           tx_data;
 wire [LOCATION_LENGTH - 1 : 0]           next_location_data;
 wire                                     w_curent_location_select;
 wire                                     w_g_register_select;
 wire                                     w_step_count_select;
 wire                                     equal_select;
 wire                                     remember_done;
 wire                                     remember_en;
 wire                                     meet_demon;
 wire                                     done;
 
 
 assign                                   o_next_location_data = (tx_sel) ? tx_data: {3'd0,next_location_data} + 8'd48;
/************************************************************************************************************************
*
*                                         MODULE DECLARATION
*
*************************************************************************************************************************/
// ----------------------------------------------------------------------------------------------------------------------
//--------------------------------------- Controller --------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------

dynaQ_training_controller_v2               training_controller (
 // ------------------------- Global ------------------------- 
 .clk                                     (clk),
 .reset                                   (reset),
 // ------------------------- Input -------------------------
 .tx_done                                 (tx_done),
 .start                                   (start),
 .next                                    (next),
 .completed                               (completed),
 .done                                    (done),
 .remember_done                           (remember_done),
 .remember_en                             (remember_en),

 // ------------------------- Write-En -----------------------\
 .w_history_table_enable                  (w_history_table_enable),
 .w_history_table_enable_2                (w_history_table_enable_2),
 .update_episode_enable                   (update_episode_enable),
 .w_g_register_enable                     (w_g_register_enable),
 .w_max_register_enable                   (w_max_register_enable),
 .w_reward_register_enable                (w_reward_register_enable),
 .w_qvalue_enable                         (w_qvalue_enable),
 .w_step_count_enable                     (w_step_count_enable),
 .w_action_register_enable                (w_action_register_enable),
 .w_curent_location_enable                (w_curent_location_enable),
 .w_next_location_enable                  (w_next_location_enable),
 .w_temp_next_location_enable             (w_temp_next_location_enable),
 .w_epsilon_register_enable               (w_epsilon_register_enable),
 .w_epsilon_threshhold_enable             (w_epsilon_threshhold_enable),
 .remember_mode                           (remember_mode),
 .naddr_enviroment_register_en            (naddr_enviroment_register_en),
 // ------------------------- Write-Select -----------------------
 .w_g_register_select                     (w_g_register_select),
 .w_curent_location_select                (w_curent_location_select),
 .w_step_count_select                     (w_step_count_select),
 .equal_select                            (equal_select),
 .current_state                           (current_state),
 .tx_dv                                   (tx_dv),
 .tx_sel                                  (tx_sel),
 .tx_data                                 (tx_data),
 // ------------------------ Write-Qtable En -----------------------
 .w_qtable_en                             (w_qtable_en)
);

// --------------------------------------------------------------------------------------------------------------------
//--------------------------------------- Datapath --------------------------------------------------------------------
// --------------------------------------------------------------------------------------------------------------------

dynaQ_training_datapath                      
#(
.LOCATION_LENGTH                          (LOCATION_LENGTH),
.STEP_LENGTH                              (STEP_LENGTH),
.EPSILON_LENGTH                           (EPSILON_LENGTH),
.REWARD_LENGTH                            (REWARD_LENGTH),
.DATA_LENGTH                              (DATA_LENGTH)
)training_datapath
(
// ------------------------- Global ------------------------- 
 .clk                                     (clk),
 .reset                                   (reset),
 // ------------------------- Write-En -----------------------
 .w_history_table_enable                  (w_history_table_enable),
 .w_history_table_enable_2                (w_history_table_enable_2),
 .update_episode_enable                   (update_episode_enable),
 .w_g_register_enable                     (w_g_register_enable),
 .w_max_register_enable                   (w_max_register_enable),
 .w_reward_register_enable                (w_reward_register_enable),
 .w_qvalue_enable                         (w_qvalue_enable),
 .w_step_count_enable                     (w_step_count_enable),
 .w_action_register_enable                (w_action_register_enable),
 .w_curent_location_enable                (w_curent_location_enable),
 .w_next_location_enable                  (w_next_location_enable),
 .w_temp_next_location_enable             (w_temp_next_location_enable),
 .w_epsilon_register_enable               (w_epsilon_register_enable),
 .w_epsilon_threshhold_enable             (w_epsilon_threshhold_enable),
 .remember_mode                           (remember_mode),
 .naddr_enviroment_register_en            (naddr_enviroment_register_en),
 // ------------------------- Write-Select -----------------------
 .w_g_register_select                     (w_g_register_select),
 .w_curent_location_select                (w_curent_location_select),
 .w_step_count_select                     (w_step_count_select),
 .equal_select                            (equal_select),
 // -------------------------- Data -------------------------
 .start_location                          (start_location),
 .next_location                           (next_location),
 .read_qvalue_0                           (read_qvalue_0),
 .read_qvalue_1                           (read_qvalue_1),
 .read_qvalue_2                           (read_qvalue_2),
 .read_qvalue_3                           (read_qvalue_3),
 //.gamma                                   (gamma),
 .reward                                  (reward),
 
 // ------------------------ Output ---------------------------
 .o_current_location                      (current_location),
 .step_count_data                         (step_count_data),
 .o_next_location                         (next_location_data),
 .w_qtable_data                           (w_qtable_data),
 .o_action                                (action),             // action space is (0,1,2,3) - (...)
 .completed                               (completed),
 .remember_en                             (remember_en),
 .done                                    (done)
);

// --------------------------------------------------------------------------------------------------------------------
//--------------------------------------- Datapath --------------------------------------------------------------------
// --------------------------------------------------------------------------------------------------------------------
/*
initial 
 forever @ (posedge clk)
  if (current_state == 4'd7) 
    $display("At time : %0t - Current Location: %0d", $time, current_location);
*/
endmodule 