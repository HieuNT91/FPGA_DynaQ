module dynaQ_training_datapath
#(
 parameter         LOCATION_LENGTH      = 6,
 parameter         REWARD_LENGTH        = 11,
 parameter         STEP_LENGTH          = 10,
 parameter         KQFACTOR_LENGTH      = 16,
 parameter         EPSILON_LENGTH       = 17,
 parameter         ACTION_DE_LENGTH     = 12,
 parameter         DATA_LENGTH          = 64
)
(
 // ------------------------- Global ------------------------- 
 input  wire                              clk,
 input  wire                              reset,
 // ------------------------- Write-En -----------------------\
 input  wire                              w_history_table_enable,
 input  wire                              w_history_table_enable_2,
 input  wire                              update_episode_enable,
 input  wire                              w_g_register_enable,
 input  wire                              w_max_register_enable,
 input  wire                              w_reward_register_enable,
 input  wire                              w_qvalue_enable,
 input  wire                              w_step_count_enable,
 input  wire                              w_action_register_enable,
 input  wire                              w_curent_location_enable,
 input  wire                              w_next_location_enable,
 input  wire                              w_temp_next_location_enable,
 input  wire                              w_epsilon_register_enable,
 input  wire                              w_epsilon_threshhold_enable,
 input  wire                              remember_mode,
 input  wire                              naddr_enviroment_register_en,
 // ------------------------- Write-Select -----------------------
 input  wire                              w_curent_location_select,
 input  wire                              w_g_register_select,
 input  wire                              w_step_count_select,
 input  wire                              equal_select,
 // -------------------------- Data -------------------------
 input  wire [LOCATION_LENGTH - 1 : 0]    start_location,
 input  wire [LOCATION_LENGTH - 1 : 0]    next_location,
 input  wire [DATA_LENGTH     - 1 : 0]    read_qvalue_0,
 input  wire [DATA_LENGTH     - 1 : 0]    read_qvalue_1,
 input  wire [DATA_LENGTH     - 1 : 0]    read_qvalue_2,
 input  wire [DATA_LENGTH     - 1 : 0]    read_qvalue_3,
 //input  wire [DATA_LENGTH     - 1 : 0]    gamma,
 input  wire [REWARD_LENGTH   - 1 : 0]    reward,
 
 // ------------------------ Output ---------------------------
 output wire [LOCATION_LENGTH - 1 : 0]    o_current_location,
 output wire [LOCATION_LENGTH - 1 : 0]    o_next_location,
 output wire [STEP_LENGTH     - 1 : 0]    step_count_data,
 output wire [DATA_LENGTH     - 1 : 0]    w_qtable_data,
 output wire [1                   : 0]    o_action,            // action space is (0,1,2,3) - (...)
 output reg                               completed,
 output wire                              remember_en,
 output wire                              done
);
/************************************************************************************************************************
*
*                                         CONNECTION DECLARATION
*
*************************************************************************************************************************/
// ----------------------------------------------- FU Connection --------------------------------------------------
wire        [DATA_LENGTH      - 1 : 0]   multiplication_result;
wire        [DATA_LENGTH      - 1 : 0]   add_sub_result;
wire        [DATA_LENGTH      - 1 : 0]   max_result;
wire        [1                    : 0]   action_result;
wire        [1                    : 0]   action_of_max;
wire        [ACTION_DE_LENGTH - 1 : 0]   random_action_decision;

// ------------------------------------------- Register Connection --------------------------------------------------
wire        [DATA_LENGTH      - 1 : 0]   a_data;
wire        [DATA_LENGTH      - 1 : 0]   b_data;
wire        [DATA_LENGTH      - 1 : 0]   g_data;
wire        [DATA_LENGTH      - 1 : 0]   max_data;
wire        [REWARD_LENGTH    - 1 : 0]   reward_data;
wire        [REWARD_LENGTH    - 1 : 0]   true_reward_data;
wire        [DATA_LENGTH      - 1 : 0]   qvalue_action_data;
wire        [DATA_LENGTH      - 1 : 0]   total_reward_data;
wire        [DATA_LENGTH      - 1 : 0]   qvalue_data_0;
wire        [DATA_LENGTH      - 1 : 0]   qvalue_data_1;
wire        [DATA_LENGTH      - 1 : 0]   qvalue_data_2;
wire        [DATA_LENGTH      - 1 : 0]   qvalue_data_3;
wire        [EPSILON_LENGTH   - 1 : 0]   random_epsilon;
wire        [EPSILON_LENGTH   - 1 : 0]   pre_epsilon;
wire        [EPSILON_LENGTH   - 1 : 0]   epsilon_data;
wire        [ACTION_DE_LENGTH - 1 : 0]   pre_random_action_decision;

wire        [DATA_LENGTH      - 1 : 0]   alpha_data;
wire        [DATA_LENGTH      - 1 : 0]   gamma_data;
wire                                     overflow;
wire        [STEP_LENGTH      - 1 : 0]   random_step;
wire        [LOCATION_LENGTH  - 1 : 0]   temp_next_location_data;

wire        [LOCATION_LENGTH - 1 : 0]    current_location;
wire        [LOCATION_LENGTH - 1 : 0]    next_location_data;
wire        [1                   : 0]    action;
wire        [1                    : 0]   read_h_action;
wire        [LOCATION_LENGTH  - 1 : 0]   read_h_location;
wire        [LOCATION_LENGTH  - 1 : 0]   read_h_nlocation;
wire        [REWARD_LENGTH    - 1 : 0]   read_h_reward;
wire        [1                    : 0]   remember_action;
wire        [LOCATION_LENGTH  - 1 : 0]   remember_location;

wire        [1                    : 0]   random_action;

assign                                   w_qtable_data        =  g_data;


always @ (posedge clk or negedge reset)
 if (!reset)                       completed = 1'b0;
 else if (!(|epsilon_data) & done & update_episode_enable) completed = 1'b1;

assign o_next_location     = (remember_mode) ? read_h_nlocation : next_location_data;
assign o_current_location  = (remember_mode) ? read_h_location  : current_location;
assign o_action            = (remember_mode) ? read_h_action    : action;
assign true_reward_data    = (remember_mode) ? read_h_reward    : reward_data;
assign remember_en         = max_data > 0;

/************************************************************************************************************************
*
*                                              REGISTER-PART
*
*************************************************************************************************************************/
// ------------------------------------------------- history table ----------------------------------------------------------
history_table_v2 #(
 .LOCATION_LENGTH                         (LOCATION_LENGTH  ),
 .STEP_LENGTH                             (STEP_LENGTH      ),
 .REWARD_LENGTH                           (REWARD_LENGTH    )
)history_table (
 .clk                                     (clk              ),
 .reset                                   (reset            ),
 .w_en                                    (w_history_table_enable),
 .w_en_2                                  (w_history_table_enable_2),
 .n_location                              (next_location_data),
 .current_location                        ((!update_episode_enable) ? current_location : {LOCATION_LENGTH{1'b0}}),
 .action                                  ((!update_episode_enable) ? action : 2'b0),
 .next_location                           ((!update_episode_enable) ? next_location : {LOCATION_LENGTH{1'b0}}),
 .reward                                  (reward),
 
 .remember_action                         (read_h_action    ),
 .remember_location                       (read_h_location  ),
 .remember_n_location                     (read_h_nlocation),
 .remember_reward                         (read_h_reward)
);
// ------------------------------------------------ max register ----------------------------------------------------------
register_reset #(
 .DATA_LENGTH                             (DATA_LENGTH)
)
max_register // name
(
 .clk                                     (clk),
 .reset                                   (reset),
 .enable                                  (w_max_register_enable),
 .w_data                                  (max_result),
 .r_data                                  (max_data)
);

// ------------------------------------------------- b register ----------------------------------------------------------
current_location #(
 .DATA_LENGTH                             (DATA_LENGTH)
)
g_register // name
(
 .clk                                     (clk),
 .reset                                   (reset),
 .enable                                  (w_g_register_enable),
 .start_location                          (multiplication_result),
 .next_location                           (add_sub_result),
 .select                                  (w_g_register_select),
 // Output
 .out_data                                (g_data)
);

// ------------------------------------------------ reward register ----------------------------------------------------------
register_reset #(
 .DATA_LENGTH                             (REWARD_LENGTH)
)
reward_register // name
(
 .clk                                     (clk),
 .reset                                   (reset),
 .enable                                  (w_reward_register_enable),
 .w_data                                  (reward),
 .r_data                                  (reward_data)
);

// ------------------------------------------- step count register ----------------------------------------------------------

current_location #(
 .DATA_LENGTH                             (STEP_LENGTH)
)
step_count_register // name
(
 .clk                                     (clk),
 .reset                                   (reset),
 .enable                                  (w_step_count_enable),
 .start_location                          ({STEP_LENGTH{1'b0}}),
 .next_location                           (step_count_data + {{(STEP_LENGTH - 1){1'b0}}, 1'b1}),
 .select                                  (w_step_count_select),

 // Output
 .out_data                                (step_count_data)
);

// ------------------------------------------- q value register ----------------------------------------------------------
register_reset #(
 .DATA_LENGTH                             (DATA_LENGTH)
)
qvalue_register [3 : 0]  // name
(
 .clk                                     (clk),
 .reset                                   (reset),
 .enable                                  (w_qvalue_enable),
 .w_data                                  ({read_qvalue_3, read_qvalue_2, read_qvalue_1, read_qvalue_0}),
 .r_data                                  ({qvalue_data_3, qvalue_data_2, qvalue_data_1, qvalue_data_0})
);

// ------------------------------------------- random epsilon register ----------------------------------------------------------
register_reset #(
 .DATA_LENGTH                             (EPSILON_LENGTH)
)
random_epsilon_register // name
(
 .clk                                     (clk),
 .reset                                   (reset),
 .enable                                  (w_epsilon_register_enable),
 .w_data                                  (random_epsilon),
 .r_data                                  (pre_epsilon)
);

// ------------------------------------------- epsilon register ----------------------------------------------------------
register_reset #(
 .DATA_LENGTH                             (EPSILON_LENGTH),
 .RESET_VALUE                             (7'd120)
 //.RESET_VALUE                             (7'd5)

)
epsilon_register // name
(
 .clk                                     (clk),
 .reset                                   (reset),
 .enable                                  ((&reward_data[REWARD_LENGTH - 2 : 0]) & w_epsilon_threshhold_enable),
 .w_data                                  (epsilon_data - 7'd10),
 //.w_data                                  (7'd5),
 // Output
 .r_data                                  (epsilon_data)
);



// ------------------------------------------- action register ----------------------------------------------------------
register_reset #(
 .DATA_LENGTH                             (2)
)
action_register // name
(
 .clk                                     (clk),
 .reset                                   (reset),
 .enable                                  (w_action_register_enable),
 //.w_data                                  ((w_remember_register_enable) ? random_action : action_result[1:0]),
 .w_data                                  (action_result[1:0]),
 .r_data                                  (action)
);

// --------------------------------------- action decision register ----------------------------------------------------------
register_reset #(
 .DATA_LENGTH                             (ACTION_DE_LENGTH)
)
action_deicion_register // name
(
 .clk                                     (clk),
 .reset                                   (reset),
 //.enable                                  (w_action_register_enable),
 .enable                                  (w_epsilon_register_enable),
 .w_data                                  (random_action_decision),
 .r_data                                  (pre_random_action_decision)
);

// -------------------------------------- current location register ----------------------------------------------------------
current_location #(
 .DATA_LENGTH                             (LOCATION_LENGTH)
)
current_location_register // name
(
 .clk                                     (clk),
 .reset                                   (reset),
 .enable                                  (w_curent_location_enable),
 .start_location                          (start_location),
 .next_location                           (next_location_data),
 .select                                  (w_curent_location_select),
 // Output
 .out_data                                (current_location)
);
// -------------------------------------- next location register ----------------------------------------------------------
current_location #(
 .DATA_LENGTH                             (LOCATION_LENGTH)
)
next_location_register // name
(
 .clk                                     (clk),
 .reset                                   (reset),
 .enable                                  (w_next_location_enable),
 .start_location                          (start_location),
 .next_location                           (next_location),
 .select                                  (w_curent_location_select),
 
 .out_data                                (next_location_data)
);
// -------------------------------------- temp next location register ----------------------------------------------------------
current_location #(
 .DATA_LENGTH                             (LOCATION_LENGTH)
)
temp_next_location_register // name
(
 .clk                                     (clk),
 .reset                                   (reset),
 .enable                                  (w_temp_next_location_enable),
 .start_location                          (start_location),
 .next_location                           (next_location_data),
 .select                                  (w_curent_location_select),
 
 .out_data                                (temp_next_location_data)
);
// 
/************************************************************************************************************************
*
*                                            FUNTIONAL UNIT-PART
*
*************************************************************************************************************************/

// -------------------------------------------- multiplication ----------------------------------------------------------
multiplication #(
 .DATA_LENGTH                            (DATA_LENGTH),
 .K_QFACTOR                              (KQFACTOR_LENGTH)
)
multiplication (
 .operand_1                              (max_data),
 .operand_2                              (),
 //.operand_2                              ({16'b0, 16'b1101100110011001}),
 
 .result                                 (multiplication_result)
);

// ----------------------------------------------- add sub ----------------------------------------------------------
adder_subtractor #(
 .DATA_LENGTH                            (DATA_LENGTH),
 .K_QFACTOR                              (KQFACTOR_LENGTH)
)
adder_subtractor (
 .operand_1                              ({{(DATA_LENGTH - REWARD_LENGTH){true_reward_data[REWARD_LENGTH - 1]}},true_reward_data}),
 .operand_2                              (g_data),
 //.operand_2                              ((next_location_data == current_location) ? {DATA_LENGTH{1'b0}} :  g_data),
 
 .overflow                               (overflow),
 .result                                 (add_sub_result)
);

// ----------------------------------------------- max ----------------------------------------------------------
max
#(
 .DATA_LENGTH                             (DATA_LENGTH),
 .KQFACTOR_LENGTH                         (KQFACTOR_LENGTH)
)
max
(
 .qvalue_0                               (qvalue_data_0),
 .qvalue_1                               (qvalue_data_1),
 .qvalue_2                               (qvalue_data_2),
 .qvalue_3                               (qvalue_data_3),
 // Output
 .value                                  (max_result),
 .arg                                    (action_of_max)
);

// ----------------------------------------------- equal ----------------------------------------------------------
is_equal_1023
#(
 .REWARD_LENGTH                          (REWARD_LENGTH),
 .STEP_LENGTH                            (STEP_LENGTH)
)
equal_1023
(
 .reward                                 ({1'b1, reward_data[REWARD_LENGTH - 2 : 0]}),
 .step_count                             (step_count_data + {{(STEP_LENGTH - 1){1'b0}}, 1'b1}),
 //.step_count                             (step_count_data),
 .select                                 (equal_select),
 
 .equal_signal                           (done)
);

random_calculation                      #(
.EPSILON_LENGTH                          (EPSILON_LENGTH)
)
random_calculation(
 .action_of_max                         (action_of_max),
 .epsilon_data                          (epsilon_data),
 .pre_random_action_decision            (pre_random_action_decision),
 .pre_epsilon                           (pre_epsilon),
 // Output
 .action                                (action_result),
 .random_action                         (random_action),
 .random_action_decision                (random_action_decision),
 .random_epsilon                        (random_epsilon)
);

/* -----------------------------------------------------------------------------------------------------------------
*
*                                                   Initial
*
----------------------------------------------------------------------------------------------------------------- */
// REAL test
/*
initial begin
 forever @ (epsilon_data)
 //if (overflow & w_b_register_select) 
 //  $display("At episode %0d - step %0d - epsilon %0d : OVERFLOW !!!", episode_data, step_count_data, epsilon_data);
  $display("Epsilon %0d : DONE !!!", epsilon_data);
end
*/
/*
initial begin
 $timeformat (-9, 2, " ns");
  
 forever @ (reward_data)begin
 //if (overflow & w_b_register_select) 
 //  $display("At episode %0d - step %0d - epsilon %0d : OVERFLOW !!!", episode_data, step_count_data, epsilon_data);
 if (reward_data == {1'b0, {(REWARD_LENGTH - 1){1'b1}}})
  $display("At time %0t - step %0d - epsilon %0d : DONE !!!", $time, step_count_data, epsilon_data);
 if (step_count_data == {STEP_LENGTH{1'b1}} &&  epsilon_data == 0)
  $display("At time %0t - step %0d : NOT DONE !!!", $time, step_count_data);
 end
end
*/
endmodule 
