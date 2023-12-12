// MEMWB pipeline register
module MEMWB_PipelineRegister(clk, 
                              rst,
                              WriteEnable,
                              halt_In, 
                              WReg_In, 
                              RegWrite_In,
                              Mem_DataIn,
                              WB_SelectIn,
                              OpcodeIn,
                              PCIn,
                              ALUOut_In,
                              halt_Out,
                              WReg_Out,
                              RegWrite_Out,
                              Mem_DataOut,
                              WB_SelectOut,
                              OpcodeOut,
                              PCOut,
                              ALUOut_Out);

  input clk, halt_In, rst, WriteEnable, RegWrite_In;
  input [15:0] Mem_DataIn, PCIn, ALUOut_In;
  input [1:0] WB_SelectIn;
  input [3:0] WReg_In, OpcodeIn;
  output RegWrite_Out, halt_Out;
  output [3:0] WReg_Out, OpcodeOut;
  output [1:0] WB_SelectOut;
  output [15:0] Mem_DataOut, PCOut, ALUOut_Out;

  dff regwrite(.q(RegWrite_Out), 
               .d(RegWrite_In), 
               .wen(WriteEnable), 
               .clk(clk), 
               .rst(rst));
  dff halt(.q(halt_Out), .d(halt_In), .wen(WriteEnable), .clk(clk), .rst(rst));

  Register_2 WB_Select(.clk(clk), 
                       .rst(rst), 
                       .In(WB_SelectIn), 
                       .WriteEnable(WriteEnable), 
                       .Out(WB_SelectOut));

  Register_4 WReg(.clk(clk), 
                  .rst(rst), 
                  .In(WReg_In), 
                  .WriteEnable(WriteEnable), 
                  .Out(WReg_Out));

  Register_16 MemData(.clk(clk), 
                      .rst(rst), 
                      .In(Mem_DataIn), 
                      .WriteEnable(WriteEnable), 
                      .Out(Mem_DataOut));

  Register_4 Opcode(.clk(clk),
                    .rst(rst),
                    .In(OpcodeIn),
                    .WriteEnable(WriteEnable),
                    .Out(OpcodeOut));

  Register_16 PC(.clk(clk),
                 .rst(rst),
                 .In(PCIn),
                 .WriteEnable(WriteEnable),
                 .Out(PCOut));

  Register_16 ALUOut(.clk(clk),
                     .rst(rst),
                     .In(ALUOut_In),
                     .WriteEnable(WriteEnable),
                     .Out(ALUOut_Out));

endmodule