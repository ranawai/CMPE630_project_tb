//Verilog HDL for "tc_lib", "TC_MIRRORADDER_8X8_TESTBENCH" "functional"


module TC_MIRRORADDER_8X8_TESTBENCH ( Cout, S7, S6, S5, S4, S3, S2, S1, S0, A, B, Cin, match);
	//declare input / output
	input Cout, S7, S6, S5, S4, S3, S2, S1, S0;
	output [7:0] A, B;
	output Cin, match;

	reg [7:0] A, B;
	reg [8:0] sum;
	reg Cin, clk, match;

	initial
	begin
		A = 8'h0;
		B = 8'h0;
		clk = 0;
		Cin = 0;
		match = 0;
		// simulate for 200 units of time
		#200;
		$stop;
	end

	// drive clk
	always
		#5 clk = ~clk;

	// drive the DUT, compare the output
	always
	begin
		repeat(20)
		begin
			@(posedge clk);
			{A, B, Cin} = $random();
			sum = A + B + Cin;
			@(negedge clk);
			if (sum == {Cout, S7, S6, S5, S4, S3, S2, S1, S0}) 
			begin
				match = 1;
			end else begin
				match = 0;
			end
		end
	end
	
endmodule


