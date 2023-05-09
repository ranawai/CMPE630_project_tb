//Verilog HDL for "tc_lib", "TC_ALU_TESTBENCH" "functional"


module TC_ALU_TESTBENCH ( A, B, Sel, Y, match );
	// setup input/output
	input [15:0] Y;
	output [7:0] A, B;
	output Sel, match;

	reg [7:0] A, B;
	reg [15:0] out;
	reg clk, Sel, match;

	initial
	begin
		A = 8'h0;
		B = 8'h0;
		Sel = 1'b0;
		clk = 1'b0;
		match = 1'b0;
		// simulate for 400 units of time
		#400;
		$stop;
	end

	// drive clk
	always
		#10 clk = ~clk;

	//drive the DUT, compare the output
	always
	begin
		repeat(20)
		begin
			@(posedge clk);
			{A, B, Sel} = $random();
			out = Sel ? (A * B) : (A + B);
			@(negedge clk);
			if (out == Y)
			begin
				match = 1;
			end else begin
				match  = 0;
			end
		end
	end
	
endmodule

