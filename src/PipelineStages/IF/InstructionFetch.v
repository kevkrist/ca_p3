// Instruction fetch stage module
// Author: Garret Johnson, Kevin Kristensen
module InstructionFetch(clk, // INPUTS
                        rst,
                        PC,
                        Stall, // From ID
                        PC_Disrupt,
                        PC_Branch,
                        MemStall, // From memory
                        MemData,
                        MemAddress,
                        MemCacheWriteEnable,
                        Instruction, // OUTPUTS
                        NextPC,
                        hlt,
                        MemoryAddressOut,
                        MemoryRequest);
  input clk, rst, Stall, PC_Disrupt, MemCacheWriteEnable;
  input [15:0] PC, PC_Branch;
  output hlt, MemoryRequest;
  output [15:0] Instruction, NextPC, MemoryAddressOut, MemAddress, MemData;

  wire _hlt, Dummy, CacheStall, _MemoryRequest;
  wire [15:0] _Instruction, PC_2, _MemoryAddressOut;

  Adder_16bit Add2(.Sum(PC_2),
                   .Overflow(Dummy),
                   .A(PC),
                   .B(16'h0002),
                   .Sub(1'b0));

  CacheInterface InstructionCache(.clk(clk), // INPUTS
                                  .rst(rst),
                                  .PipelineDataIn(16'h000),
                                  .PipelineAddressIn(PC),
                                  .MemoryDataIn(MemData),
                                  .MemoryAddressIn(MemAddress),
                                  .CacheWriteEnable(MemCacheWriteEnable),
                                  .MemoryStall(MemStall),
                                  .PipelineDataOut(_Instruction), // OUTPUTS
                                  .Stall(CacheStall),
                                  .MemoryAddressOut(_MemoryAddressOut),
                                  .MemoryRequest(_MemoryRequest));

  assign _hlt = (_Instruction[15:12] == 4'hf) ? 1: 0;
  assign NextPC = PC_Disrupt ? PC_Branch 
                             : (_hlt | MemStall | CacheStall | Stall) 
                               ? PC : PC_2;
  assign hlt = _hlt;
  assign Instruction = _Instruction;
  assign MemoryAddressOut = _MemoryAddressOut;
  assign MemoryRequest = _MemoryRequest;

endmodule
