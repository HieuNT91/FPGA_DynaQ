module is_equal_1023
#(
 parameter    REWARD_LENGTH = 10,
 parameter    STEP_LENGTH   = 5
)
(
 input  wire [REWARD_LENGTH - 1 : 0] reward,
 input  wire [STEP_LENGTH   - 1 : 0] step_count,
 input  wire                         select,
 
 output wire                         equal_signal
);
 wire                              reward_equal; 
 wire                              step_count_equal;
 
 assign                            reward_equal     = &reward;
 assign                            step_count_equal = (step_count == {{(STEP_LENGTH - 5){1'b0}}, 5'd25}); 
 assign                            equal_signal     = (select) ? step_count_equal : reward_equal;
endmodule 