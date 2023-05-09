//Verilog HDL for "tc_lib", "TC_MISR8X16_TESTBENCH" "functional"


module TC_MISR8X16_TESTBENCH (M, SET_EN, SET_VAL, SI, SI_EN, phi, OUT, match);
	// declare input/output
	input [15:0] OUT;
	output [7:0] M;
	output [15:0] SET_VAL;
	output SET_EN, SI, SI_EN, phi, match;

	reg [15:0] exp, SET_VAL;
	reg [7:0] M;
	reg SET_EN, SI, SI_EN, phi, match;

	initial
	begin
		M = 8'h0;
		SET_VAL = 16'h0;
		SET_EN = 0;
		SI = 0;
		SI_EN = 0;
		phi = 0;
		match = 0;
		// simulate for 400 units of time
		#400;
		$stop;
	end

	//drive clk
	always
		#5 phi = ~phi;

	// drive the DUT, compare the output
	always
	begin
		// check reset
		SET_EN = 1;
		exp = 16'h0;
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

		SI_EN = 0;
		SET_EN = 1;
		exp = 16'h0;
		@(posedge phi);
		@(negedge phi);
		check_out;

		// check misr
		SET_EN = 0;
		repeat(20)
		begin
			M = $random();
			misr_shift;
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
		exp[0] <= SI;
		exp[1] <= exp[0];
		exp[2] <= exp[1];
		exp[3] <= exp[2];
		exp[4] <= exp[3];
		exp[5] <= exp[4];
		exp[6] <= exp[5];
		exp[7] <= exp[6];
		exp[8] <= exp[7];
		exp[9] <= exp[8];
		exp[10] <= exp[9];
		exp[11] <= exp[10];
		exp[12] <= exp[11];
		exp[13] <= exp[12];
		exp[14] <= exp[13];
		exp[15] <= exp[14];
	end
	endtask

	task misr_shift;
	begin
		exp[0] <= (exp[15] ^ M[0]);
		exp[1] <= (exp[0] ^ M[1]);
		exp[2] <= (exp[1] ^ M[2]);
		exp[3] <= (exp[2] ^ M[3]);
		exp[4] <= (exp[3] ^ M[4]);
		exp[5] <= (exp[4] ^ M[5]);
		exp[6] <= (exp[5] ^ M[6]);
		exp[7] <= (exp[6] ^ M[7]);
		exp[8] <= exp[7];
		exp[9] <= exp[8];
		exp[10] <= exp[9];
		exp[11] <= (exp[10] ^ exp[15]);	// tap 11 (5)
		exp[12] <= exp[11];
		exp[13] <= (exp[12] ^ exp[15]);	// tap 13 (3)
		exp[14] <= (exp[13] ^ exp[15]);	// tap 14 (2)
		exp[15] <= exp[14];
	end
	endtask

endmodule

