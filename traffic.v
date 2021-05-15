// Traffic light controller

//Delays
`define GDELAY1 55 // Green Delay for Road 1 
`define GDELAY2 15  // Green Delay for Road 2
`define YDELAY 5    // Yellow delay for both roads


module traffic(
  output reg green_1, yellow_1, red_1, green_2, yellow_2, red_2,
  input clk, reset, enable);
  
  
  // state assignment
  parameter S0 = 3'b000, // Reset state: Road1 = Red Road 2= Red    
            S1 = 3'b001, // Road1 =  Green  Road 2= Red  
            S2 = 3'b010, // Road1 =  Yellow Road 2= Red
            S3 = 3'b011, // Road1 =  Red    Road 2= Green
            S4 = 3'b100, // Road1 =  Red    Road 2= yellow
            S5 = 3'b101; // Blink state when enable  = 0

  //Internal state variables
  reg [2:0] state;
  integer count;
  reg [2:0] next_state;
  
  // Assigning state in this always Block
  
  always @(posedge clk or reset) // reset added to sensitivity list to make it asynchronous 
    begin
      if(reset == 1'b0)
        begin
          state <= S0;
        end
      else if(enable == 1'b0)       
        begin
          yellow_1 = ~yellow_1;
          yellow_2 = ~yellow_2;
          state <= S5;
        end
      else 
        state <= next_state;   
    end
  
  // Assign output in  this always Block
  
  always @(state)
    begin
      case(state)
        S0:
          begin
            {green_1, yellow_1, red_1} = 3'b001;        // Reset state: Road1: Red
            {green_2, yellow_2, red_2} = 3'b001;        // Road2: Red
          end
        S1:
          begin
            {green_1, yellow_1, red_1} = 3'b100;        // Road1: Green
            {green_2, yellow_2, red_2} = 3'b001;		// Road2: Red
          end
        S2:
          begin
            {green_1, yellow_1, red_1} = 3'b010;		// Road1: Yellow
            {green_2, yellow_2, red_2} = 3'b001;		// Road2: Red
          end
        S3:
          begin
            {green_1, yellow_1, red_1} = 3'b001; 		// Road1: Red
            {green_2, yellow_2, red_2} = 3'b100;		// Road2: Green
          end
        S4:
          begin
            {green_1, yellow_1, red_1} = 3'b001; 		// Road1: Red
            {green_2, yellow_2, red_2} = 3'b010;		// Road2: Yellow
          end   
        S5:
          begin
            {green_1,red_1} = 2'b00;
            {green_2,red_2} = 2'b00;
          end
      endcase
    end
  
  
  // Next state determination always Block
  
  always @(state or enable)
    begin
      case(state)
        S0: next_state = S1;
        S1:
            begin
              $display("state 1");
              count = 0;
              while(count < `GDELAY1 && enable == 1'b1 && reset == 1'b1)
                begin
                      @(negedge clk) count = count + 1;
                      $display("count %d",count);                
                end
        		next_state = (count == `GDELAY1)?S2:S0;
              $display("next_state is %d",next_state);
            end
        S2:
            begin
              $display("state 2");
              count = 0;
              while(count < `YDELAY && enable == 1'b1 && reset == 1'b1)
                begin
                      @(negedge clk) count = count + 1;
                      $display("count %d",count);                
                end
              next_state = (count == `YDELAY)?S3:S0;
              $display("next_state is %d",next_state);
            end
        S3:
            begin
              $display("state 3");
              count = 0;
              while(count < `GDELAY2 && enable == 1'b1 && reset == 1'b1)
                begin
                      @(negedge clk) count = count + 1;
                      $display("count %d",count);                
                end
              next_state = (count == `GDELAY2)?S4:S0;
              $display("next_state is %d",next_state);
            end  
        S4:
            begin
              $display("state 4");
              count = 0;
              while(count < `YDELAY && enable == 1'b1 && reset == 1'b1)
                begin
                      @(negedge clk) count = count + 1;
                      $display("count %d",count);                
                end
              next_state = (count == `YDELAY)?S1:S0;
              $display("next_state is %d",next_state);
            end 
		S5: next_state = S0;

      endcase
    end  
  
endmodule
