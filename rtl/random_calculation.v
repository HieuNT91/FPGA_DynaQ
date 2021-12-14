module random_calculation 
#(
 parameter         EPSILON_LENGTH             = 17,
 parameter         ACTION_LENGTH              = 12
)
(
 input  wire [EPSILON_LENGTH - 1 : 0]         pre_epsilon,
 input  wire [EPSILON_LENGTH - 1 : 0]         epsilon_data,
 input  wire [ACTION_LENGTH  - 1 : 0]         pre_random_action_decision,
 input  wire [1                  : 0]         action_of_max,
 // Output
 output wire [1                  : 0]         action,
 output wire [1                  : 0]         random_action,
 output wire [ACTION_LENGTH  - 1 : 0]         random_action_decision,
 output wire [EPSILON_LENGTH - 1 : 0]         random_epsilon
);
 wire                                         lt;

random_generator 
#(
 .DATA_LENGTH                              (ACTION_LENGTH)
)random_generator_action(
 .a                                        (12'd2519),
 .pre_s                                    (pre_random_action_decision),
 .m                                        (12'd4000),
 .c                                        (12'd1529),
 
 .s                                        (random_action_decision)
);

random_generator 
#(
 .DATA_LENGTH                              (EPSILON_LENGTH)
)random_generator_epsilon(
 .a                                        (pre_epsilon ^ 7'd85),
 //.a                                        (17'd18385),
 //.a                                        (epsilon_data),
 //.a                                        ({5'b0, random_action_decision}),
 .pre_s                                    (pre_epsilon),
 .m                                        (7'd127),
 //.c                                        ({random_action_decision[EPSILON_LENGTH - ACTION_LENGTH - 1 : 0], random_action_decision} & 17'd3930),
 .c                                        (7'd29),
 //.c                                        (17'd11529), 
 .s                                        (random_epsilon)
);
/*
compare_unsigned_no_clock                  
#(
 .DATA_WIDTH                               (EPSILON_LENGTH)
)
compare_unsigned_no_clock(
 .i_data_1                                 (random_epsilon),
 .i_data_2                                 (epsilon_data),
 .lt                                       (lt),
 .gt                                       ()
);
*/

assign random_action   = (random_action_decision <= 12'd1000) ? 2'd0 :
                         (random_action_decision <= 12'd2000) ? 2'd1 :
                         (random_action_decision <= 12'd3000) ? 2'd2 :
                         (random_action_decision <= 12'd4000) ? 2'd3 : 2'd0;
                         
assign action          = (random_epsilon < epsilon_data) ? random_action[1:0] : action_of_max;
//assign action          = (random_epsilon < 17'd010000) ? random_action[1:0] : action_of_max;

endmodule 