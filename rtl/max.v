module max
#(
 parameter    DATA_LENGTH      = 32,
 parameter    KQFACTOR_LENGTH  = 16
)
(
 
 input  wire signed [DATA_LENGTH - 1 : 0] qvalue_0,
 input  wire signed [DATA_LENGTH - 1 : 0] qvalue_1,
 input  wire signed [DATA_LENGTH - 1 : 0] qvalue_2,
 input  wire signed [DATA_LENGTH - 1 : 0] qvalue_3,

 output reg   [DATA_LENGTH - 1 : 0] value,
 output wire  [1               : 0] arg
);

 wire        [3               : 0] max;

 assign                            max[0]       = (qvalue_0 >= qvalue_1) 
                                                & (qvalue_0 >= qvalue_2) 
                                                & (qvalue_0 >= qvalue_3);          //~(compare_0[0][31] & compare_0[1][31] & compare_0[2][31]);
 
 assign                            max[1]       = (qvalue_1 >= qvalue_2)
                                                & (qvalue_1 >= qvalue_3)
                                                & (qvalue_1 >= qvalue_0) & !max[0];//~(compare_1[0][31] & compare_1[1][31] & compare_1[2][31]);
 
 assign                            max[2]       = (qvalue_2 >= qvalue_3)
                                                & (qvalue_2 >= qvalue_0)
                                                & (qvalue_2 >= qvalue_1) & !max[1];//~(compare_2[0][31] & compare_2[1][31] & compare_2[2][31]);
 
 assign                            max[3]       = (qvalue_3 >= qvalue_0)
                                                & (qvalue_3 >= qvalue_1)
                                                & (qvalue_3 >= qvalue_2) & !max[2];//~(compare_3[0][31] & compare_3[1][31] & compare_3[2][31]);
/* Encoder
 x x x 1 | 00
 x x 1 0 | 01
 x 1 0 0 | 10
 1 0 0 0 | 11
*/
 //assign                            arg[0]       = (max[1] & !max[0])           | (max[3] & !max[0] & !max[1] & !max[2]);
 //assign                            arg[1]       = (max[2] & !max[0] & !max[1]) | (max[3] & !max[0] & !max[1] & !max[2]);                      
 assign                            arg[0]       = max[1] | max[3];
 assign                            arg[1]       = max[2] | max[3];                      
 
 
 always @ (*)
  case (arg)
   2'b00 : value = qvalue_0;
	2'b01 : value = qvalue_1;
	2'b10 : value = qvalue_2;
	2'b11 : value = qvalue_3;
  endcase
  
endmodule 