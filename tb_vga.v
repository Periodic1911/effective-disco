module tb_vga;
`timescale 1ns/1ps
logic clk;
logic rst;
logic r, g, b;
logic hsync, vsync;
logic [9:0] hcnt, vcnt;

vga vga0 (.*);

always #20 clk <= ~clk;

initial begin
  rst = 1;
  #40 rst = 0;
end

/*
initial begin
  $dumpfile("dump.vcd");
  $dumpvars;
end
*/

initial begin
  int fd = $fopen("./vga.txt", "w");
  if(fd != 0) $display("File was succesfully opened");
  else   $display("File was NOT succesfully opened");

  $timeformat(-9, 0, " ns", 0);

  #20;
  for(int i = 0; i < 1000000; i++) begin
    $fdisplay(fd, "%t: %d %d %02d %02d %02d", $realtime, hsync, vsync, r*11, g*11, b*11);
    #40;
  end

  $fclose(fd);
  $finish;
end

endmodule;
