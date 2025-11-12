module priority_arbitration(
	input logic arb_clk,
	input logic arb_rst_n,
	input logic arb_req0,
	input logic arb_req1,
	input logic arb_req2,
	input logic arb_req3,
	output logic[1:0] arb_gnt);
	always_ff @ (posedge arb_clk or negedge arb_rst_n)begin
		if(!arb_rst_n)
			arb_gnt < = 2'b00;
		else begin
			if     (arb_req1)  arb_gnt < = 2'b01;
			else if(arb_req3)  arb_gnt < = 2'b11;
			else if(arb_req2)  arb_gnt < = 2'b10;
	        	else   (arb_req0)  arb_gnt < = 2'b00;
		end
	end
	endmodule







