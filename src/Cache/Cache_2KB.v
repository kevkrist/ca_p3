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

  wire Way0Hit, Way1Hit, DWriteEnable0, DWriteEnable1;
  wire [2:0] WordOffset;
  wire [5:0] TagIn, Tag0, Tag1, BlockIndex;
  reg [63:0] BlockEnable;
  reg [7:0] WordEnable;
  wire [7:0] MetaDataIn, MetaData0, MetaData1;
  wire [15:0] DataOut0, DataOut1;

  // Get block index, word offset
  assign WordOffset = AddressIn[3:1];
  assign BlockIndex = AddressIn[9:4];
  assign TagIn = AddressIn[15:10];
  assign MetaDataIn = {1'b0, 1'b1, TagIn};

  // Gross decoders to set one-hot block and word indices
  always @(WordOffset) begin
    WordEnable = {8{1'b0}};
    case(WordOffset)
      0: WordEnable[0] = 1'b1;
      1: WordEnable[1] = 1'b1;
      2: WordEnable[2] = 1'b1;
      3: WordEnable[3] = 1'b1;
      4: WordEnable[4] = 1'b1;
      5: WordEnable[5] = 1'b1;
      6: WordEnable[6] = 1'b1;
      7: WordEnable[7] = 1'b1;
    endcase
  end
  always @(BlockIndex) begin
    BlockEnable = {64{1'b0}};
    case(BlockIndex)
      0: BlockEnable[0] = 1'b1;
      1: BlockEnable[1] = 1'b1;
      2: BlockEnable[2] = 1'b1;
      3: BlockEnable[3] = 1'b1;
      4: BlockEnable[4] = 1'b1;
      5: BlockEnable[5] = 1'b1;
      6: BlockEnable[6] = 1'b1;
      7: BlockEnable[7] = 1'b1;
      8: BlockEnable[8] = 1'b1;
      9: BlockEnable[9] = 1'b1;
      10: BlockEnable[10] = 1'b1;
      11: BlockEnable[11] = 1'b1;
      12: BlockEnable[12] = 1'b1;
      13: BlockEnable[13] = 1'b1;
      14: BlockEnable[14] = 1'b1;
      15: BlockEnable[15] = 1'b1;
      16: BlockEnable[16] = 1'b1;
      17: BlockEnable[17] = 1'b1;
      18: BlockEnable[18] = 1'b1;
      19: BlockEnable[19] = 1'b1;
      20: BlockEnable[20] = 1'b1;
      21: BlockEnable[21] = 1'b1;
      22: BlockEnable[22] = 1'b1;
      23: BlockEnable[23] = 1'b1;
      24: BlockEnable[24] = 1'b1;
      25: BlockEnable[25] = 1'b1;
      26: BlockEnable[26] = 1'b1;
      27: BlockEnable[27] = 1'b1;
      28: BlockEnable[28] = 1'b1;
      29: BlockEnable[29] = 1'b1;
      30: BlockEnable[30] = 1'b1;
      31: BlockEnable[31] = 1'b1;
      32: BlockEnable[32] = 1'b1;
      33: BlockEnable[33] = 1'b1;
      34: BlockEnable[34] = 1'b1;
      35: BlockEnable[35] = 1'b1;
      36: BlockEnable[36] = 1'b1;
      37: BlockEnable[37] = 1'b1;
      38: BlockEnable[38] = 1'b1;
      39: BlockEnable[39] = 1'b1;
      40: BlockEnable[40] = 1'b1;
      41: BlockEnable[41] = 1'b1;
      42: BlockEnable[42] = 1'b1;
      43: BlockEnable[43] = 1'b1;
      44: BlockEnable[44] = 1'b1;
      45: BlockEnable[45] = 1'b1;
      46: BlockEnable[46] = 1'b1;
      47: BlockEnable[47] = 1'b1;
      48: BlockEnable[48] = 1'b1;
      49: BlockEnable[49] = 1'b1;
      50: BlockEnable[50] = 1'b1;
      51: BlockEnable[51] = 1'b1;
      52: BlockEnable[52] = 1'b1;
      53: BlockEnable[53] = 1'b1;
      54: BlockEnable[54] = 1'b1;
      55: BlockEnable[55] = 1'b1;
      56: BlockEnable[56] = 1'b1;
      57: BlockEnable[57] = 1'b1;
      58: BlockEnable[58] = 1'b1;
      59: BlockEnable[59] = 1'b1;
      60: BlockEnable[60] = 1'b1;
      61: BlockEnable[61] = 1'b1;
      62: BlockEnable[62] = 1'b1;
      63: BlockEnable[63] = 1'b1;
    endcase
  end

  MetaDataArray MDA(.clk(clk),
                    .rst(rst),
                    .DataIn(MetaDataIn),
                    .Write0(WriteMetaData),
                    .Write1(1'b0),
                    .BlockEnable(BlockEnable),
                    .DataOut0(MetaData0),
                    .DataOut1(MetaData1));

  // Determine if there is a cache miss
  assign Tag0 = MetaData0[5:0];
  assign Tag1 = MetaData1[5:0];
  assign Way0Hit = WriteMetaData ? 1'b0 : (Tag0 == TagIn) & MetaData0[6];
  assign Way1Hit = (Tag1 == TagIn) & MetaData1[6];
  assign Miss = ~(Way1Hit | Way0Hit);
  assign DWriteEnable0 = WriteData & ~Way1Hit;
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