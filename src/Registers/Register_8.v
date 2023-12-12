// 8-bit register
// author: Kevin Kristensen
module Register_8(clk, 
                  rst, 
                  In, // input
                  WriteEnable,
                  Out); // output

  input clk, rst, WriteEnable;
  input [7:0] In;
  inout [7:0] Out;

  dff ff0(.q(Out[0]), .d(In[0]), .wen(WriteEnable), .clk(clk), .rst(rst));
  dff ff1(.q(Out[1]), .d(In[1]), .wen(WriteEnable), .clk(clk), .rst(rst));
  dff ff2(.q(Out[2]), .d(In[2]), .wen(WriteEnable), .clk(clk), .rst(rst));
  dff ff3(.q(Out[3]), .d(In[3]), .wen(WriteEnable), .clk(clk), .rst(rst));
  dff ff4(.q(Out[4]), .d(In[4]), .wen(WriteEnable), .clk(clk), .rst(rst));
  dff ff5(.q(Out[5]), .d(In[5]), .wen(WriteEnable), .clk(clk), .rst(rst));
  dff ff6(.q(Out[6]), .d(In[6]), .wen(WriteEnable), .clk(clk), .rst(rst));
  dff ff7(.q(Out[7]), .d(In[7]), .wen(WriteEnable), .clk(clk), .rst(rst));
endmodule