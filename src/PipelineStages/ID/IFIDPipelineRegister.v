// IF/ID pipeline register
// author: Kevin Kristensen
module IFIDPipelineRegister(clk,
                            rst,
                            HltIn,
                            InstructionIn,
                            StallIn,
                            PCIn,
                            NoopIn,
                            WriteEnable,
                            HltOut,
                            InstructionOut,
                            StallOut,
                            PCOut);

  input clk, rst, WriteEnable, StallIn, HltIn, NoopIn;
  input [15:0] InstructionIn, PCIn;
  inout StallOut, HltOut;
  inout [15:0] InstructionOut, PCOut;

  wire StallReassertEnable, _rst;
  assign StallReassertEnable = (~WriteEnable & StallIn) ? 1'b1 : WriteEnable;
  assign _rst = rst | NoopIn;

  dff Hlt(.q(HltOut),
          .d(HltIn),
          .wen(WriteEnable),
          .clk(clk),
          .rst(_rst));
  Register_16 Instruction(.clk(clk), 
                          .rst(_rst), 
                          .In(InstructionIn), 
                          .WriteEnable(WriteEnable), 
                          .Out(InstructionOut));
  Register_16 PC(.clk(clk), 
                 .rst(_rst), 
                 .In(PCIn), 
                 .WriteEnable(WriteEnable), 
                 .Out(PCOut));
  // StallReassert is only 1 when the hazard detection unit determines that
  // 2 stalls are needed. In this case, the decode stage asserts the stall
  // signal AND puts 1 in the StallReassert signal, so that it can raise
  // another stall on the next clock cycle. 
  // Note: if the write enable signal is deasserted (because of a stall),
  // but the StallIn signal is also asserted, we must still write to
  // StallReassert, so that a stall is still reasserted in the next stage.
  dff StallReassert(.q(StallOut),
                    .d(StallIn),
                    .wen(StallReassertEnable),
                    .clk(clk),
                    .rst(_rst));
endmodule