/* fake pll for simulation */

/* verilator lint_off UNUSEDSIGNAL */
module pll(
	input  clock_in,
	output clock_out,
	output locked
	);

reg clk25;

assign clock_out = clk25;

always #20 clk25 <= ~clk25;

assign locked = 1;

endmodule
