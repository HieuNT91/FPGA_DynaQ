module random_generator 
#(
 parameter         DATA_LENGTH            = 32
)
(
 input  wire [DATA_LENGTH - 1 : 0]         a,
 input  wire [DATA_LENGTH - 1 : 0]         pre_s,
 input  wire [DATA_LENGTH - 1 : 0]         m,
 input  wire [DATA_LENGTH - 1 : 0]         c,
 
 output wire [DATA_LENGTH - 1 : 0]         s
);
wire         [DATA_LENGTH - 1 : 0]         temp_s;

//assign                                     temp_s = (a ^ ((a << pre_s[DATA_LENGTH - 1 : DATA_LENGTH - 3]) + c));
assign                                     s      = {pre_s[DATA_LENGTH - 2 : 0], !(^pre_s[DATA_LENGTH - 1 : DATA_LENGTH/2])};   
//assign                                    s = (a * pre_s + c) % m;

endmodule 