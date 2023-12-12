// 2KB cache
// 16B blocks, 128 lines, 2-way set-associative (64 sets)
// author: Kevin Kristensen
module Cache_2KB(input clk,
                 input rst,
                 input[15:0] DataIn,
                 input[15:0] AddressIn,
                 input WriteEnable,
                 output[15:0] DataOut,
                 output Miss);
  
  wire [2:0] WordOffset
  wire [6:0] BlockIndex1, BlockIndex2;
  wire [127:0] BlockEnable1;
  wire [7:0] WordEnable;

  // Get block index
  assign WordOffset = AddressIn[3:1];
  assign BlockIndex1 = {AddressIn[10:4], 1'b0};
  assign BlockEnable1 = {128{1'b0}};
  assign BlockEnable1[BlockIndex1] = 1'b1; 
  assign WordEnable = {7{1'b0}};

  DataArray DA(.clk(clk), 
               .rst(rst), 
               .DataIn(DataIn), 
               .Write(WriteEnable), 
               .BlockEnable(), 
               .WordEnable(), 
               .DataOut(DataOut));

  MetaDataArray MDA(.clk(clk),
                    .rst(rst),
                    .DataIn(DataIn),
                    .Write(WriteEnable),
                    .BlockEnable(),
                    .DataOut());


endmodule