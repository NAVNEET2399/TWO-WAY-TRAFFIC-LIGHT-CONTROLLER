

module stimulus;
 reg CLK, RESET, ENABLE;
 wire GREEN_1, YELLOW_1, RED_1, GREEN_2, YELLOW_2, RED_2;
  traffic t0(.green_1(GREEN_1), .yellow_1(YELLOW_1), .red_1(RED_1), .green_2(GREEN_2),.yellow_2(YELLOW_2), .red_2(RED_2), .clk(CLK), .reset(RESET), .enable(ENABLE));
  
 initial
  begin
    CLK = 1'b0;
    RESET = 1'b0;
    ENABLE = 1'b1;    
    forever #1 CLK = ~CLK;
  end
  
  initial 
    begin
      $monitor($time," G1,Y1,R1= %b%b%b  and G2,Y2,R2 = %b%b%b",GREEN_1, YELLOW_1, RED_1, GREEN_2, YELLOW_2, RED_2);
      $dumpfile("test.vcd");
      $dumpvars(0,stimulus);
      #5 RESET = 1'b1;
      #140 RESET = 1'b0;
      #50 RESET = 1'b1;
      #5 ENABLE = 1'b0;
      #50 ENABLE = 1'b1;
    end
  
  initial
    #400 $finish;  
endmodule
