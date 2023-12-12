// 3-bit register
// author: Kevin Kristensen
module Register_2(clk, 
                  rst, 
                  In, // input
                  WriteEnable,
                  Out); // output

  input clk, rst, WriteEnable;
  input [1:0] In;
  inout [1:0] Out;

  dff ff0(.q(Out[0]), .d(In[0]), .wen(WriteEnable), .clk(clk), .rst(rst));
  dff ff1(.q(Out[1]), .d(In[1]), .wen(WriteEnable), .clk(clk), .rst(rst));
endmodule