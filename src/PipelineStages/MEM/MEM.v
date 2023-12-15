// Memory pipeline stage module
// Author: Lilly Peralta, Kevin Kristensen
module MEM (input clk, // INPUTS
            input rst,
            input Mem_En,
            input Mem_Wr,
            input [3:0] OpcodeIn,
            input [3:0] WBOpcodeIn,
            input [3:0] SrcReg1,
            input [15:0] RegRead1,
            input [3:0] WB_RegWrite,
            input [15:0] WB_MemOut,
            input [15:0] ALUOut,
            input [15:0] MemData, // From memory
            input [15:0] MemAddress,
            input MemCacheWriteEnable,
            input MemStall,
            output [15:0] MemOut, // OUTPUTS
            output Stall,
            output [15:0] MemoryAddressOut,
            output MemoryRequest);

  wire MemToMemFwd, CacheStall, _MemoryRequest;
  wire [15:0] RegRead, _MemoryAddressOut;

  assign MemToMemFwd = (OpcodeIn == 4'b1001) & 
                       (WBOpcodeIn == 4'b1000) & 
                       (WB_RegWrite == SrcReg1);
  assign RegRead = MemToMemFwd ? WB_MemOut : RegRead1; // Forwarding

  DataMem DataMemory(.data_out(MemOut),
                     .data_in(RegRead),
                     .addr(ALUOut),
                     .enable(Mem_En),
                     .wr(Mem_Wr),
                     .clk(clk),
                     .rst(rst));

  CacheInterface MemoryCache(.clk(clk), // INPUTS
                             .rst(rst),
                             .PipelineDataIn(RegRead),
                             .PipelineAddressIn(ALUOut),
                             .MemoryDataIn(MemData),
                             .MemoryAddressIn(MemAddress),
                             .CacheWriteEnable(Mem_En | MemCacheWriteEnable),
                             .MemoryStall(MemStall),
                             .PipelineDataOut(MemOut), // OUTPUTS
                             .Stall(CacheStall),
                             .MemoryAddressOut(_MemoryAddressOut),
                             .MemoryRequest(_MemoryRequest));

assign MemoryAddressOut = _MemoryAddressOut;
assign MemoryRequest = _MemoryRequest;

endmodule