module vga(clk, rst, hsync, vsync, r, g, b, hcnt, vcnt);
  input clk;
  input rst;
  output reg hsync;
  output reg vsync;
  output reg r;
  output reg g;
  output reg b;

  output reg [9:0] hcnt; // 0-800
  output reg [9:0] vcnt; // 0-525

  always @(posedge clk or posedge rst) begin: counters
	  if (rst) begin
      hcnt <= 0;
      vcnt <= 0;
    end else begin
	    hcnt <= hcnt + 1;
      if (hcnt == 800) begin
        hcnt <= 0;
        vcnt <= vcnt + 1;
        if (vcnt == 525) begin
          vcnt <= 0;
        end
      end
    end
  end: counters

  always @(hcnt or vcnt) begin: syncs
    hsync = ( (hcnt >= 640+16) && (hcnt < 640+16+96) ) ? 0 : 1;
    vsync = ( (vcnt >= 480+10) && (vcnt < 480+10+2) )  ? 0 : 1;
  end: syncs

  always @(hcnt or vcnt) begin: color_pattern
    if (hcnt < 640 && vcnt < 480) begin
      {r, g, b} = hcnt[8:6];
    end else begin
      {r, g, b} = 3'b0;
    end
  end: color_pattern
endmodule
