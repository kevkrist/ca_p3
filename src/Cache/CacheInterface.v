// Inteface for cache, cache controller, and memory
// author: Kevin Kristensen
module CacheInterface(input clk,
                      input rst,
                      input[15:0] PipelineDataIn, // From pipeline stage
                      input[15:0] PipelineAddressIn,
                      input[15:0] MemoryDataIn, // From memory
                      input[15:0] MemoryAddressIn,
                      input CacheWriteEnable,
                      input MemStall,
                      output[15:0] PipelineDataOut, // To pipeline stage
                      output Stall,
                      output[15:0] MemoryAddressOut, // To memory
                      output MemoryRequest);

  wire OldFsmBusy, 
       NewFsmBusy, 
       OldFsmWriteDataArray, 
       NewFsmWriteDataArray,
       OldFsmWriteMetaDataArray,
       NewFsmWriteMetaDataArray,
       CacheWriteDataArray;
  wire [15:0] OldFsmWriteMemoryAddress,
              NewFsmWriteMemoryAddress,
              CacheDataIn,
              CacheAddressIn;

  dff FsmBusyReg(.q(OldFsmBusy),
                 .d(NewFsmBusy),
                 .wen(1'b1),
                 .clk(clk),
                 .rst(rst));
  dff FsmWriteDataArrayReg(.q(OldFsmWriteDataArray),
                           .d(NewFsmWriteDataArray),
                           .wen(1'b1),
                           .clk(clk),
                           .rst(rst));
  dff FsmWriteMetaDataArrayReg(.q(OldFsmWriteMetaDataArray),
                               .d(NewFsmWriteMetaDataArray),
                               .wen(1'b1),
                               .clk(clk),
                               .rst(rst));
  Register_16 FsmWriteMemoryAddressReg(.clk(clk),
                                       .rst(rst),
                                       .In(NewFsmWriteMemoryAddress),
                                       .WriteEnable(1'b1),
                                       .Out(OldFsmWriteMemoryAddress));

  assign CacheDataIn = OldFsmBusy ? MemoryDataIn : PipelineDataIn;
  assign CacheAddressIn = OldFsmBusy ? MemoryAddressIn : PipelineAddressIn;
  assign CacheWriteDataArray = OldFsmBusy ? OldFsmWriteDataArray 
                                          : CacheWriteEnable;

  Cache_2KB Cache(.clk(clk),
                  .rst(rst),
                  .DataIn(CacheDataIn),
                  .AddressIn(CacheAddressIn),
                  .WriteData(CacheWriteDataArray),
                  .WriteMetaData(OldFsmWriteMetaDataArray),
                  .DataOut(PipelineDataOut),
                  .Miss(Miss));

  cache_fill_FSM CacheController(.clk(clk), // Inputs
                                 .rst_n(~rst),
                                 .miss_detected(Miss),
                                 .miss_address(PipelineAddressIn),
                                 .fsm_busy(NewFsmBusy), // Outputs
                                 .write_data_array(NewFsmWriteDataArray),
                                 .write_tag_array(NewFsmWriteMetaDataArray),
                                 .memory_address(NewFsmWriteMemoryAddress));

  assign Stall = Miss | NewFsmBusy;
  assign MemoryRequest = NewFsmBusy;
  assign MemoryAddressOut = NewFsmWriteMemoryAddress;

endmodule