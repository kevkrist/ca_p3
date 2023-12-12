// 16-bit register (for PC and RF bypassing)
// author: Kevin Kristensen
module Register_16(clk, 
                   rst, 
                   In, // input
                   WriteEnable, 
                   Out); // output

  input clk, rst, WriteEnable;
  input [15:0] In;
  inout [15:0] Out;

  dff ff0(.q(Out[0]), .d(In[0]), .wen(WriteEnable), .clk(clk), .rst(rst));
  dff ff1(.q(Out[1]), .d(In[1]), .wen(WriteEnable), .clk(clk), .rst(rst));
  dff ff2(.q(Out[2]), .d(In[2]), .wen(WriteEnable), .clk(clk), .rst(rst));
  dff ff3(.q(Out[3]), .d(In[3]), .wen(WriteEnable), .clk(clk), .rst(rst));
  dff ff4(.q(Out[4]), .d(In[4]), .wen(WriteEnable), .clk(clk), .rst(rst));
  dff ff5(.q(Out[5]), .d(In[5]), .wen(WriteEnable), .clk(clk), .rst(rst));
  dff ff6(.q(Out[6]), .d(In[6]), .wen(WriteEnable), .clk(clk), .rst(rst));
  dff ff7(.q(Out[7]), .d(In[7]), .wen(WriteEnable), .clk(clk), .rst(rst));
  dff ff8(.q(Out[8]), .d(In[8]), .wen(WriteEnable), .clk(clk), .rst(rst));
  dff ff9(.q(Out[9]), .d(In[9]), .wen(WriteEnable), .clk(clk), .rst(rst));
  dff ff10(.q(Out[10]), .d(In[10]), .wen(WriteEnable), .clk(clk), .rst(rst));
  dff ff11(.q(Out[11]), .d(In[11]), .wen(WriteEnable), .clk(clk), .rst(rst));
  dff ff12(.q(Out[12]), .d(In[12]), .wen(WriteEnable), .clk(clk), .rst(rst));
  dff ff13(.q(Out[13]), .d(In[13]), .wen(WriteEnable), .clk(clk), .rst(rst));
  dff ff14(.q(Out[14]), .d(In[14]), .wen(WriteEnable), .clk(clk), .rst(rst));
  dff ff15(.q(Out[15]), .d(In[15]), .wen(WriteEnable), .clk(clk), .rst(rst));
endmodule