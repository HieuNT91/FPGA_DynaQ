module enviroment_map 
#(
 parameter         LOCATION_LENGTH        = 6,
 parameter         MAP_SIZE               = 25,
 parameter         MAP_DATA_FILE          = "C:/Users/Hoang Thien/OneDrive/LSIDesign_2020/Q_and_DynaQ/map_data/map_data_file_5x5_2.txt"
)
(
input  wire                              clk,
input  wire                              reset,

input  wire [LOCATION_LENGTH - 1 : 0]    w_address,
input  wire [1                   : 0]    w_data, 

input  wire [LOCATION_LENGTH - 1 : 0]    r_address_left,
input  wire [LOCATION_LENGTH - 1 : 0]    r_address_right,
input  wire [LOCATION_LENGTH - 1 : 0]    r_address_up,
input  wire [LOCATION_LENGTH - 1 : 0]    r_address_down,

output wire [1                   : 0]    r_data_left,
output wire [1                   : 0]    r_data_right,
output wire [1                   : 0]    r_data_up,
output wire [1                   : 0]    r_data_down
);

reg         [1                   : 0]    map [MAP_SIZE - 1 : 0];

assign                                   r_data_left    = map[r_address_left];
assign                                   r_data_right   = map[r_address_right];
assign                                   r_data_up      = map[r_address_up];
assign                                   r_data_down    = map[r_address_down];

always @ (posedge clk)
 map[w_address] = w_data;
 
initial $readmemb  (MAP_DATA_FILE, map);

endmodule 