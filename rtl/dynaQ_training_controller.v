module dynaQ_training_controller
#(
 parameter         STATE_LENGTH         = 4,
 parameter         NUMBER_OF_STATES     = 16,
 parameter         INITIAL_STATE        = 4'b0000,
 parameter         STATE_1              = 4'b0001,
 parameter         STATE_2              = 4'b0010,
 parameter         STATE_3              = 4'b0011,
 parameter         STATE_4              = 4'b0100,
 parameter         STATE_5              = 4'b0101,
 parameter         STATE_6              = 4'b0110,
 parameter         STATE_7              = 4'b0111,
 parameter         STATE_8              = 4'b1000,
 parameter         STATE_9              = 4'b1001,
 parameter         STATE_10             = 4'b1010,
 parameter         STATE_11             = 4'b1011,
 parameter         STATE_12             = 4'b1100,
 parameter         STATE_13             = 4'b1101,
 parameter         STATE_14             = 4'b1110,
 parameter         STATE_15             = 4'b1111
 )
(
 // ------------------------- Global ------------------------- 
 input  wire                              clk,
 input  wire                              reset,
 // ------------------------- Input -------------------------
 input  wire                              start,
 input  wire                              done,
 input  wire                              remember_done,
 input  wire                              meet_demon,
 // ------------------------- Write-En -----------------------
 output wire                              w_history_table_enable,
 output wire                              w_remember_time_enable,
 output wire                              w_remember_register_enable,
 output wire                              random_remember_en,
 output wire                              update_episode_enable,
 output wire                              w_g_register_enable,
 output wire                              w_max_register_enable,
 output wire                              w_reward_register_enable,
 output wire                              w_qvalue_enable,
 output wire                              w_step_count_enable,
 output wire                              w_action_register_enable,
 output wire                              w_curent_location_enable,
 output wire                              w_next_location_enable,
 output wire                              w_temp_next_location_enable,
 output wire                              w_epsilon_register_enable,
 output wire                              remember_current_register_en,
 output wire                              naddr_enviroment_register_en,
 // ------------------------- Write-Select -----------------------
 output reg                               w_curent_location_select,
 output reg                               w_g_register_select,
 output reg                               w_step_count_select,
 output reg                               equal_select,
 output wire                              w_remember_time_select,
 output wire                              w_qtable_en,
 output wire                              do_nothing,
 output reg  [STATE_LENGTH - 1    : 0]    current_state
);
/************************************************************************************************************************
*
*                                         CONNECTION DECLARATION
*
*************************************************************************************************************************/
 reg         [STATE_LENGTH - 1    : 0]    next_state;
 wire        [NUMBER_OF_STATES - 1: 0]    state_value;
 
 assign                                   state_value[0]  = !current_state[3] & !current_state[2] & !current_state[1] & !current_state[0];
 assign                                   state_value[1]  = !current_state[3] & !current_state[2] & !current_state[1] &  current_state[0];
 assign                                   state_value[2]  = !current_state[3] & !current_state[2] &  current_state[1] & !current_state[0];
 assign                                   state_value[3]  = !current_state[3] & !current_state[2] &  current_state[1] &  current_state[0];
 assign                                   state_value[4]  = !current_state[3] &  current_state[2] & !current_state[1] & !current_state[0];
 assign                                   state_value[5]  = !current_state[3] &  current_state[2] & !current_state[1] &  current_state[0];
 assign                                   state_value[6]  = !current_state[3] &  current_state[2] &  current_state[1] & !current_state[0];
 assign                                   state_value[7]  = !current_state[3] &  current_state[2] &  current_state[1] &  current_state[0];
 assign                                   state_value[8]  =  current_state[3] & !current_state[2] & !current_state[1] & !current_state[0];
 assign                                   state_value[9]  =  current_state[3] & !current_state[2] & !current_state[1] &  current_state[0];
 assign                                   state_value[10] =  current_state[3] & !current_state[2] &  current_state[1] & !current_state[0];
 assign                                   state_value[11] =  current_state[3] & !current_state[2] &  current_state[1] &  current_state[0];
 assign                                   state_value[12] =  current_state[3] &  current_state[2] & !current_state[1] & !current_state[0];
 assign                                   state_value[13] =  current_state[3] &  current_state[2] & !current_state[1] &  current_state[0];
 assign                                   state_value[14] =  current_state[3] &  current_state[2] &  current_state[1] & !current_state[0];
 assign                                   state_value[15] =  current_state[3] &  current_state[2] &  current_state[1] &  current_state[0];
 
 assign                                   do_nothing      =  state_value[15];
 
/************************************************************************************************************************
*
*                                         PROCEDURE DECLARATION
*
*************************************************************************************************************************/
 // ------------------------ Current State ----------------------

 always @ (posedge clk or negedge reset)
  if (!reset) current_state <= INITIAL_STATE;
  else        current_state <= next_state;
  
 // ------------------------- Next State ----------------------
 always @ (*)
  case (current_state)
  INITIAL_STATE: next_state <= (start) ? STATE_1 : INITIAL_STATE;
	STATE_1      : next_state <=  STATE_2;
	STATE_2      : next_state <= (done) ? INITIAL_STATE : STATE_3;
	STATE_3      : next_state <= STATE_4;
	STATE_4      : next_state <= STATE_5;
	STATE_5      : next_state <= STATE_6;
	STATE_6      : next_state <= STATE_7;
	STATE_7      : next_state <= (done) ? STATE_15 : STATE_8; // DynaQ 
	STATE_8      : next_state <= STATE_9; // DynaQ 
	//STATE_8      : next_state <= STATE_1; // Q_Learning
	STATE_9      : next_state <= STATE_10;
	STATE_10     : next_state <= STATE_11;
	STATE_11     : next_state <= STATE_12;
	STATE_12     : next_state <= STATE_13;
	STATE_13     : next_state <= (remember_done) ? STATE_14 : STATE_8;
	STATE_14     : next_state <= STATE_1;
	STATE_15     : next_state <= INITIAL_STATE;
	default      : next_state <= INITIAL_STATE;
  endcase
  
 // ---------------------- Output  Function ----------------------
 assign                                     update_episode_enable          = state_value[0];
 
 assign                                     w_g_register_enable            = state_value[6] | state_value[7] | state_value[12] | state_value[13];
 assign                                     w_reward_register_enable       = state_value[3] | state_value[9];
 assign                                     w_next_location_enable         = state_value[0] | state_value[3] | state_value[9] | state_value[14];
 /*
 assign                                     w_g_register_enable            = state_value[0] | state_value[1] | state_value[6];
 assign                                     w_reward_register_enable       = state_value[3];
 assign                                     w_next_location_enable         = state_value[0] | state_value[3];
*/
 
 assign                                     w_max_register_enable          = state_value[5] | state_value[11];
 assign                                     w_qvalue_enable                = state_value[1] | state_value[4] | state_value[10];
 assign                                     w_step_count_enable            = state_value[0] | state_value[2];
 assign                                     w_action_register_enable       = state_value[2] | state_value[8];
 assign                                     w_curent_location_enable       = state_value[0] | state_value[8] | state_value[14];
 assign                                     w_temp_next_location_enable    = state_value[7];
 assign                                     w_qtable_en                    = state_value[8] | state_value[14] | state_value[15];
 assign                                     random_remember_en             = state_value[7] | state_value[13];
 assign                                     w_epsilon_register_enable      = state_value[2];
 assign                                     w_history_table_enable         = state_value[8];
 assign                                     w_remember_time_enable         = state_value[1] | state_value[13];
 assign                                     w_remember_time_select         = state_value[13];
 assign                                     w_remember_register_enable     = state_value[8];
 assign                                     remember_current_register_en   = state_value[8];
 assign                                     naddr_enviroment_register_en   = state_value[3] | state_value[9];

 
 always @ (current_state)
  case (current_state)
   INITIAL_STATE:   begin
	 w_step_count_select            <= 1'b0;
    w_curent_location_select       <= 1'b0;
    equal_select                   <= 1'b0;
	 w_g_register_select            <= 1'b0;
   end
	STATE_1      :    begin
    w_curent_location_select       <= 1'bx;
	 w_step_count_select            <= 1'bx;
    equal_select                   <= 1'b1;
	 w_g_register_select            <= 1'b0;
   end
	STATE_2      :    begin
    w_curent_location_select       <= 1'bx;
	 w_step_count_select            <= 1'b1;
    equal_select                   <= 1'b1;
	 w_g_register_select            <= 1'b0;
   end
	STATE_3      :    begin
    w_curent_location_select       <= 1'b1;
	 w_step_count_select            <= 1'bx;
    equal_select                   <= 1'b1;
	 w_g_register_select            <= 1'b0;
   end
	STATE_4      :    begin
    w_curent_location_select       <= 1'bx;
	 w_step_count_select            <= 1'bx;
    equal_select                   <= 1'b0;
	 w_g_register_select            <= 1'b0;
   end
	STATE_5      :    begin
    w_curent_location_select       <= 1'bx;
	 w_step_count_select            <= 1'bx;
    equal_select                   <= 1'b1;
	 w_g_register_select            <= 1'b0;
   end
   
	STATE_6      :    begin
    w_curent_location_select       <= 1'bx;
	 w_step_count_select            <= 1'bx;
    equal_select                   <= 1'b1;
	 w_g_register_select            <= 1'b0;
   end
   
	STATE_7      :    begin
    w_curent_location_select       <= 1'b1;
	 w_step_count_select            <= 1'bx;
    equal_select                   <= 1'b0;
	 w_g_register_select            <= 1'b1;
   end
   
  STATE_8      :    begin
    w_curent_location_select       <= 1'b1;
	  w_step_count_select           <= 1'bx;
    equal_select                   <= 1'b0;
	 w_g_register_select            <= 1'b0;
   end
   
  STATE_9      :    begin
    w_curent_location_select       <= 1'b1;
	 w_step_count_select            <= 1'bx;
    equal_select                   <= 1'b1;
	 w_g_register_select            <= 1'b0;
   end
	
	STATE_12    :    begin
    w_curent_location_select       <= 1'bx;
	 w_step_count_select            <= 1'bx;
    equal_select                   <= 1'b1;
	 w_g_register_select            <= 1'b0;
   end
	
	STATE_13     :    begin
    w_curent_location_select       <= 1'b1;
	 w_step_count_select            <= 1'bx;
    equal_select                   <= 1'b0;
	 w_g_register_select            <= 1'b1;
   end
	STATE_14     :    begin
    w_curent_location_select       <= 1'b1;
	 w_step_count_select            <= 1'bx;
    equal_select                   <= 1'b0;
	 w_g_register_select            <= 1'b1;
   end
	
	default : begin
    w_curent_location_select       <= 1'bx;
	 w_step_count_select            <= 1'bx;
    equal_select                   <= 1'b0;
	 w_g_register_select            <= 1'b0;
	end
  endcase
  
/* -----------------------------------------------------------------------------------------------------------------
*
*                                                   Initial
*
----------------------------------------------------------------------------------------------------------------- */

integer episode_count = 0;
integer step_count    = 0;

initial
 forever @ (posedge clk) begin
  if       (state_value[0]) begin
   episode_count = 0;
	step_count    = 0;
  end // if       (state_value[0])
  else if  (state_value[1]) begin
   episode_count = episode_count + 1;
	step_count    = step_count    + 1;
  end // if  (state_value[1])
 
 if (state_value[0]) $display("At time %0t - episode %0d - step %0d: DONE !!!", $time, episode_count, step_count);
 
 end // forever
  
 endmodule 
 
