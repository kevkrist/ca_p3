// Instruction fetch stage module
// Author: Garret Johnson
module InstructionFetch(clk,
                        rst,
                        PC,
                        Stall,
                        PC_Disrupt,
                        PC_Branch,
                        Instruction,
                        NextPC,
                        CacheStall,
                        hlt);
  input clk, rst, Stall, PC_Disrupt;
  input [15:0] PC, PC_Branch;
  output hlt, CacheStall;
  output [15:0] Instruction, NextPC;

  wire _hlt, Dummy;
  wire [15:0] _Instruction, PC_2;

  Adder_16bit Add2(.Sum(PC_2),
                   .Overflow(Dummy),
                   .A(PC),
                   .B(16'h0002),
                   .Sub(1'b0));

  /*InstructionMem InstMem(.clk(clk), 
                         .rst(rst), 
                         .wr(1'b0),
                         .enable(1'b1), 
                         .addr(PC), 
                         .data_in(16'h0000), 
                         .data_out(_Instruction));*/
  
  CacheInterface InstructionCache (.clk(clk), 
                                  .rst(rst), 
                                  .PipelineDataIn(16'b0),  //bus 
                                  .PipelineAddressIn(PC),  //bus
                                  .MemoryDataIn(),         //bus ?
                                  .MemoryAddressIn(),      //bus ?
                                  .CacheWriteEnable(),     // ?
                                  .MemStall(),             // ?
                                  .PipelineDataOut(_Instruction), //bus -- OUTPUTS
                                  .Stall(CacheStall),
                                  .MemoryAddressOut(),     //bus
                                  .MemoryRequest());

  assign _hlt = (_Instruction[15:12] == 4'hf) ? 1: 0;
  assign NextPC = PC_Disrupt ? PC_Branch : ((_hlt | Stall) ? PC : PC_2);
  // assign NextPC = (_hlt | Stall) ? PC : (PC_Disrupt ? PC_Branch : PC_2);
  assign hlt = _hlt;
  assign Instruction = _Instruction;

endmodule
