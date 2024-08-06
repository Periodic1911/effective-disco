module inp(input clk, rst, input_enable, p1up, p1down, p2up, p2down, output [9:0] p1pos, p2pos);

inp1p inp_player1(clk, rst, input_enable, p1up, p1down, p1pos);
inp1p inp_player2(clk, rst, input_enable, p2up, p2down, p2pos);

endmodule;


module inp1p #(parameter CNT = 2) (input clk, rst, input_enable, up, down, output logic [9:0] pos);

always_ff @(posedge clk or posedge rst) begin
  priority if(rst)
    pos <= 0;
  else begin
    // TODO: saturating add/sub
    unique if(input_enable) begin
      unique if (up) pos <= pos + CNT;
      else if (down) pos <= pos - CNT;
      else pos <= pos;
    end else
      pos <= pos;
  end
end

endmodule;
