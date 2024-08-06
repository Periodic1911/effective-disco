module vga(clk, rst, hsync, vsync, r, g, b);
  input clk;
  input rst;
  output logic hsync;
  output logic vsync;
  output logic r;
  output logic g;
  output logic b;

  logic [9:0] hcnt; // 0-800
  logic [9:0] vcnt; // 0-525

  always_ff @(posedge clk or posedge rst) begin: counters
	  unique if (rst) begin
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

  always_comb begin: syncs
    hsync = ( (hcnt >= 640+16) && (hcnt < 640+16+96) ) ? 0 : 1;
    vsync = ( (vcnt >= 480+10) && (vcnt < 480+10+2) )  ? 0 : 1;
  end: syncs

  always_comb begin: color_pattern
    unique if (hcnt < 640 && vcnt < 480) begin
      {r, g, b} = hcnt[8:6];
    end else begin
      {r, g, b} = 3'b0;
    end
  end: color_pattern
endmodule
