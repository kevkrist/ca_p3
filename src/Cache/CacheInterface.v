// Inteface for cache, cache controller, and memory
// author: Kevin Kristensen
module CacheInterface(input clk,
                      input rst,
                      input CacheEnable,
                      input[15:0] PipelineDataIn, // From pipeline stage
                      input[15:0] PipelineAddressIn,
                      input PipelineWriteEnable,
                      input[15:0] MemoryDataIn, // From memory
                      input MemoryStall,
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
       CacheWriteDataArray,
       _Miss,
       Miss;
  wire [15:0] OldFsmCacheAddress,
              NewFsmCacheAddress,
              CacheDataIn,
              CacheAddressIn;

  dff FsmBusyReg(.q(OldFsmBusy),
                 .d(NewFsmBusy),
                 .wen(CacheEnable),
                 .clk(clk),
                 .rst(rst));
  dff FsmWriteDataArrayReg(.q(OldFsmWriteDataArray),
                           .d(NewFsmWriteDataArray),
                           .wen(CacheEnable),
                           .clk(clk),
                           .rst(rst));
  dff FsmWriteMetaDataArrayReg(.q(OldFsmWriteMetaDataArray),
                               .d(NewFsmWriteMetaDataArray),
                               .wen(CacheEnable),
                               .clk(clk),
                               .rst(rst));
  Register_16 FsmCacheAddressReg(.clk(clk),
                                 .rst(rst),
                                 .In(NewFsmCacheAddress),
                                 .WriteEnable(CacheEnable),
                                 .Out(OldFsmCacheAddress));

  assign CacheDataIn = OldFsmBusy ? MemoryDataIn : PipelineDataIn;
  assign CacheAddressIn = OldFsmBusy ? OldFsmCacheAddress 
                                     : PipelineAddressIn;
  assign CacheWriteDataArray = OldFsmBusy ? OldFsmWriteDataArray 
                                          : CacheEnable & PipelineWriteEnable;

  Cache_2KB Cache(.clk(clk),
                  .rst(rst),
                  .DataIn(CacheDataIn),
                  .AddressIn(CacheAddressIn),
                  .WriteData(CacheWriteDataArray),
                  .WriteMetaData(OldFsmWriteMetaDataArray),
                  .DataOut(PipelineDataOut), // Outputs
                  .Miss(_Miss));

  assign Miss = CacheEnable & _Miss;

  cache_fill_FSM CacheController(.clk(clk), // Inputs
                                 .rst_n(~rst),
                                 .miss_detected(Miss),
                                 .miss_address(PipelineAddressIn),
                                 .fsm_busy(NewFsmBusy), // Outputs
                                 .write_data_array(NewFsmWriteDataArray),
                                 .write_tag_array(NewFsmWriteMetaDataArray),
                                 .memory_address(NewFsmMemoryAddress),
                                 .memory_request(NewFsmMemoryRequest),
                                 .cache_address(NewFsmCacheAddress));

  assign Stall = Miss | NewFsmBusy;
  assign MemoryRequest = NewFsmMemoryRequest;
  assign MemoryAddressOut = NewFsmMemoryAddress;

endmodule