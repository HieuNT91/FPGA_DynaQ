module dynaQ_demon_toplevel
#(
 parameter         LOCATION_LENGTH        = 5,
 parameter         STEP_LENGTH            = 5,
 parameter         EPSILON_LENGTH         = 7,
 parameter         DATA_LENGTH            = 16,
 parameter         REWARD_LENGTH          = 2,
 parameter         MAP_SIZE               = 25
)
(
 // ------------------------- Global ------------------------- 
 input  wire                              clk,
 input  wire                              reset,
 input  wire                              start,
 input  wire                              next,
 input  wire                              tx_done,
 // ------------------------- Input -------------------------
 input  wire [LOCATION_LENGTH - 1 : 0]    start_location,
 
 // ------------------------- Output -------------------------
 output wire                              tx_dv,
 output wire  [4                : 0]      current_state,
 output wire                              completed,
 output wire [STEP_LENGTH     - 1 : 0]    step_count_data,
 output wire [1                   : 0]    show_action,
 output wire [7                   : 0]    o_current_location
 );
/************************************************************************************************************************
*
*                                         CONNECTION DECLARATION
*
*************************************************************************************************************************/
 wire        [DATA_LENGTH     - 1 : 0]    read_qvalue_0;
 wire        [DATA_LENGTH     - 1 : 0]    read_qvalue_1;
 wire        [DATA_LENGTH     - 1 : 0]    read_qvalue_2;
 wire        [DATA_LENGTH     - 1 : 0]    read_qvalue_3;
 wire        [LOCATION_LENGTH - 1 : 0]    next_location;
 wire        [7                   : 0]    next_location_data;
 wire        [7                   : 0]    read_qtable_addr;
 wire        [DATA_LENGTH     - 1 : 0]    w_qtable_data;
 wire                                     w_qtable_en;
 wire        [REWARD_LENGTH   - 1 : 0]    reward;
 wire        [1                   : 0]    action;
 wire        [LOCATION_LENGTH - 1 : 0]    current_location;
 wire        [STEP_LENGTH     - 1 : 0]    t_step_count_data;

 assign                                   show_action        = action & {2{completed}};
 assign                                   o_current_location = next_location_data;
 assign                                   step_count_data    = t_step_count_data;
 assign                                   read_qtable_addr   = next_location_data - 8'd48;

/************************************************************************************************************************
*
*                                         MODULE DECLARATION
*
*************************************************************************************************************************/

// ----------------------------------------------------------------------------------------------------------------------
//--------------------------------------- Enviroment --------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------
enviroment_5x5
#(
 .LOCATION_LENGTH                         (LOCATION_LENGTH),
 .REWARD_LENGTH                           (REWARD_LENGTH),
 .MAP_SIZE                                (MAP_SIZE)
)enviroment(
 .clk                                     (clk),
 .reset                                   (reset),
 .current_location                        (current_location),
 .action                                  (action),             // {0 - LEFT, 1 - UP, 2 - RIGHT, 3 - DOWN}
 .w_address                               (),
 .w_data                                  (),
 // Output
 .reward                                  (reward),
 .next_location                           (next_location)
);

// ----------------------------------------------------------------------------------------------------------------------
//--------------------------------------- Training ----------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------
dynaQ_training 
#(
.LOCATION_LENGTH                          (LOCATION_LENGTH),
.DATA_LENGTH                              (DATA_LENGTH),
.EPSILON_LENGTH                           (EPSILON_LENGTH),
.STEP_LENGTH                              (STEP_LENGTH),
.REWARD_LENGTH                            (DATA_LENGTH)
)training(
 // ------------------------- Global ------------------------- 
 .clk                                     (clk),
 .reset                                   (reset),
 // ------------------------- Input -------------------------
 .start                                   (start),
 .next                                    (next),
 .start_location                          (start_location),
 .next_location                           (next_location),
 .read_qvalue_0                           (read_qvalue_0),
 .read_qvalue_1                           (read_qvalue_1),
 .read_qvalue_2                           (read_qvalue_2),
 .read_qvalue_3                           (read_qvalue_3),
 //.gamma                                   (gamma),
 .reward                                  ({reward[REWARD_LENGTH - 1], {(DATA_LENGTH - REWARD_LENGTH){reward[1] ^ reward[0]}}, reward[0]}),
 .tx_done                                 (tx_done),
 // ------------------------- Output -------------------------
 .tx_dv                                   (tx_dv),
 .current_state                           (current_state),
 .current_location                        (current_location),
 .step_count_data                         (t_step_count_data),
 .o_next_location_data                    (next_location_data),
 .w_qtable_data                           (w_qtable_data),
 .w_qtable_en                             (w_qtable_en),
 .completed                               (completed),
 .action                                  (action)
);

// ----------------------------------------------------------------------------------------------------------------------
//--------------------------------------- Q-Table ----------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------
q_table
#(
.ACCESS_LENGTH                            (LOCATION_LENGTH),
.DATA_LENGTH                              (DATA_LENGTH)
)q_table(
 .clk                                     (clk),
 .reset                                   (reset),
 .w_en                                    (w_qtable_en),
 .w_data                                  (w_qtable_data),
 .action                                  (action),
 .w_address                               (current_location), //current_location
 .r_address                               (read_qtable_addr[LOCATION_LENGTH - 1 : 0]),
 // Output
 .r_data                                  ({read_qvalue_3, read_qvalue_2, read_qvalue_1, read_qvalue_0})
);

// --------------------------------------------------------------------------------------------------------------------
//--------------------------------------- Datapath --------------------------------------------------------------------
// --------------------------------------------------------------------------------------------------------------------
/*
initial
 forever @ (q_table.r_q_block)
  //$display("At time : %0t - Current state: %0d", $time, training.current_state);  
  //if (training.current_state == 4'd1) 
  $display("At time : %0t - Current state: %0d", $time, training.current_state);
*/
endmodule 