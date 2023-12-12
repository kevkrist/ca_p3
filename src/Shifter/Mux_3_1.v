// 3-1 multiplexor
// author: Kevin Kristensen
// precondition: select signal != 3
module Mux_3_1(In, Sel, Out);
  input [2:0] In;
  input [1:0] Sel;
  output reg Out;

  always @(In, Sel) begin
    case(Sel)
      0: Out = In[0];
      1: Out = In[1];
      2: Out = In[2];
      default: Out = 1'bX;
    endcase
  end
endmodule