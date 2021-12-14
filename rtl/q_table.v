module q_table 
#(
 parameter         DATA_LENGTH            = 32,
 parameter         WRITE_LENGTH           = 25,
 parameter         ACCESS_LENGTH          = 8,
 parameter         WRITE_FILE             = "q_table_data.txt"
)
(
 input  wire                                 clk,
 input  wire                                 reset,
 input  wire                                 w_en,
 input  wire [DATA_LENGTH   - 1 : 0]         w_data,
 input  wire [1                 : 0]         action,
 input  wire [ACCESS_LENGTH - 1 : 0]         w_address, //current_location
 input  wire [ACCESS_LENGTH - 1 : 0]         r_address,
 
 output wire [DATA_LENGTH*4   - 1 : 0]       r_data
);
 wire        [WRITE_LENGTH  - 1 : 0]         waddr_decode_value;
 wire        [3                 : 0]         action_decode_value;
 wire        [3                 : 0]         write_select [WRITE_LENGTH - 1 : 0];
 wire        [ACCESS_LENGTH - 1 : 0]         r_addr;
 wire        [DATA_LENGTH*4 - 1 : 0]         r_q_block    [WRITE_LENGTH - 1 : 0];
 
 assign                                      r_data = r_q_block[r_address];
 assign                                      waddr_decode_value  = 1'b1 << w_address;
 assign                                      action_decode_value = w_en << action;
 
 // ------------------------ Decoder 6-64 --------------------------
 q_block #(
  .DATA_LENGTH                               (DATA_LENGTH)
 )
 q_block [WRITE_LENGTH - 1 : 0](
  .clk                                       (clk),
  .reset                                     (reset),
  .w_en                                      (waddr_decode_value),
  .action_decode                             (action_decode_value),
  .w_data                                    (w_data),
  .r_data                                    ({
  /*
  r_q_block[63],
  r_q_block[62],
  r_q_block[61],
  r_q_block[60],
  
  r_q_block[59],
  r_q_block[58],
  r_q_block[57],
  r_q_block[56],
  r_q_block[55],
  r_q_block[54],
  r_q_block[53],
  r_q_block[52],
  r_q_block[51],
  r_q_block[50],
  
  r_q_block[49],
  r_q_block[48],
  r_q_block[47],
  r_q_block[46],
  r_q_block[45],
  r_q_block[44],
  r_q_block[43],
  r_q_block[42],
  r_q_block[41],
  r_q_block[40],
  
  r_q_block[39],
  r_q_block[38],
  r_q_block[37],
  r_q_block[36],
  r_q_block[35],
  r_q_block[34],
  r_q_block[33],
  r_q_block[32],
  r_q_block[31],
  r_q_block[30],
  
  r_q_block[29],
  r_q_block[28],
  r_q_block[27],
  r_q_block[26],
  r_q_block[25],
  */
  r_q_block[24],
  r_q_block[23],
  r_q_block[22],
  r_q_block[21],
  r_q_block[20],
  
  r_q_block[19],
  r_q_block[18],
  r_q_block[17],
  r_q_block[16],
  r_q_block[15],
  r_q_block[14],
  r_q_block[13],
  r_q_block[12],
  r_q_block[11],
  r_q_block[10],
  
  r_q_block[9],
  r_q_block[8],
  r_q_block[7],
  r_q_block[6],
  r_q_block[5],
  r_q_block[4],
  r_q_block[3],
  r_q_block[2],
  r_q_block[1],
  r_q_block[0]
  })
 );
endmodule 