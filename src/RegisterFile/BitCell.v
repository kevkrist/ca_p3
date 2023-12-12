// Bit cell consisting of a D flip-flop and a tri-state buffer
// author: Kevin Kristensen
module BitCell(clk, 
               rst, // Reset (for flip-flop)
               D, 
               WriteEnable, 
               ReadEnable1, 
               ReadEnable2, 
               Bitline1, 
               Bitline2);
  input clk, rst, D, WriteEnable, ReadEnable1, ReadEnable2;
  inout Bitline1, Bitline2;
  wire Q;

  dff DFlipFlop(.q(Q), .d(D), .wen(WriteEnable), .clk(clk), .rst(rst));
  TriStateBuffer T1(.Data(Q), .OutputEnable(ReadEnable1), .Output(Bitline1));
  TriStateBuffer T2(.Data(Q), .OutputEnable(ReadEnable2), .Output(Bitline2));
endmodule

// Tri stage buffer module
module TriStateBuffer(Data, OutputEnable, Output);
  input Data, OutputEnable;
  output Output;

  assign Output = OutputEnable ? Data : 1'bZ;
endmodule