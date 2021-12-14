module adder_subtractor
#(
 parameter    DATA_LENGTH = 32,
 parameter    K_QFACTOR   = 16
)
(
 input  wire [DATA_LENGTH - 1 : 0] operand_1,
 input  wire [DATA_LENGTH - 1 : 0] operand_2,
 
 output wire                       overflow,
 output wire [DATA_LENGTH - 1 : 0] result
);
 
 assign {overflow,result} = (operand_1 == 16'hfffe) ? operand_1 : operand_1 + operand_2;

endmodule 