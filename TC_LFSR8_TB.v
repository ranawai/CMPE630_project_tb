//Verilog HDL for "tc_lib", "TC_LFSRX8_TESTBENCH" "functional"


module TC_LFSRX8_TESTBENCH ( OUT, SET_EN, SET_VAL, SI, SI_EN, phi, match );
	// declare in/out
	input [7:0] OUT;
	output [7:0] SET_VAL;
	output SET_EN, SI, SI_EN, phi, match;

	reg [7:0] exp, SET_VAL;
	reg SET_EN, SI, SI_EN, phi, match;

	initial
	begin
		SET_VAL = 8'h0;
		SET_EN = 0;
		SI = 0;
		SI_EN = 0;
		phi = 0;
		match = 0;
		// simulate for 300 units of time
		#300;
		$stop;
	end

	//drive clk
	always
		#5 phi = ~phi;

	// drive the DUT, compare the output
	always
	begin
		// check reset,
		SET_EN = 1;
		SET_VAL = 8'h0;
		exp = 8'h0;
		@(posedge phi);
		@(negedge phi);
		check_out;

		//check SI
		SET_EN = 0;
		SI_EN = 1;
		repeat(10)
		begin
			SI = $random();
			shift;
			@(posedge phi);
			@(negedge phi);
			check_out;
		end

		//check set
		SI_EN = 0;
		SET_EN = 1;
		SET_VAL = $random();
		exp = SET_VAL;
		@(posedge phi);
		@(negedge phi);
		check_out;

		//check lfsr
		SET_EN = 0;
		repeat(12)
		begin
			lfsr_shift;
			@(posedge phi);
			@(negedge phi);
			check_out;
		end

	end

	task check_out;
	begin
		if(exp == OUT) begin
			match = 1;
		end else begin
			match = 0;
		end
	end
	endtask 

	task shift;
	begin
		exp[0] <= exp[1];
		exp[1] <= exp[2];
		exp[2] <= exp[3];
		exp[3] <= exp[4];
		exp[4] <= exp[5];
		exp[5] <= exp[6];
		exp[6] <= exp[7];
		exp[7] <= SI;
	end
	endtask

	task lfsr_shift;
	begin
		exp[0] <= exp[1];
		exp[1] <= exp[2];
		exp[2] <= exp[3];
		exp[3] <= (exp[4] ^ exp[0]); //tap 4
		exp[4] <= (exp[5] ^ exp[0]); //tap 5
		exp[5] <= (exp[6] ^ exp[0]); //tap 6
		exp[6] <= exp[7];
		exp[7] <= exp[0];
	end
	endtask

endmodule

