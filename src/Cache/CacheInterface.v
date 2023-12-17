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
       NewFsmWriteDataArray,
       NewFsmWriteMetaDataArray,
       CacheWriteDataArray,
       CacheWriteMetaDataArray,
       _Miss,
       Miss;
  wire [15:0] NewFsmCacheAddress,
              NewFsmMemoryAddress,
              CacheDataIn,
              CacheAddressIn;

  dff FsmBusyReg(.q(OldFsmBusy),
                 .d(NewFsmBusy),
                 .wen(CacheEnable),
                 .clk(clk),
                 .rst(rst));

  assign CacheDataIn = OldFsmBusy ? MemoryDataIn : PipelineDataIn;
  assign CacheAddressIn = OldFsmBusy ? NewFsmCacheAddress 
                                     : PipelineAddressIn;
  assign CacheWriteDataArray = OldFsmBusy ? NewFsmWriteDataArray 
                                          : CacheEnable & PipelineWriteEnable;
  assign CacheWriteMetaDataArray = OldFsmBusy ? NewFsmWriteMetaDataArray
                                              : 1'b0;

  Cache_2KB Cache(.clk(clk),
                  .rst(rst),
                  .DataIn(CacheDataIn),
                  .AddressIn(CacheAddressIn),
                  .WriteData(CacheWriteDataArray),
                  .WriteMetaData(CacheWriteMetaDataArray),
                  .DataOut(PipelineDataOut), // Outputs
                  .Miss(_Miss));

  assign Miss = CacheEnable & _Miss;

  cache_fill_FSM CacheController(.clk(clk), // Inputs
                                 .rst_n(~rst),
                                 .miss_detected(Miss),
                                 .miss_address(PipelineAddressIn),
                                 .memory_stall(MemoryStall),
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