/*
TODO:
  - Instantiate data hazard unit (can insert stalls)
Notes:
  - For stall/flush, noop is inserted into ID/EX pipeline register 
    (handled in the IDEXPipeline register) (DONE)
  - For stall, also assert and have IF handle freezing the PC; don't update
    state of IF/ID pipeline register by deasserting the write control signal
    (in the top-level cpu file) (DONE)
  - PC must be passed directly from IF/ID to ID/EX (in top-level cpu file)
    (DONE)
*/
// Module for the instruction decode pipeline stage
// author: Kevin Kristensen
// NOTE: RegWrite refers to the 4-bit register number of the register to which
//       to write.
module ID(// INPUTS
          clk,
          rst,
          Instruction, // These 3 inputs are from IFID pipeline register
          Stall,
          PC,
          Flag, // The contents of the flag register
          WB_RegWrite, // These 3 inputs are outputs of WB
          WB_WriteData,
          WB_RF_Wr, 
          IDEX_FlagWrIn, // These 4 inputs are from IDEX pipeline register
          IDEX_RegWriteIn,
          IDEX_RF_WrIn,
          IDEX_OpcodeIn,
          EXMEM_RegWrite, // These 2 inputs are from EXMEM pipeline register
          EXMEM_RF_Wr,
          // OUTPUTS
          IDEX_Mem_En, // These 8 outputs are for IDEX pipeline register
          IDEX_Mem_Wr,
          IDEX_RF_Wr,
          IDEX_WB_Select,
          IDEX_Flag_Wr,
          IDEX_RegRead1,
          IDEX_RegRead2,
          IDEX_RegWrite,
          IDEX_Imm,
          IDEX_Opcode,
          ID_Noop,
          IDEX_SrcReg1,
          IFID_Stall, // This output is for IFID pipeline register
          IF_PCDisrupt, // These 3 outputs are sent to the IF stage
          IF_Stall,
          IF_PCBranch,
          XtoXforward_En,
          MtoXforward_En,
          XX_Reg1,
          XX_Reg2,
          MX_Reg1,
          MX_Reg2);

  input clk, rst, WB_RF_Wr, IDEX_FlagWrIn, IDEX_RF_WrIn, EXMEM_RF_Wr, Stall;
  input [2:0] Flag;
  input [3:0] WB_RegWrite, IDEX_RegWriteIn, EXMEM_RegWrite, IDEX_OpcodeIn;
  input [15:0] Instruction, WB_WriteData, PC;
  output IDEX_Mem_En, 
         IDEX_Mem_Wr, 
         IDEX_RF_Wr, 
         IDEX_Flag_Wr,
         IFID_Stall, 
         IF_PCDisrupt, 
         IF_Stall,
         ID_Noop,
         XtoXforward_En,
         MtoXforward_En,
         XX_Reg1,
         XX_Reg2,
         MX_Reg1,
         MX_Reg2;
  output [1:0] IDEX_WB_Select;
  output [3:0] IDEX_RegWrite, IDEX_Opcode, IDEX_SrcReg1;
  output [7:0] IDEX_Imm;
  output [15:0] IDEX_RegRead1, IDEX_RegRead2, IF_PCBranch;

  wire _Use_Top,
       _Stall, 
       _DStall, 
       _PCDisrupt, 
       Dummy, 
       _Noop, 
       __Stall, 
       _XtoXforward_En;
  wire [3:0] _RegWrite, SrcReg1, SrcReg2;
  wire [15:0] _RegRead1, _RegRead2, __RegRead1, _PC, _PC_2;

  assign _RegWrite = Instruction[11:8];
  assign IDEX_RegWrite = Instruction[11:8];
  assign IDEX_Imm = Instruction[7:0];
  assign IDEX_Opcode = Instruction[15:12];
  Adder_16bit Add2(.Sum(_PC_2),
                   .Overflow(Dummy),
                   .A(PC),
                   .B(16'h0002),
                   .Sub(1'b0));

  CPU_control Ctrl(.opc(Instruction[15:12]),
                   .Br(Br),
                   .Mem_En(IDEX_Mem_En),
                   .Mem_Wr(IDEX_Mem_Wr),
                   .RF_Wr(IDEX_RF_Wr),
                   .WB_Select(IDEX_WB_Select),
                   .Flag_Wr(IDEX_Flag_Wr),
                   .Use_Top(_Use_Top));
  // If LLB/LHB, make first register read from bits [11:8]
  // (SrcReg2 ignored in this case)
  // If SW/LW, make second register read from bits [7:4]
  assign SrcReg1 = (Instruction[15:14] === 2'b10) ? Instruction[11:8] 
                                                  : Instruction[7:4];
  assign SrcReg2 = (Instruction[15:14] === 2'b10) ? Instruction[7:4]
                                                  : Instruction[3:0];

  RegisterFile RF(.clk(clk),
                  .rst(rst),
                  .SrcReg1(SrcReg1),
                  .SrcReg2(SrcReg2),
                  .DstReg(WB_RegWrite),
                  .WriteReg(WB_RF_Wr),
                  .DstData(WB_WriteData),
                  .SrcData1(__RegRead1),
                  .SrcData2(_RegRead2));

  // Do RF bypassing
  assign _RegRead1 = (WB_RF_Wr & (SrcReg1 == WB_RegWrite)) ? WB_WriteData
                                                           : __RegRead1;
  assign IDEX_RegRead2 = (WB_RF_Wr & (SrcReg2 == WB_RegWrite)) ? WB_WriteData
                                                               : _RegRead2;
  assign IDEX_RegRead1 = _RegRead1;

  ControlHazard CtrlHaz(.TriggerControl(Br),
                        .BR(Instruction[13:12]), // Type of branch instruction
                        .IFID_RegWrite(_RegWrite),
                        .IDEX_Flag_Wr(IDEX_FlagWrIn),
                        .IDEX_RF_Wr(IDEX_RF_WrIn),
                        .IDEX_RegWrite(IDEX_RegWriteIn),
                        .EXMEM_RF_Wr(EXMEM_RF_Wr),
                        .EXMEM_RegWrite(EXMEM_RegWrite),
                        .Stall(_Stall),
                        .StallWrite(IFID_Stall));

  PC_Control PCCtrl(.Branch(Br),
                    .BranchType(Instruction[13:12]),
                    .C(Instruction[11:9]),
                    .I(Instruction[8:0]),
                    .F(Flag),
                    .Reg(_RegRead1),
                    .PC_In(PC),
                    .PC_Out(_PC));
  // Only disrupt normal PC flow when branch is taken and instruction is not HLT
  assign _PCDisrupt = ((_PC != _PC_2) & (_PC != PC)) ? 1'b1 
                                                     : 1'b0;

  DataHazard DataHaz(.IDEX_RF_WrIn(IDEX_RF_WrIn), // Inputs
                     .IDEX_RegWriteIn(IDEX_RegWriteIn),
                     .IDEX_Opcode(IDEX_OpcodeIn), // PREVIOUS opcode
                     .ID_Opcode(Instruction[15:12]), // CURRENT opcode
                     .ID_SrcReg1(SrcReg1),
                     .ID_SrcReg2(SrcReg2),
                     .EXMEM_RF_WrIn(EXMEM_RF_Wr),
                     .EXMEM_RegWriteIn(EXMEM_RegWrite),
                     .XtoXforward_En(_XtoXforward_En), // Outputs
                     .MtoXforward_En(MtoXforward_En),
                     .stall(_DStall),
                     .XX_Reg1(XX_Reg1),
                     .XX_Reg2(XX_Reg2),
                     .MX_Reg1(MX_Reg1),
                     .MX_Reg2(MX_Reg2));
  
  // Hacky handling of unknown values and other final output assignments
  assign __Stall = _Stall | Stall | _DStall;
  assign IF_Stall = (__Stall === 1'bx) ? 1'b0 : __Stall;
  assign IF_PCDisrupt = _PCDisrupt;
  assign IF_PCBranch = _PC;
  assign _Noop = (_Stall | Stall | _DStall | _PCDisrupt) ? 1'b1 : 1'b0;
  assign ID_Noop = (_Noop === 1'bx) ? 1'b0 : _Noop;
  assign IDEX_SrcReg1 = SrcReg1;
  assign XtoXforward_En = (_XtoXforward_En === 1'bx) ? 1'b0 : _XtoXforward_En;
  
endmodule