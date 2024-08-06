module tb_vga;

`timescale 1ns/1ps
logic clk;
logic rst;
logic r, g, b;
logic hsync, vsync;
logic [9:0] hcnt, vcnt;
logic [19:0] ball = {10'd200,10'd300};
logic [7:0] score = 8'h64;
logic [19:0] ppos = {10'd0,10'd100};
logic draw;

vga vga0 (.*);
disp disp0 (.*);

always #20 clk <= ~clk;

initial begin
  rst = 1;
  #40 rst = 0;
end

initial begin
  $dumpfile("dump.vcd");
  $dumpvars;
end

initial begin
  int fd = $fopen("./disp.txt", "w");
  if(fd != 0) $display("File was succesfully opened");
  else   $display("File was NOT succesfully opened");

  $timeformat(-9, 0, " ns", 0);

  #20;
  for(int i = 0; i < 1000000; i++) begin
    $fdisplay(fd, "%t: %d %d %02d %02d %02d", $realtime, hsync, vsync, draw*11, draw*11, draw*11);
    #40;
  end

  $fclose(fd);
  $finish;
end

endmodule;
