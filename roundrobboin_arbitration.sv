
module rr_arbiter (

         input             arb_clk,      
         input             arb_rst_n,    
         input             arb_req0,  
         input             arb_req1,     
         input             arb_req2,     
         input             arb_req3,     
         output logic [1:0]  arb_gnt,
	 output logic [1:0] pointer);  

  always_ff @(posedge arb_clk or negedge arb_rst_n) begin
    if(!arb_rst_n) begin
      pointer <= 2'b00;   
      arb_gnt <= 2'b00;   
    end
    else begin
      case(pointer+2'b01)
        2'b00: begin
          if(arb_req0)      arb_gnt <= 2'b00;
          else if(arb_req1) arb_gnt <= 2'b01;
          else if(arb_req2) arb_gnt <= 2'b10;
          else if(arb_req3) arb_gnt <= 2'b11;
          else              arb_gnt <= 2'b00; 
        end

        2'b01: begin
          if(arb_req1)      arb_gnt <= 2'b01;
          else if(arb_req2) arb_gnt <= 2'b10;
          else if(arb_req3) arb_gnt <= 2'b11;
          else if(arb_req0) arb_gnt <= 2'b00;
          else              arb_gnt <= 2'b00;
        end

        2'b10: begin
          if(arb_req2)      arb_gnt <= 2'b10;
          else if(arb_req3) arb_gnt <= 2'b11;
          else if(arb_req0) arb_gnt <= 2'b00;
          else if(arb_req1) arb_gnt <= 2'b01;
          else              arb_gnt <= 2'b00;
        end

        2'b11: begin
          if(arb_req3)      arb_gnt <= 2'b11;
          else if(arb_req0) arb_gnt <= 2'b00;
          else if(arb_req1) arb_gnt <= 2'b01;
          else if(arb_req2) arb_gnt <= 2'b10;
          else              arb_gnt <= 2'b00;
        end
      endcase
      pointer <= pointer + 1;
    end
  end

endmodule
//----------------------------------------------------------------------------------------------------------------------------------------
//simple_test_bench
//------------------------------------------------------------------------------------------------------------------------------------
module tb_rr_arbiter;

  logic arb_clk;
  logic arb_rst_n;
  logic arb_req0, arb_req1, arb_req2, arb_req3;
  logic [1:0] arb_gnt;
  logic [1:0] pointer;


  rr_arbiter dut (
    .arb_clk(arb_clk),
    .arb_rst_n(arb_rst_n),
    .arb_req0(arb_req0),
    .arb_req1(arb_req1),
    .arb_req2(arb_req2),
    .arb_req3(arb_req3),
    .arb_gnt(arb_gnt),
    .pointer(pointer)
  );

  initial arb_clk = 0;
  always #5 arb_clk = ~arb_clk;


  initial begin
    arb_rst_n = 0;
    arb_req0 = 0;
    arb_req1 = 0;
    arb_req2 = 0;
    arb_req3 = 0;
    #10@(posedge arb_clk) arb_rst_n = 1;  //reset realse (active low reset) 

  
    #10@(posedge arb_clk) arb_req0 = 0;                             
    #10 @(posedge arb_clk)arb_req1 = 1;
                          arb_req3 = 1;                                        
    #10@(posedge arb_clk) arb_req2 = 1;                                
    #10@(posedge arb_clk) arb_req3 = 1;                               
 

    #10 $finish;
  end


  initial begin
    $monitor("Time=%0t | Ptr=%b | Req0=%b Req1=%b Req2=%b Req3=%b | Gnt=%b",
              $time, pointer, arb_req0, arb_req1, arb_req2, arb_req3, arb_gnt);
  end

endmodule
	
