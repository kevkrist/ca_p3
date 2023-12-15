module MEM (clk,
            rst,
            Mem_En,
            Mem_Wr,
            MemStall,
            OpcodeIn,
            WBOpcodeIn,
            SrcReg1,
            RegRead1,
            WB_RegWrite,
            WB_MemOut,
            ALUOut,
            PipelineDataOut,
            MemOut,
            CacheStall,
            MemoryRequest);

  input clk, rst, Mem_En, Mem_Wr, MemStall;
  input [3:0] SrcReg1, OpcodeIn, WBOpcodeIn, WB_RegWrite;  
  input [15:0] ALUOut, RegRead1, WB_MemOut;
  output [15:0] MemOut, PipelineDataOut;
  output CacheStall, MemoryRequest;

  wire MemToMemFwd;
  wire [15:0] RegRead;

  assign MemToMemFwd = (OpcodeIn == 4'b1001) & 
                       (WBOpcodeIn == 4'b1000) & 
                       (WB_RegWrite == SrcReg1);
  assign RegRead = MemToMemFwd ? WB_MemOut : RegRead1; // Forwarding

/**
  DataMem DataMemory(.data_out(MemOut),
                     .data_in(RegRead),
                     .addr(ALUOut),
                     .enable(Mem_En),
                     .wr(Mem_Wr),
                     .clk(clk),
                     .rst(rst));
                     **/

 CacheInterface(.clk(clk),
                .rst(rst),
                .PipelineDataIn(PipelineDataIn),
                .PipelineAddressIn(PipelineDataOut),
                .MemoryDataIn(RegRead),
                .MemoryAddressIn(ALUOut),
                .CacheWriteEnable(Mem_Wr),
                .MemStall(MemStall),
                .PipelineDataOut(PipelineDataOut),
                .Stall(CacheStall),
                .MemoryAddressOut(MemOut),
                .MemoryRequest(MemoryRequest));

endmodule