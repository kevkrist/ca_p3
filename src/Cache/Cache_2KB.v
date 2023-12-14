// 2KB cache
// 16B blocks, 128 lines, 2-way set-associative (64 sets)
// Thus, an address is parsed into: 
//   tag (6 bits) | index (6 bits) | offset (4 bits)
// Metadata configuration is: LRU bit | valid bit | tag (6 bits)
// (for now, ignore LRU bit and evict way 0 on a miss)
// author: Kevin Kristensen
module Cache_2KB(input clk,
                 input rst,
                 input[15:0] DataIn,
                 input[15:0] AddressIn,
                 input WriteData,
                 input WriteMetaData,
                 output[15:0] DataOut,
                 output Miss);

  wire Way0Hit, Way1Hit, _Miss, DWriteEnable0, DWriteEnable1;
  wire [2:0] WordOffset
  wire [5:0] BlockIndex, TagIn, Tag0, Tag1;
  wire [63:0] BlockEnable;
  wire [7:0] WordEnable, MetaDataIn, MetaData0, MetaData1;
  wire [15:0] DataOut0, DataOut1;

  // Get block index, word offset
  assign WordOffset = AddressIn[3:1];
  assign BlockIndex = {AddressIn[9:4]};
  assign BlockEnable = {64{1'b0}};
  assign BlockEnable[BlockIndex] = 1'b1; 
  assign WordEnable = {8{1'b0}};
  assign WordEnable[WordOffset] = 1'b1;
  assign TagIn = AddressIn[15:10];
  assign MetaDataIn = {1'b0, 1'b1, TagIn};
  assign MDWriteEnable0 = (WayIn == 1'b0) & WriteMetaData;
  assign MDWriteEnable1 = (WayIn == 1'b1) & WriteMetaData;

  MetaDataArray MDA(.clk(clk),
                    .rst(rst),
                    .DataIn(MetaDataIn),
                    .Write0(WriteMetaData),
                    .Write1(1'b0),
                    .BlockEnable(BlockEnable),
                    .DataOut(MetaData0),
                    .DataOut(MetaData1));

  // Determine if there is a cache miss
  assign Tag0 = MetaData0[5:0];
  assign Tag1 = MetaData1[5:0];
  assign Way0Hit = (Tag0 == TagIn) & MetaData0[6];
  assign Way1Hit = (Tag1 == TagIn) & MetaData1[6];
  assign _Miss = ~(Way1Hit | Way0Hit);
  assign DWriteEnable0 = WriteData & Way0Hit;
  assign DWriteEnable1 = WriteData & Way1Hit;

  DataArray DA(.clk(clk), 
               .rst(rst), 
               .DataIn(DataIn), 
               .Write0(DWriteEnable0),
               .Write1(DWriteEnable1), 
               .BlockEnable(BlockEnable), 
               .WordEnable(WordEnable), 
               .DataOut0(DataOut0),
               .DataOut1(DataOut1));
  
  assign DataOut = (Way0Hit) ? DataOut0 :
                   (Way1Hit) ? DataOut1 : 16'h0000;

endmodule