//Verilog HDL for "tc_lib", "TC_ALU_BIST_TOP_TESTBENCH" "functional"


module TC_ALU_BIST_TOP_TESTBENCH (Y, SO, PASS_N, A, B, sel, SET_EN, SI, SI_EN, TEST_EN, clk);
	//declare in/out
	input [15:0] Y;
	input SO, PASS_N;

	output reg [7:0] A, B;
	output reg sel, SET_EN, SI, SI_EN, TEST_EN, clk;


	initial
	begin
		A = 8'h0;
		B = 8'h0;
		sel = 0;
		SET_EN = 0;
		SI_EN = 0;
		SI = 0;
		TEST_EN = 0;
		clk = 0;

		//simulate for 800s
		#700
		$stop;
	end

	always #10 clk = ~clk;

	always 
	begin
		TEST_EN = 1;
		SET_EN = 1;
		@(posedge clk);
		SET_EN = 0;
		@(negedge clk);

		//initialize seed on the next clock edge
		@(posedge clk);
		repeat(32)
		begin
			@(posedge clk);
		end
		if (PASS_N) begin
			$display("BIST FAILED. UH-OH..");
		end else begin
			$display("BIST PASSED! YEE-HAA!");
		end
	end

endmodule

