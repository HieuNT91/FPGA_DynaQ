module multiplication 
#(
 parameter    DATA_LENGTH = 32,
 parameter    K_QFACTOR   = 16
)
(
 input  wire [DATA_LENGTH - 1 : 0] operand_1,
 input  wire [DATA_LENGTH - 1 : 0] operand_2,
 
 output wire [DATA_LENGTH - 1 : 0] result
);
 wire        [DATA_LENGTH*2 - 1 : 0] temp_result;
 
//assign                             temp_result = ({{DATA_LENGTH{operand_1[DATA_LENGTH - 1]}}, operand_1} * {{DATA_LENGTH{operand_2[DATA_LENGTH - 1]}}, operand_2}) >>> K_QFACTOR;
//assign                            result        = temp_result[DATA_LENGTH - 1  : 0];
assign                                  result   = operand_1 >> 1'b1; 
//assign                                  result   = operand_1 * operand_2; 
//assign                                  result   = operand_1;
endmodule