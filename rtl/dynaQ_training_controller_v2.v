module dynaQ_training_controller_v2
#(
 parameter         STATE_LENGTH         = 5,
 parameter         NUMBER_OF_STATES     = 20,
 parameter         INITIAL_STATE        = 5'b00000,
 parameter         STATE_1              = 5'b00001,
 parameter         STATE_2              = 5'b00010,
 parameter         STATE_3              = 5'b00011,
 parameter         STATE_4              = 5'b00100,
 parameter         STATE_5              = 5'b00101,
 parameter         STATE_6              = 5'b00110,
 parameter         STATE_7              = 5'b00111,
 parameter         STATE_8              = 5'b01000,
 parameter         STATE_9              = 5'b01001,
 parameter         STATE_10             = 5'b01010,
 parameter         STATE_11             = 5'b01011,
 parameter         STATE_12             = 5'b01100,
 parameter         STATE_13             = 5'b01101,
 parameter         STATE_14             = 5'b01110,
 parameter         STATE_15             = 5'b01111,
 parameter         STATE_16             = 5'b10000,
 parameter         STATE_17             = 5'b10001,
 parameter         STATE_18             = 5'b10010,
 parameter         DECISION             = 5'b10011
 )
(
 // ------------------------- Global ------------------------- 
 input  wire                              clk,
 input  wire                              reset,
 // ------------------------- Input -------------------------
 input  wire                              start,
 input  wire                              next,
 input  wire                              completed,
 input  wire                              done,
 input  wire                              remember_done,
 input  wire                              tx_done,
 input  wire                              remember_en,
 // ------------------------- Write-En -----------------------
 output wire                              w_history_table_enable,
 output wire                              w_history_table_enable_2,
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
 output wire                              w_epsilon_threshhold_enable,
 output wire                              remember_mode,
 output wire                              naddr_enviroment_register_en,
 // ------------------------- Write-Select -----------------------
 output reg                               w_curent_location_select,
 output reg                               w_g_register_select,
 output reg                               w_step_count_select,
 output reg                               equal_select,
 output wire                              w_qtable_en,
 output wire                              tx_dv,
 output wire                              tx_sel,
 output wire [7                   : 0]    tx_data,
 output reg  [STATE_LENGTH - 1    : 0]    current_state
);
/************************************************************************************************************************
*
*                                         CONNECTION DECLARATION
*
*************************************************************************************************************************/
 reg         [STATE_LENGTH - 1    : 0]    next_state;
 reg                                      count_en;
 wire                                     done_signal;
 wire        [NUMBER_OF_STATES - 1: 0]    state_value;
 
 assign                                   state_value[0]  = !current_state[4] & !current_state[3] & !current_state[2] & !current_state[1] & !current_state[0];
 assign                                   state_value[1]  = !current_state[4] & !current_state[3] & !current_state[2] & !current_state[1] &  current_state[0];
 assign                                   state_value[2]  = !current_state[4] & !current_state[3] & !current_state[2] &  current_state[1] & !current_state[0];
 assign                                   state_value[3]  = !current_state[4] & !current_state[3] & !current_state[2] &  current_state[1] &  current_state[0];
 assign                                   state_value[4]  = !current_state[4] & !current_state[3] &  current_state[2] & !current_state[1] & !current_state[0];
 assign                                   state_value[5]  = !current_state[4] & !current_state[3] &  current_state[2] & !current_state[1] &  current_state[0];
 assign                                   state_value[6]  = !current_state[4] & !current_state[3] &  current_state[2] &  current_state[1] & !current_state[0];
 assign                                   state_value[7]  = !current_state[4] & !current_state[3] &  current_state[2] &  current_state[1] &  current_state[0];
 assign                                   state_value[8]  = !current_state[4] &  current_state[3] & !current_state[2] & !current_state[1] & !current_state[0];
 assign                                   state_value[9]  = !current_state[4] &  current_state[3] & !current_state[2] & !current_state[1] &  current_state[0];
 assign                                   state_value[10] = !current_state[4] &  current_state[3] & !current_state[2] &  current_state[1] & !current_state[0];
 assign                                   state_value[11] = !current_state[4] &  current_state[3] & !current_state[2] &  current_state[1] &  current_state[0];
 assign                                   state_value[12] = !current_state[4] &  current_state[3] &  current_state[2] & !current_state[1] & !current_state[0];
 assign                                   state_value[13] = !current_state[4] &  current_state[3] &  current_state[2] & !current_state[1] &  current_state[0];
 assign                                   state_value[14] = !current_state[4] &  current_state[3] &  current_state[2] &  current_state[1] & !current_state[0];
 assign                                   state_value[15] = !current_state[4] &  current_state[3] &  current_state[2] &  current_state[1] &  current_state[0];
 assign                                   state_value[16] =  current_state[4] & !current_state[3] & !current_state[2] & !current_state[1] & !current_state[0];
 assign                                   state_value[17] =  current_state[4] & !current_state[3] & !current_state[2] & !current_state[1] &  current_state[0];
 assign                                   state_value[18] =  current_state[4] & !current_state[3] & !current_state[2] &  current_state[1] & !current_state[0];
 assign                                   state_value[19] =  current_state[4] & !current_state[3] & !current_state[2] &  current_state[1] &  current_state[0];
/************************************************************************************************************************
*
*                                         PROCEDURE DECLARATION
*
*************************************************************************************************************************/
current_location #(
 .DATA_LENGTH                             (1)
)
done_signal_register // name
(
 .clk                                     (clk),
 .reset                                   (reset),
 .enable                                  (state_value[15] | state_value[4]),
 .start_location                          (1'b0),
 .next_location                           (done),
 .select                                  (state_value[4]),
 // Output
 .out_data                                (done_signal)
);
 always @ (posedge clk or negedge reset)
  if (!reset) count_en <= 1'b0;
  else if(state_value[19] & completed)        count_en <= 1'b1;

 // ------------------------ Current State ----------------------

 always @ (posedge clk or negedge reset)
  if (!reset) current_state <= DECISION;
  else        current_state <= next_state;
  
 // ------------------------- Next State ----------------------
 always @ (*)
  case (current_state)
  DECISION     : next_state <= (!completed) ? ((start) ? INITIAL_STATE : DECISION) : ((!next) ? INITIAL_STATE : DECISION);
  INITIAL_STATE: next_state <= STATE_1;
	STATE_1      : next_state <= (!completed) ? STATE_2 : (next) ? STATE_2 : STATE_1;
	STATE_2      : next_state <= (done) ? INITIAL_STATE : STATE_3;
	STATE_3      : next_state <= STATE_4;
	//STATE_3      : next_state <= (!completed) ? STATE_4 : (!next) ? STATE_4 : STATE_3;
	//STATE_4      : next_state <= (!completed) ? STATE_5 : (done_signal) ? DECISION : STATE_16;
	STATE_4      : next_state <= (!completed) ? STATE_5 : STATE_16;	
	STATE_5      : next_state <= STATE_6;
	STATE_6      : next_state <= STATE_7;
	STATE_7      : next_state <= (remember_en | done)  ? STATE_8 : STATE_15; // DynaQ
	STATE_15     : next_state <= (!done_signal) ? STATE_1 : INITIAL_STATE;
	STATE_8      : next_state <= STATE_9; // DynaQ 
	STATE_9      : next_state <= STATE_10;
	STATE_10     : next_state <= STATE_11;
	STATE_11     : next_state <= STATE_12;
	STATE_12     : next_state <= STATE_13;
	STATE_13     : next_state <= STATE_14;
	STATE_14     : next_state <= (!done_signal) ? STATE_1 : (completed) ? DECISION : INITIAL_STATE; // STATE_1
	STATE_16     : next_state <= (tx_done) ? STATE_17 : STATE_16;
	STATE_17     : next_state <= (tx_done) ? STATE_18 : STATE_17;
	STATE_18     : next_state <= (!tx_done)? STATE_18 : (done_signal) ? DECISION : STATE_1;
	default      : next_state <= INITIAL_STATE;
  endcase
  
 // ---------------------- Output  Function ----------------------
 assign                                     update_episode_enable          = state_value[0];
 
 assign                                     w_g_register_enable            = state_value[6] | state_value[7] | state_value[12] | state_value[13];
 assign                                     w_reward_register_enable       = state_value[3];
 assign                                     w_next_location_enable         = state_value[0] | state_value[3];
 assign                                     w_max_register_enable          = state_value[5] | state_value[11];
 assign                                     w_qvalue_enable                = state_value[1] | state_value[4] | state_value[10];
 assign                                     w_step_count_enable            = (state_value[0] | state_value[2]) & !count_en;//(state_value[0] | state_value[2]) & !completed;
 assign                                     w_action_register_enable       = state_value[2];
 assign                                     w_curent_location_enable       = state_value[0] | state_value[8] | state_value[15] | (state_value[1] & completed);
 assign                                     w_temp_next_location_enable    = (state_value[4] & completed) | state_value[7] | state_value[0];
 assign                                     w_qtable_en                    = state_value[8] | state_value[14]  | state_value[15];

 assign                                     w_epsilon_register_enable      = state_value[2];
 assign                                     w_epsilon_threshhold_enable    = state_value[4] & !completed;
 assign                                     w_history_table_enable         = state_value[14]| state_value[15]| state_value[0];
 assign                                     w_history_table_enable_2       = state_value[9] | state_value[0];
 assign                                     remember_mode                  = state_value[9] | state_value[10]| state_value[13] | state_value[14];
 assign                                     naddr_enviroment_register_en   = state_value[3];
 assign                                     tx_dv                          = state_value[16]| state_value[17]|state_value[18];
 assign                                     tx_sel                         = state_value[17]|state_value[18];
 assign                                     tx_data                        = (state_value[17]) ? 8'hD : 8'hA; 
 
 always @ (current_state)
  case (current_state)
   INITIAL_STATE:   begin
	 w_step_count_select            <= 1'b0;
    w_curent_location_select       <= 1'b0;
    equal_select                   <= 1'b0;
	 w_g_register_select            <= 1'b0;
   end
	STATE_1      :    begin
    w_curent_location_select       <= 1'b1;
	 w_step_count_select            <= 1'bx;
    equal_select                   <= 1'b1;
	 w_g_register_select            <= 1'b0;
   end
	STATE_2      :    begin
    w_curent_location_select       <= 1'b1;
	 w_step_count_select            <= 1'b1;
    equal_select                   <= 1'b1;
	 w_g_register_select            <= 1'b0;
   end
	STATE_3      :    begin
    w_curent_location_select       <= 1'b1;
	 w_step_count_select            <= 1'bx;
    equal_select                   <= 1'b0;
	 w_g_register_select            <= 1'b0;
   end
	STATE_4      :    begin
    w_curent_location_select       <= 1'b1;
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
    equal_select                   <= 1'b1;
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
    equal_select                   <= 1'b1;
	 w_g_register_select            <= 1'b1;
   end
	STATE_14     :    begin
    w_curent_location_select       <= 1'b1;
	 w_step_count_select            <= 1'bx;
    equal_select                   <= 1'b0;
	 w_g_register_select            <= 1'b1;
   end
	
	default : begin
    w_curent_location_select       <= 1'b1;
	 w_step_count_select            <= 1'b1;
    equal_select                   <= 1'b1;
	 w_g_register_select            <= 1'b0;
	end
  endcase
  
/* -----------------------------------------------------------------------------------------------------------------
*
*                                                   Initial
*
----------------------------------------------------------------------------------------------------------------- */
/*
integer episode_count = 0;
integer step_count    = 0;

initial begin
  $timeformat (-9, 2, " ns");
 forever @ (done_signal)
  if (done_signal)  $display("At time %0t - episode %0d - step %0d: DONE !!!", $time, episode_count, step_count);
end // initial

initial 
 forever @ (posedge clk) begin
  if       (state_value[0]) begin
   episode_count = episode_count + 1;
	 step_count    = 0;
  end // if       (state_value[0])
  else if  (state_value[1]) begin
	 step_count    = step_count    + 1;
  end // if  (state_value[1])
 end // forever
*/
 endmodule 
 
