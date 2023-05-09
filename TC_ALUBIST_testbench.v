//Verilog HDL for "tc_lib", "TC_ALU_BIST_TESTBENCH" "functional"


module TC_ALU_BIST_TESTBENCH ( A, B, sel, SEED_A, SEED_B, SET_EN, SI, SI_EN, TEST_EN, clk, Y, MISR_OUT, y_match, misr_match );
	//declare in/out
	input [15:0] Y, MISR_OUT;
	output [7:0] A, B, SEED_A, SEED_B;
	output sel, SET_EN, SI, SI_EN, TEST_EN, clk, y_match, misr_match;

	reg[15:0] exp_y, exp_misr;
	reg[7:0] lfsr_a, lfsr_b, M;
	reg[7:0] A, B, SEED_A, SEED_B;
	reg sel, SET_EN, SI, SI_EN, TEST_EN, clk, y_match, misr_match;

	initial
	begin
		A = 8'h0;
		B = 8'h0;
		sel = 0;
		SEED_A = 8'h0;
		SEED_B = 8'h0;
		SET_EN = 0;
		SI = 0;
		SI_EN = 0;
		TEST_EN = 0;
		clk = 0;
		y_match = 0;
		misr_match = 0;
		// simulate for 1000 units of time
		#2000;
		$stop;
	end

	// drive the clk
	always 
		#10 clk = ~clk;

	// testbench, I have a feeling that I'm gonna hate my life
	always 
	begin
		TEST_EN = 1;
		// reset
		SEED_A = 8'h0;
		SEED_B = 8'h0;
		SET_EN = 1;
		lfsr_a = 8'h0;
		lfsr_b = 8'h0;
		exp_y = 16'h0;
		exp_misr = 16'h0;
		@(posedge clk);
		@(negedge clk);
		check_y;
		check_misr;
		
		// test SI
		SET_EN = 0;
		SI_EN = 1;
		repeat(40)
		begin
			SI = $random();
			si_shift;
			@(posedge clk);
			@(negedge clk);
			check_misr;
		end

		// set
		SI_EN = 0;
		SET_EN = 1;
		// {SEED_A,SEED_B} = $random(); 
		// to generate golden sig
		SEED_A = 8'b10110011;
		SEED_B = 8'b00111011;
		@(posedge clk);
		lfsr_a = SEED_A;
		lfsr_b = SEED_B;
		exp_y = (SEED_A[0]) ? (SEED_A * SEED_B) : (SEED_A + SEED_B);
		exp_misr = 16'h0;
		@(negedge clk);
		check_y;
		check_misr;	

		// test the bist
		SET_EN = 0;
		repeat(32) 
		begin
			normal_op;
			@(posedge clk);
			exp_y = (lfsr_a[0]) ? (lfsr_a * lfsr_b) : (lfsr_a + lfsr_b);
			@(negedge clk);
			check_y;
			check_misr;
			$display("not yet golden signature: %b", MISR_OUT);
		end

		normal_op;
		@(posedge clk);
		exp_y = (lfsr_a[0]) ? (lfsr_a * lfsr_b) : (lfsr_a + lfsr_b);
		@(negedge clk);
		check_misr;
		$display ("The golden signature after 32 cycles: %b", MISR_OUT);

		// test the design
		TEST_EN = 0;
		repeat(10)
		begin
			{A, B, sel} = $random();
			exp_y = sel ? (A * B) : (A + B);
			@(posedge clk);
			check_y;
		end

	end // end of testbench always

	task check_y;
	begin
		if(exp_y == Y) begin
			y_match = 1;
		end else begin
			y_match = 0;
		end
	end
	endtask

	task check_misr;
	begin
		if(exp_misr == MISR_OUT) begin
			misr_match = 1;
		end else begin
			misr_match = 0;
		end
	end
	endtask

	task si_shift;
	begin
		lfsr_a[7] <= SI;
		lfsr_a[6] <= lfsr_a[7];
		lfsr_a[5] <= lfsr_a[6];
		lfsr_a[4] <= lfsr_a[5];
		lfsr_a[3] <= lfsr_a[4];
		lfsr_a[2] <= lfsr_a[3];
		lfsr_a[1] <= lfsr_a[2];
		lfsr_a[0] <= lfsr_a[1];
		lfsr_b[7] <= lfsr_a[0];
		lfsr_b[6] <= lfsr_b[7];
		lfsr_b[5] <= lfsr_b[6];
		lfsr_b[4] <= lfsr_b[5];
		lfsr_b[3] <= lfsr_b[4];
		lfsr_b[2] <= lfsr_b[3];
		lfsr_b[1] <= lfsr_b[2];
		lfsr_b[0] <= lfsr_b[1];
		exp_misr[0] <= lfsr_b[0];
		exp_misr[1] <= exp_misr[0];
		exp_misr[2] <= exp_misr[1];
		exp_misr[3] <= exp_misr[2];
		exp_misr[4] <= exp_misr[3];
		exp_misr[5] <= exp_misr[4];
		exp_misr[6] <= exp_misr[5];		
		exp_misr[7] <= exp_misr[6];
		exp_misr[8] <= exp_misr[7];
		exp_misr[9] <= exp_misr[8];
		exp_misr[10] <= exp_misr[9];
		exp_misr[11] <= exp_misr[10];
		exp_misr[12] <= exp_misr[11];
		exp_misr[13] <= exp_misr[12];
		exp_misr[14] <= exp_misr[13];
		exp_misr[15] <= exp_misr[14];
	end
	endtask

	task normal_op;
	begin
		M = {(exp_y[15] ^ exp_y[14]), (exp_y[13] ^ exp_y[12]), (exp_y[11] ^ exp_y[10]), 
				(exp_y[9] ^ exp_y[8]), (exp_y[7] ^ exp_y[6]), (exp_y[5] ^ exp_y[4]), 
				(exp_y[3] ^ exp_y[2]), (exp_y[1] ^ exp_y[0])};
		lfsr_a[7] <= lfsr_a[0];
		lfsr_a[6] <= lfsr_a[7];
		lfsr_a[5] <= (lfsr_a[6] ^ lfsr_a[0]); // tap 6 
		lfsr_a[4] <= (lfsr_a[5] ^ lfsr_a[0]); // tap 5
		lfsr_a[3] <= (lfsr_a[4] ^ lfsr_a[0]); // tap 4
		lfsr_a[2] <= lfsr_a[3];
		lfsr_a[1] <= lfsr_a[2];
		lfsr_a[0] <= lfsr_a[1];

		lfsr_b[7] <= lfsr_b[0];
		lfsr_b[6] <= lfsr_b[7];
		lfsr_b[5] <= (lfsr_b[6] ^ lfsr_b[0]); // tap 6
		lfsr_b[4] <= (lfsr_b[5] ^ lfsr_b[0]); // tap 5
		lfsr_b[3] <= (lfsr_b[4] ^ lfsr_b[0]); // tap 4
		lfsr_b[2] <= lfsr_b[3];
		lfsr_b[1] <= lfsr_b[2];
		lfsr_b[0] <= lfsr_b[1];

		exp_misr[0] <= (exp_misr[15] ^ M[0]);
		exp_misr[1] <= (exp_misr[0] ^ M[1]);
		exp_misr[2] <= (exp_misr[1] ^ M[2]);
		exp_misr[3] <= (exp_misr[2] ^ M[3]);
		exp_misr[4] <= (exp_misr[3] ^ M[4]);
		exp_misr[5] <= (exp_misr[4] ^ M[5]);
		exp_misr[6] <= (exp_misr[5] ^ M[6]);		
		exp_misr[7] <= (exp_misr[6] ^ M[7]);
		exp_misr[8] <= exp_misr[7];
		exp_misr[9] <= exp_misr[8];
		exp_misr[10] <= exp_misr[9];
		exp_misr[11] <= (exp_misr[10] ^ exp_misr[15]); // tap 11 (5)
		exp_misr[12] <= exp_misr[11];
		exp_misr[13] <= (exp_misr[12] ^ exp_misr[15]); // tap 13 (3)
		exp_misr[14] <= (exp_misr[13] ^ exp_misr[15]); // tap 14 (2)
		exp_misr[15] <= exp_misr[14];
	end
	endtask

endmodule

