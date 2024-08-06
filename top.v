module top(input CLK, PIN_1, PIN_2, PIN_3, PIN_4, PIN_5, output PIN_14, PIN_15, PIN_16, PIN_17, PIN_18, PIN_19);
wire rst;
assign rst = PIN_5;

wire clk_25;
/* verilator lint_off UNUSEDSIGNAL */
wire clk_locked;
/* verilator lint_on UNUSEDSIGNAL */

pll pll25( .clock_in(CLK), .clock_out(clk_25), .locked( clk_locked ) );

wire [9:0] p1pos;
wire [9:0] p2pos;
wire [19:0] ppos;
assign ppos = {p2pos, p1pos};
wire [7:0] score_disp = 8'h46;
wire [19:0] ball_disp = {10'd100, 10'd50};
wire [9:0] vcnt, hcnt;
wire disp_out;
assign PIN_19 = disp_out;

inp inp0 (.clk(clk_25), .rst(rst), .input_enable(0), .p1up(PIN_1), .p1down(PIN_2), .p2up(PIN_3), .p2down(PIN_4), .p1pos(p1pos), .p2pos(p2pos));

disp disp0 (.ball(ball_disp), .score(score_disp), .ppos(ppos), .vcnt(vcnt), .hcnt(hcnt), .draw(disp_out));

vga vga0 (.clk(clk_25), .rst(rst), .hsync(PIN_14), .vsync(PIN_15), .r(PIN_16), .g(PIN_17), .b(PIN_18), .hcnt(hcnt), .vcnt(vcnt));
endmodule
