// 3-bit register (for FLAG register)
// author: Kevin Kristensen
module Register_3(clk, 
                  rst, 
                  In, // input
                  WriteEnable,
                  Out); // output

  input clk, rst, WriteEnable;
  input [2:0] In;
  inout [2:0] Out;

  dff ff0(.q(Out[0]), .d(In[0]), .wen(WriteEnable), .clk(clk), .rst(rst));
  dff ff1(.q(Out[1]), .d(In[1]), .wen(WriteEnable), .clk(clk), .rst(rst));
  dff ff2(.q(Out[2]), .d(In[2]), .wen(WriteEnable), .clk(clk), .rst(rst));
endmodule