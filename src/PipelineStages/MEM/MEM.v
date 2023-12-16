module MEM (clk,
            rst,
            Mem_En,
            Mem_Wr,
            MemStall, //stall signal from somewhere else?
            OpcodeIn,
            WBOpcodeIn,
            SrcReg1,
            RegRead1,
            WB_RegWrite,
            WB_MemOut,
            ALUOut,
            PipelineDataOut,
            MemOut,
            CacheStall);

  input clk, rst, Mem_En, Mem_Wr, MemStall;
  input [3:0] SrcReg1, OpcodeIn, WBOpcodeIn, WB_RegWrite;  
  input [15:0] ALUOut, RegRead1, WB_MemOut;
  output [15:0] MemOut, PipelineDataOut;
  output CacheStall;

//Internal wires
  wire MemToMemFwd;
  wire [15:0] RegRead, i_cache_address, d_cache_address, mem_request_address;
  wire MemoryRequest, mem_ready, i_cache_request, d_cache_request;
  wire i_cache_grant, d_cache_grant;
  wire i_cache_stall, d_cache_stall;

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


  // assign i_cache_request = //how do we assign these?
  // assign d_cache_request = 
  // assign i_cache_address = 
  // assign d_cache_address = 

  CacheMemoryInterface(.clk(clk),
                        .rst(rst),
                        .i_cache_request(i_cache_request),
                        .i_cache_address(i_cache_address),
                        .d_cache_request(d_cache_request),
                        .mem_ready(mem_ready),
                        .i_cache_grant(i_cache_grant),
                        .i_cache_stall(i_cache_stall),
                        .d_cache_grant(d_cache_grant),
                        .d_cache_stall(d_cache_stall),
                        .mem_address_out(MemOut),
                        .mem_request(MemoryRequest));


 CacheInterface(.clk(clk),
                .rst(rst),
                .PipelineDataIn(RegRead),               // difference between pipeline data in 
                .PipelineAddressIn(mem_request_address), //and memory data in?
                .MemoryDataIn(RegRead),
                .MemoryAddressIn(MemOut),
                .CacheWriteEnable(Mem_Wr),
                .MemStall(MemStall),
                .PipelineDataOut(PipelineDataOut),
                .Stall(CacheStall),
                .MemoryAddressOut(MemOut),
                .MemoryRequest(MemoryRequest));

endmodule