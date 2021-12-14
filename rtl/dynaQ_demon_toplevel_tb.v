`timescale 100ps/100ps
module dynaQ_demon_toplevel_tb
#(
 parameter         LOCATION_LENGTH        = 5,
 parameter         STEP_LENGTH            = 5,
 parameter         EPSILON_LENGTH         = 7,
 parameter         DATA_LENGTH            = 16,
 parameter         REWARD_LENGTH          = 2,
 parameter         MAP_SIZE               = 25,
 parameter         STATE_LENGTH           = 5
)();
 // ------------------------- Global ------------------------- 
 reg                                      clk;
 reg                                      reset;
 reg                                      start;
 reg                                      next;
 reg                                      tx_done;
 // ------------------------- Input -------------------------
 reg         [LOCATION_LENGTH - 1 : 0]    start_location;
 reg         [DATA_LENGTH     - 1 : 0]    gamma;
 
 wire                                     completed;
 wire        [STATE_LENGTH    - 1 : 0]    current_state;
 wire        [8     - 1 : 0]    current_location;
 wire        [STEP_LENGTH     - 1 : 0]    step_count;
 
 dynaQ_demon_toplevel 
#(
 .LOCATION_LENGTH                         (LOCATION_LENGTH),
 .DATA_LENGTH                             (DATA_LENGTH),
 .STEP_LENGTH                             (STEP_LENGTH),
 .EPSILON_LENGTH                          (EPSILON_LENGTH),
 .REWARD_LENGTH                           (REWARD_LENGTH),
 .MAP_SIZE                                (MAP_SIZE)
)
demon_toplevel
(
 // ------------------------- Global ------------------------- 
 .clk                                     (clk),
 .reset                                   (reset),
 .start                                   (start),
 .next                                    (next),
 .tx_done                                 (tx_done),
 // ------------------------- Input -------------------------
 .o_current_location                      (current_location),
 .current_state                           (current_state),
 .tx_dv                                   (),
 .start_location                          (5'd0),                        //1.0011001100110011
 .completed                               (completed),
 .step_count_data                         (step_count),
 .show_action                             ()
 );
 initial begin 
  clk = 1'b0;
  forever #1 clk = !clk;
 end 
 
 initial begin
  tx_done = 1'b1;
  reset = 1'b0;
  start = 1'b0;
  next  = 1'b0;
  #0.5;
  reset = 1'b1;
 end
 
 initial begin
   #10;
   start = 1'b1;
   #5;
   start = 1'b0;
 end // initial 
 
 always @ (posedge clk) begin
   #0.5;
	 if (completed) next = 1'b1;
	end // always
	
  always @(posedge clk) begin
	#0.1;
	get_value();
	end
reg [2*10 : 0]i;
integer f;



initial begin 
i = 0;
f = $fopen("output.txt","w");
end

task get_value; begin
 if(current_state == 19 && completed == 1 && next == 1) begin
	$fwrite(f,"\t%0d",step_count);
	$display("\nStep count: %0d",step_count);
	$display("GET VALUE PROCESS IS DONE");
	$fclose(f);
	$stop;
 end
 if(completed == 1 && current_state == 16) begin //Sim is done -> Start to print 
	if (i==0) begin 
	$fwrite(f,"%0d",current_location-48);
	$write("Way: %0d",current_location-48);
	end
	else begin
	$fwrite(f,"_%0d",current_location-48);
	$write("_%0d",current_location-48);
	end
	i=i+1;
	
	end
end
endtask	
endmodule 
	
