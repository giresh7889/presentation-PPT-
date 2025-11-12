
module rr_arbiter (

         input  logic        arb_clk,      
         input  logic        arb_rst_n,    
         input  logic        arb_req0,  
         input  logic        arb_req1,     
         input  logic        arb_req2,     
         input  logic        arb_req3,     
         output logic [1:0]  arb_gnt );

  logic [1:0] pointer;  

  always_ff @(posedge arb_clk or negedge arb_rst_n) begin
    if(!arb_rst_n) begin
      pointer <= 2'b00;   
      arb_gnt <= 2'b00;   
    end
    else begin
      case(pointer)
        2'b00: begin
          if(arb_req0)      arb_gnt <= 2'b00;
          else if(arb_req1) arb_gnt <= 2'b01;
          else if(arb_req2) arb_gnt <= 2'b10;
          else if(arb_req3) arb_gnt <= 2'b11;
          else              arb_gnt <= arb_gnt; 
        end

        2'b01: begin
          if(arb_req1)      arb_gnt <= 2'b01;
          else if(arb_req2) arb_gnt <= 2'b10;
          else if(arb_req3) arb_gnt <= 2'b11;
          else if(arb_req0) arb_gnt <= 2'b00;
          else              arb_gnt <= arb_gnt;
        end

        2'b10: begin
          if(arb_req2)      arb_gnt <= 2'b10;
          else if(arb_req3) arb_gnt <= 2'b11;
          else if(arb_req0) arb_gnt <= 2'b00;
          else if(arb_req1) arb_gnt <= 2'b01;
          else              arb_gnt <= arb_gnt;
        end

        2'b11: begin
          if(arb_req3)      arb_gnt <= 2'b11;
          else if(arb_req0) arb_gnt <= 2'b00;
          else if(arb_req1) arb_gnt <= 2'b01;
          else if(arb_req2) arb_gnt <= 2'b10;
          else              arb_gnt <= arb_gnt;
        end
      endcase
      pointer <= pointer + 1;
    end
  end

endmodule
	
