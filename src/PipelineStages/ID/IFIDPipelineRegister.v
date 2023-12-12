// IF/ID pipeline register
// author: Kevin Kristensen
module IFIDPipelineRegister(clk,
                            rst,
                            HltIn,
                            InstructionIn,
                            StallIn,
                            NoopIn,
                            PCIn,
                            WriteEnable,
                            HltOut,
                            InstructionOut,
                            StallOut,
                            PCOut, 
                            NoopOut);

  input clk, rst, WriteEnable, StallIn, HltIn, NoopIn;
  input [15:0] InstructionIn, PCIn;
  inout StallOut, HltOut, NoopOut;
  inout [15:0] InstructionOut, PCOut;

  wire StallReassertEnable;
  assign StallReassertEnable = (~WriteEnable & StallIn) ? 1'b1 : WriteEnable;

  dff Hlt(.q(HltOut),
          .d(HltIn),
          .wen(WriteEnable),
          .clk(clk),
          .rst(rst | NoopIn));
  dff Noop(.q(NoopOut),
           .d(NoopIn),
           .wen(WriteEnable),
           .clk(clk),
           .rst(rst));
  Register_16 Instruction(.clk(clk), 
                          .rst(rst | NoopIn), 
                          .In(InstructionIn), 
                          .WriteEnable(WriteEnable), 
                          .Out(InstructionOut));
  Register_16 PC(.clk(clk), 
                 .rst(rst | NoopIn), 
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
                    .wen(StallReassertEnableEnable),
                    .clk(clk),
                    .rst(rst | NoopIn));
endmodule