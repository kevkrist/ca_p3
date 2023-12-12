// IDEX pipeline register
// author: Kevin Kristensen
module IDEXPipelineRegister(clk,
                            rst,
                            WriteEnable,
                            HltIn,
                            RegRead1In,
                            RegRead2In,
                            RegWriteIn,
                            PCIn,
                            ImmIn,
                            OpcodeIn,
                            Flag_WrIn,
                            RF_WrIn,
                            Mem_EnIn,
                            Mem_WrIn,
                            WB_SelectIn,
                            SrcReg1In,
                            XtoXforward_EnIn,
                            MtoXforward_EnIn,
                            XX_Reg1In,
                            XX_Reg2In,
                            MX_Reg1In,
                            MX_Reg2In,
                            HltOut,
                            RegRead1Out,
                            RegRead2Out,
                            RegWriteOut,
                            PCOut,
                            ImmOut,
                            OpcodeOut,
                            Flag_WrOut,
                            RF_WrOut,
                            Mem_EnOut,
                            Mem_WrOut,
                            WB_SelectOut,
                            SrcReg1Out,
                            XtoXforward_EnOut,
                            MtoXforward_EnOut,
                            XX_Reg1Out,
                            XX_Reg2Out,
                            MX_Reg1Out,
                            MX_Reg2Out);

  input clk, 
        rst, 
        WriteEnable,
        Flag_WrIn, 
        RF_WrIn, 
        Mem_EnIn, 
        Mem_WrIn, 
        HltIn,
        XtoXforward_EnIn,
        MtoXforward_EnIn,
        XX_Reg1In,
        XX_Reg2In,
        MX_Reg1In,
        MX_Reg2In;
  input [1:0] WB_SelectIn;
  input [3:0] OpcodeIn, RegWriteIn, SrcReg1In;
  input [7:0] ImmIn;
  input [15:0] RegRead1In, RegRead2In, PCIn;

  inout [15:0] RegRead1Out, RegRead2Out, PCOut;
  inout [7:0] ImmOut;
  inout [3:0] OpcodeOut, RegWriteOut, SrcReg1Out;
  inout [1:0] WB_SelectOut;
  inout Flag_WrOut, 
        RF_WrOut, 
        Mem_EnOut, 
        Mem_WrOut,
        HltOut, 
        XtoXforward_EnOut, 
        MtoXforward_EnOut,
        XX_Reg1Out,
        XX_Reg2Out,
        MX_Reg1Out,
        MX_Reg2Out;

  Register_16 RegRead1(.clk(clk), 
                       .rst(rst), 
                       .In(RegRead1In), 
                       .WriteEnable(WriteEnable), 
                       .Out(RegRead1Out));
  Register_16 RegRead2(.clk(clk), 
                       .rst(rst), 
                       .In(RegRead2In), 
                       .WriteEnable(WriteEnable), 
                       .Out(RegRead2Out));
  // RegWrite holds the value of the register to write to, NOT the data to 
  // write into it.
  Register_4 RegWrite(.clk(clk), 
                      .rst(rst), 
                      .In(RegWriteIn), 
                      .WriteEnable(WriteEnable), 
                      .Out(RegWriteOut));
  Register_4 SrcReg1(.clk(clk),
                     .rst(rst),
                     .In(SrcReg1In),
                     .WriteEnable(WriteEnable),
                     .Out(SrcReg1Out));
  Register_16 PC(.clk(clk), 
                 .rst(rst), 
                 .In(PCIn), 
                 .WriteEnable(WriteEnable), 
                 .Out(PCOut));
  Register_8 Immediate(.clk(clk), 
                       .rst(rst), 
                       .In(ImmIn), 
                       .WriteEnable(WriteEnable), 
                       .Out(ImmOut));
  Register_4 Opcode(.clk(clk), 
                    .rst(rst), 
                    .In(OpcodeIn), 
                    .WriteEnable(WriteEnable), 
                    .Out(OpcodeOut));
  Register_2 WB_Select(.clk(clk), 
                       .rst(rst), 
                       .In(WB_SelectIn), 
                       .WriteEnable(WriteEnable), 
                       .Out(WB_SelectOut));

  dff Flag_Wr(.q(Flag_WrOut),
              .d(Flag_WrIn),
              .wen(WriteEnable),
              .clk(clk),
              .rst(rst));
  dff RF_Wr(.q(RF_WrOut),
            .d(RF_WrIn),
            .wen(WriteEnable),
            .clk(clk),
            .rst(rst));
  dff Mem_En(.q(Mem_EnOut),
             .d(Mem_EnIn),
             .wen(WriteEnable),
             .clk(clk),
             .rst(rst));
  dff Mem_Wr(.q(Mem_WrOut),
             .d(Mem_WrIn),
             .wen(WriteEnable),
             .clk(clk),
             .rst(rst));
  dff Hlt(.q(HltOut),
          .d(HltIn),
          .wen(WriteEnable),
          .clk(clk),
          .rst(rst));
  dff XtoXforward_En(.q(XtoXforward_EnOut),
                     .d(XtoXforward_EnIn),
                     .wen(WriteEnable),
                     .clk(clk),
                     .rst(rst));
  dff MtoXforward_En(.q(MtoXforward_EnOut),
                     .d(MtoXforward_EnIn),
                     .wen(WriteEnable),
                     .clk(clk),
                     .rst(rst));
  dff XX_Reg1(.q(XX_Reg1Out), 
              .d(XX_Reg1In), 
              .wen(WriteEnable), 
              .clk(clk), 
              .rst(rst));
  dff XX_Reg2(.q(XX_Reg2Out), 
             .d(XX_Reg2In), 
             .wen(WriteEnable), 
             .clk(clk), 
             .rst(rst));
  dff MX_Reg1(.q(MX_Reg1Out), 
              .d(MX_Reg1In), 
              .wen(WriteEnable), 
              .clk(clk), 
              .rst(rst));
  dff MX_Reg2(.q(MX_Reg2Out), 
              .d(MX_Reg2In), 
              .wen(WriteEnable), 
              .clk(clk), 
              .rst(rst));
endmodule