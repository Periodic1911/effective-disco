module disp (input wire [19:0] ball, input wire [7:0] score, input wire [19:0] ppos, input wire [9:0] vcnt, input wire [9:0] hcnt, output wire draw);
reg ball_draw;
reg score_draw;
reg pad_draw;
reg bg_draw;
assign draw = (ball_draw || score_draw || pad_draw || bg_draw) && visible;

wire visible;
assign visible = (vcnt < 480) && (hcnt < 640);

wire [6:0] sevenSeg1, sevenSeg2;
assign sevenSeg1 = bcdToSevenSeg(score[3:0]);
assign sevenSeg2 = bcdToSevenSeg(score[7:4]);

always @* begin
  bg_draw = 0;
  if (vcnt[9:1] == 128/2) bg_draw = 1;
  if (vcnt[9:1] == 470/2) bg_draw = 1;
  if (hcnt[9:1] == 320/2 && vcnt[5] == 1 && vcnt[9:1] > 128/2) bg_draw = 1;
end

always @* begin
  ball_draw = 0;
  if ( (hcnt < ball[9:0]   && ball[9:0]   < (hcnt+8)) &&
       (vcnt < ball[19:10] && ball[19:10] < (vcnt+8)) )
     ball_draw = 1;
end

always @* begin
  pad_draw = 0;
  if ( (16 < hcnt && hcnt < 24) &&
       (vcnt < 128+48+ppos[9:0] && 128+ppos[9:0] < vcnt) )
    pad_draw = 1;
  if ( (640-24-8 < hcnt && hcnt < 640-16-8) &&
       (vcnt < 128+48+ppos[19:10] && 128+ppos[19:10] < vcnt) )
    pad_draw = 1;
end

always @* begin: score_proc
  reg [9:0] linew;
  reg [9:0] linet;
  reg [9:0] yoff;
  reg [9:0] xoff;
  reg line [0:3];
  reg col [0:2];
  reg inLine, inCol[0:2];
  reg [1:0] i;
  linew = 10'd32;
  linet = 10'd8;
  yoff = 10'd16;
  xoff = 10'd56;

  inLine = (xoff < hcnt && hcnt <= xoff+linet*2+linew);
  for(i = 0; i < 3; i = i + 1) begin
    line[i] = (yoff+(linew+linet)*i < vcnt && vcnt <= yoff+(linew+linet)*i+linet);
  end
  for(i = 0; i < 2; i = i + 1) begin
    inCol[1-i] = (yoff+(linet+linew)*i < vcnt && vcnt <= yoff+(linew+linet)*i+linet*2+linew);
    col[1-i] = (xoff+(linew+linet)*i < hcnt && hcnt <= xoff+(linew+linet)*i+linet);
  end

  score_draw = 0;

  if (sevenSeg1[0] && inLine && line[0]) score_draw = 1;
  if (sevenSeg1[3] && inLine && line[1]) score_draw = 1;
  if (sevenSeg1[6] && inLine && line[2]) score_draw = 1;
  if (sevenSeg1[2] && inCol[0] && col[0]) score_draw = 1;
  if (sevenSeg1[1] && inCol[0] && col[1]) score_draw = 1;
  if (sevenSeg1[5] && inCol[1] && col[0]) score_draw = 1;
  if (sevenSeg1[4] && inCol[1] && col[1]) score_draw = 1;

  xoff = 640-(xoff+linet*2+linew);

  inLine = (xoff < hcnt && hcnt <= xoff+linet*2+linew);
  for(i = 0; i < 3; i = i + 1) begin
    line[i] = (yoff+(linew+linet)*i < vcnt && vcnt <= yoff+(linew+linet)*i+linet);
  end
  for(i = 0; i < 2; i = i + 1) begin
    inCol[1-i] = (yoff+(linet+linew)*i < vcnt && vcnt <= yoff+(linew+linet)*i+linet*2+linew);
    col[1-i] = (xoff+(linew+linet)*i < hcnt && hcnt <= xoff+(linew+linet)*i+linet);
  end

  if (sevenSeg2[0] && inLine && line[0]) score_draw = 1;
  if (sevenSeg2[3] && inLine && line[1]) score_draw = 1;
  if (sevenSeg2[6] && inLine && line[2]) score_draw = 1;
  if (sevenSeg2[2] && inCol[0] && col[0]) score_draw = 1;
  if (sevenSeg2[1] && inCol[0] && col[1]) score_draw = 1;
  if (sevenSeg2[5] && inCol[1] && col[0]) score_draw = 1;
  if (sevenSeg2[4] && inCol[1] && col[1]) score_draw = 1;

end: score_proc

function [6:0] bcdToSevenSeg;
  input [3:0] bcd;
  case (bcd)
    0: bcdToSevenSeg = 7'b1110111;
    1: bcdToSevenSeg = 7'b0100100;
    2: bcdToSevenSeg = 7'b1101011;
    3: bcdToSevenSeg = 7'b1101101;
    4: bcdToSevenSeg = 7'b0111100;
    5: bcdToSevenSeg = 7'b1011101;
    6: bcdToSevenSeg = 7'b1011111;
    7: bcdToSevenSeg = 7'b1100100;
    8: bcdToSevenSeg = 7'b1111111;
    9: bcdToSevenSeg = 7'b1111101;
    default: bcdToSevenSeg = 7'b0111110;
  endcase;
endfunction

endmodule
