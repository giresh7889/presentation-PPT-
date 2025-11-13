//========================================================
//  Round Robin Arbiter
//========================================================
module rr_arbiter (
  input  logic        arb_clk,
  input  logic        arb_rst_n,
  input  logic        arb_req0,
  input  logic        arb_req1,
  input  logic        arb_req2,
  input  logic        arb_req3,
  output logic [1:0]  arb_gnt,
  output logic [1:0]  pointer
);

  always_ff @(posedge arb_clk or negedge arb_rst_n) begin
    if(!arb_rst_n) begin
      pointer <= 2'b00;
      arb_gnt <= 2'b00;
    end else begin
      case(pointer +2'b01)
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
      pointer <= pointer + 2'b01;
    end
  end

endmodule

//========================================================
//  Priority Arbiter
//========================================================
module priority_arbitration (
  input  logic        arb_clk,
  input  logic        arb_rst_n,
  input  logic        arb_req0,
  input  logic        arb_req1,
  input  logic        arb_req2,
  input  logic        arb_req3,
  output logic [1:0]  arb_gnt
);
  always_ff @(posedge arb_clk or negedge arb_rst_n) begin
    if(!arb_rst_n)
      arb_gnt <= 2'b00;
    else begin
    
      if      (arb_req1) arb_gnt <= 2'b01;
      else if (arb_req3) arb_gnt <= 2'b11;
      else if (arb_req2) arb_gnt <= 2'b10;
      else if (arb_req0) arb_gnt <= 2'b00;
    end
  end
endmodule

//========================================================
//  TOP MODULE - Combining Round Robin and Priority Arbiter
//========================================================
module arbiter_top;

  logic arb_clk, arb_rst_n;
  logic arb_req0, arb_req1, arb_req2, arb_req3;
  logic [1:0] rr_gnt, rr_ptr;
  logic [1:0] prio_gnt;

  // Instantiate Round Robin Arbiter
  rr_arbiter u_rr (
    .arb_clk(arb_clk),
    .arb_rst_n(arb_rst_n),
    .arb_req0(arb_req0),
    .arb_req1(arb_req1),
    .arb_req2(arb_req2),
    .arb_req3(arb_req3),
    .arb_gnt(rr_gnt),
    .pointer(rr_ptr)
  );

  // Instantiate Priority Arbiter
  priority_arbitration u_prio (
    .arb_clk(arb_clk),
    .arb_rst_n(arb_rst_n),
    .arb_req0(arb_req0),
    .arb_req1(arb_req1),
    .arb_req2(arb_req2),
    .arb_req3(arb_req3),
    .arb_gnt(prio_gnt)
  );

  initial begin
    arb_clk = 0;
    forever #5 arb_clk = ~arb_clk;
  end

  initial begin
    arb_rst_n = 0;
    arb_req0 = 0; 
    arb_req1 = 0; 
    arb_req2 = 0;
     arb_req3 = 0;
    #10@(posedge arb_clk) arb_rst_n = 1;

    #10@(posedge arb_clk) arb_req0 = 1;                   
    #10@(posedge arb_clk) arb_req2 = 1;                    
    #10@(posedge arb_clk)arb_req3 = 1;                    
    #10@(posedge arb_clk)arb_req1 = 1;                    
    #20 $finish;
  end
  initial begin
    $display("Time | Req3 Req2 Req1 Req0 | RR_GNT PTR | PRIO_GNT");
    $monitor("%4t |   %b    %b    %b    %b   |   %b     %b  |    %b",
              $time, arb_req3, arb_req2, arb_req1, arb_req0, rr_gnt, rr_ptr, prio_gnt);
  end

endmodule
