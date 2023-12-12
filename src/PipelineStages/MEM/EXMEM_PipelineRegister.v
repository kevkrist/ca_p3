// EX/MEM pipeline register
// author: Kevin Kristensen
module EXMEM_PipelineRegister(clk,
                              rst,
                              halt_In,
                              WriteEnable,
                              WReg_In,
                              Mem_EnIn,
                              MemWr_In,
                              RF_WrIn,
                              WB_SelectIn,
                              OpcodeIn,
                              ALUOut_In,
                              PC_In,
                              RegRead1_In,
                              SrcReg1_In,
                              halt_Out,
                              WReg_Out,
                              Mem_EnOut,
                              Mem_WrOut,
                              RF_WrOut,
                              OpcodeOut,
                              WB_SelectOut,
                              ALUOut_Out,
                              RegRead1_Out,
                              SrcReg1_Out,
                              PC_Out);

  input clk, rst, halt_In, WriteEnable, Mem_EnIn, MemWr_In, RF_WrIn;
  input [1:0] WB_SelectIn;
  input [3:0] WReg_In, OpcodeIn, SrcReg1_In;
  input[15:0] ALUOut_In, PC_In, RegRead1_In;
  output Mem_EnOut, Mem_WrOut, RF_WrOut, halt_Out;
  output [3:0] WReg_Out, OpcodeOut, SrcReg1_Out;
  output [1:0] WB_SelectOut;
  output [15:0] ALUOut_Out, PC_Out, RegRead1_Out;

  wire butthole;
  assign butthole = 1'b0;

  dff Mem_En(.q(Mem_EnOut), 
             .d(Mem_EnIn), 
             .wen(WriteEnable), 
             .clk(clk), 
             .rst(rst));
  dff Mem_Wr(.q(Mem_WrOut), 
             .d(MemWr_In), 
             .wen(WriteEnable), 
             .clk(clk), 
             .rst(rst));
  dff RF_Wr(.q(RF_WrOut), 
            .d(RF_WrIn), 
            .wen(WriteEnable), 
            .clk(clk), 
            .rst(rst));
  dff halt(.q(halt_Out), 
           .d(halt_In), 
           .wen(WriteEnable), 
           .clk(clk), 
           .rst(rst));

  
  // WB_Select, 0 = ALUresult, 1=MemOut, default = PC
  Register_2 WB_Select(.clk(clk), 
                       .rst(rst), 
                       .In(WB_SelectIn), 
                       .WriteEnable(WriteEnable), 
                       .Out(WB_SelectOut));
  
  // what register to write to
  Register_4 WReg(.clk(clk), 
                  .rst(rst), 
                  .In(WReg_In), 
                  .WriteEnable(WriteEnable), 
                  .Out(WReg_Out));

  Register_4 Opcode(.clk(clk), 
                    .rst(rst), 
                    .In(OpcodeIn), 
                    .WriteEnable(WriteEnable), 
                    .Out(OpcodeOut)); 

  // ALU output
  Register_16 ALUOut(.clk(clk), 
                     .rst(rst), 
                     .In(ALUOut_In), 
                     .WriteEnable(WriteEnable), 
                     .Out(ALUOut_Out));
  Register_16 PC(.clk(clk),
                 .rst(rst),
                 .In(PC_In),
                 .WriteEnable(WriteEnable),
                 .Out(PC_Out));
  Register_16 RegRead1(.clk(clk),
                       .rst(rst),
                       .In(RegRead1_In),
                       .WriteEnable(WriteEnable),
                       .Out(RegRead1_Out));
  Register_4 SrcReg1(.clk(clk),
                     .rst(rst),
                     .WriteEnable(WriteEnable),
                     .In(SrcReg1_In),
                     .Out(SrcReg1_Out));

endmodule