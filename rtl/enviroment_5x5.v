module enviroment_5x5
#(
 parameter         LOCATION_LENGTH        = 32,
 parameter         REWARD_LENGTH          = 11,
 parameter         DEMON_VALUE            = 50,
 parameter         MAP_SIZE               = 25
)
(
input  wire                              clk,
input  wire                              reset,
input  wire [LOCATION_LENGTH - 1 : 0]    current_location,
input  wire [1                   : 0]    action,             // {0 - LEFT, 1 - UP, 2 - RIGHT, 3 - DOWN}
input  wire [LOCATION_LENGTH - 1 : 0]    w_address,
input  wire [1                   : 0]    w_data,

output reg  [REWARD_LENGTH   - 1 : 0]    reward,
output reg  [LOCATION_LENGTH - 1 : 0]    next_location
);
wire        [LOCATION_LENGTH - 1 : 0]    temp_next_location_up;
wire        [LOCATION_LENGTH - 1 : 0]    temp_next_location_down;
wire        [LOCATION_LENGTH - 1 : 0]    temp_next_location_left;
wire        [LOCATION_LENGTH - 1 : 0]    temp_next_location_right;


assign                                   temp_next_location_up    = current_location - 5'd5;
assign                                   temp_next_location_down  = current_location + 5'd5;
assign                                   temp_next_location_left  = current_location - {{(LOCATION_LENGTH - 1){1'b0}}, 1'd1};
assign                                   temp_next_location_right = current_location + {{(LOCATION_LENGTH - 1){1'b0}}, 1'd1};


wire        [1                   : 0]    rmap_left;
wire        [1                   : 0]    rmap_right;
wire        [1                   : 0]    rmap_up;
wire        [1                   : 0]    rmap_down;

enviroment_map #(
 .LOCATION_LENGTH                        (LOCATION_LENGTH),
 .MAP_SIZE                               (MAP_SIZE)
)enviroment_map(
 .clk                                    (clk),
 .reset                                  (reset),

 .w_address                              (w_address),
 .w_data                                 (w_data), 

 .r_address_left                         (temp_next_location_left),
 .r_address_right                        (temp_next_location_right),
 .r_address_up                           (temp_next_location_up),
 .r_address_down                         (temp_next_location_down),

 .r_data_left                             (rmap_left),
 .r_data_right                            (rmap_right),
 .r_data_up                               (rmap_up),
 .r_data_down                             (rmap_down)
);


always @ (*)
 case (action)
  // ---------------- Go Left -----------------
  2'b00:
	if (
	 (current_location ==  5'd0) |
	 (current_location ==  5'd5) |
	 (current_location ==  5'd10) |
	 (current_location ==  5'd15) |
	 (current_location ==  5'd20) 
	) begin
	 reward         = -2'd2;   // WRONG WAY
	 next_location  = current_location;
	end else begin
	 case (rmap_left)
	  2'b00: begin // nothing
	   reward = 2'd0;
	   next_location = temp_next_location_left;
	  end
	  2'b01: begin // can't
	   reward = 2'd0;
	   next_location = current_location;
     end
     2'b10: begin // meet demon
      reward         = -2'd2;
      next_location = current_location;
     end
     2'b11:begin // meet treasure
      reward = {1'b0, {(REWARD_LENGTH - 1){1'b1}}};
      next_location = temp_next_location_left;
     end
   endcase
  end
 // ---------------- Go Up -----------------
  2'b01: // Go up
   if (current_location < 5'd5) begin
	 reward         = -2'd2;   // WRONG WAY
	 next_location = current_location;
	end else begin
	 case (rmap_up)
	  2'b00: begin // nothing
	   reward = 2'd0;
	   next_location = temp_next_location_up;
	  end
	  2'b01: begin // can't
	   reward = 2'd0;
	   next_location = current_location;
     end
     2'b10: begin // meet demon
      reward         = -2'd2;
      next_location = current_location;
     end
     2'b11:begin // meet treasure
      reward = {1'b0, {(REWARD_LENGTH - 1){1'b1}}};
      next_location = temp_next_location_up;
     end
   endcase
  end
  // ---------------- Go RIGHT -----------------
  2'b10:
  if (
	 (current_location ==  5'd4) |
	 (current_location ==  5'd9) |
	 (current_location ==  5'd14) |
	 (current_location ==  5'd19) |
	 (current_location ==  5'd24) 
	) begin
	 reward         = -2'd2;   // WRONG WAY
	 next_location = current_location;
	end else begin
	 case (rmap_right)
	  2'b00: begin // nothing
	   reward = 2'd0;
	   next_location = temp_next_location_right;
	  end
	  2'b01: begin // can't
	   reward = 2'd0;
	   next_location = current_location;
     end
     2'b10: begin // meet demon
      reward         = -2'd2;
      next_location = current_location;
     end
     2'b11:begin // meet treasure
      reward = {1'b0, {(REWARD_LENGTH - 1){1'b1}}};
      next_location = temp_next_location_right;
     end
   endcase
  end
  // ---------------- Go Down -----------------
  2'b11: 
  if (temp_next_location_down > 5'd24) begin
	 reward         = -2'd2;   // WRONG WAY
	 next_location = current_location;
  end else begin
	 case (rmap_down)
	  2'b00: begin // nothing
	   reward = 2'd0;
	   next_location = temp_next_location_down;
	  end
	  2'b01: begin // can't
	   reward = 2'd0;
	   next_location = current_location;
     end
     2'b10: begin // meet demon
      reward         = -2'd2;
      next_location = current_location;
     end
     2'b11:begin // meet treasure
      reward = {1'b0, {(REWARD_LENGTH - 1){1'b1}}};
      next_location = temp_next_location_down;
     end
   endcase
  end
  // ---------------- Dedault -----------------
  default: begin
	   reward = 2'd0;
		next_location = current_location;
  end
 endcase
 
	 
endmodule 