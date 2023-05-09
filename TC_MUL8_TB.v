//Verilog HDL for "tc_lib", "TC_MUL8X16_TESTBENCH" "functional"


module TC_MUL8X16_TESTBENCH (m, q, p, match);
	//declare input/output
	input [15:0] p;
	output [7:0] m, q;
	output match;

	reg [7:0] m, q;
	reg [16:0] product;
	reg clk, match;

	initial
	begin
		m = 8'h0;
		q = 8'h0;
		clk = 1'b0;
		match = 1'b0;
		//simulate for 200 units of time
		#400;
		$stop;
	end

	//drive the clk
	always
		#10 clk = ~clk;

	// drive the DUT, compare the output
	always
	begin
		repeat(20)
		begin
			@(posedge clk);
			{m, q} = $random();
			product = m * q;
			@(negedge clk);
			if (product == p)
			begin
				match = 1;
			end else begin
				match = 0;
			end
		end
	end
	
endmodule

