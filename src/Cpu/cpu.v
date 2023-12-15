// Top-level cpu module for project phase 2
// author: Kevin Kristensen
module cpu(clk, rst_n, hlt, pc);
  input clk, rst_n;
  output hlt;
  output [15:0] pc;

  // Instruction Fetch
  wire IF_hlt, IF_Stall, IF_PCDisrupt;
  wire [15:0] IF_PC, IF_PCBranch, IF_NextPC, IF_Instruction;

  Register_16 PC(.clk(clk), 
                 .rst(~rst_n), 
                 .WriteEnable(~IF_Stall),
                 .In(IF_NextPC),
                 .Out(IF_PC));

  dff IFStall(.q(IfCacheStallOut), 
              .d(IFCacheStall|MCacheStall), 
              .wen(1'b1), 
              .clk(clk), 
              .rst(rst));
  InstructionFetch Fetch(.clk(clk), // Inputs
                         .rst(~rst_n),
                         .PC(IF_PC),
                         .Stall(IF_Stall|IFCacheStallOut),
                         .PC_Disrupt(IF_PCDisrupt),
                         .PC_Branch(IF_PCBranch),
                         .Instruction(IF_Instruction), // Outputs
                         .NextPC(IF_NextPC),
                         .hlt(IF_hlt),
                         .CacheStall(IFCacheStall));
  // Instruction decode
  wire IFID_Stall, 
       ID_Stall,
       ID_Hlt,
       IDEX_Mem_En, 
       IDEX_Mem_Wr, 
       IDEX_FlagWr, 
       ID_Noop,
       _IDEX_RF_Wr,
       IDEX_RF_Wr,
       IDEX_MtoXforward_En,
       IDEX_XtoXforward_En,
       IDEX_XX_Reg1,
       IDEX_XX_Reg2,
       IDEX_MX_Reg1,
       IDEX_MX_Reg2,
       IDEX_Noop,
       EX_Flag_Wr,
       EX_RF_Wr,
       MEM_RF_Wr;
  wire [1:0] IDEX_WB_Select;
  wire [2:0] ID_Flag;
  wire [3:0] IDEX_RegWrite, 
             EX_RegWrite, 
             IDEX_Opcode, 
             IDEX_SrcReg1,
             EX_Opcode, 
             MEM_RegWrite;
  wire [7:0] IDEX_Imm;
  wire [15:0] ID_Instruction, 
              ID_PC, 
              IDEX_RegRead1, 
              IDEX_RegRead2;
  reg WB_RF_Wr;
  reg [3:0] WB_RegWrite;
  reg [15:0] WB_WriteData;


  IFIDPipelineRegister IFID(.clk(clk), // Inputs
                            .rst(~rst_n),
                            .HltIn(IF_hlt),
                            .InstructionIn(IF_Instruction),
                            .StallIn(IFID_Stall),
                            .NoopIn(ID_Noop),
                            .PCIn(IF_PC),
                            .WriteEnable(~IF_Stall),
                            .HltOut(ID_Hlt),
                            .InstructionOut(ID_Instruction),
                            .StallOut(ID_Stall),
                            .PCOut(ID_PC),
                            .NoopOut(IDEX_Noop));

  ID Decode(.clk(clk), // Inputs
            .rst(~rst_n),
            .Instruction(ID_Instruction),
            .Stall(ID_Stall),
            .PC(ID_PC),
            .Flag(ID_Flag),
            .WB_RegWrite(WB_RegWrite),
            .WB_WriteData(WB_WriteData),
            .WB_RF_Wr(WB_RF_Wr),
            .IDEX_FlagWrIn(EX_Flag_Wr),
            .IDEX_RegWriteIn(EX_RegWrite),
            .IDEX_RF_WrIn(EX_RF_Wr),
            .IDEX_OpcodeIn(EX_Opcode),
            .EXMEM_RegWrite(MEM_RegWrite),
            .EXMEM_RF_Wr(MEM_RF_Wr),
            .IDEX_Mem_En(IDEX_Mem_En), // Outputs
            .IDEX_Mem_Wr(IDEX_Mem_Wr),
            .IDEX_RF_Wr(_IDEX_RF_Wr),
            .IDEX_WB_Select(IDEX_WB_Select),
            .IDEX_Flag_Wr(IDEX_Flag_Wr),
            .IDEX_RegRead1(IDEX_RegRead1),
            .IDEX_RegRead2(IDEX_RegRead2),
            .IDEX_RegWrite(IDEX_RegWrite),
            .IDEX_Imm(IDEX_Imm),
            .IDEX_Opcode(IDEX_Opcode),
            .ID_Noop(ID_Noop),
            .IDEX_SrcReg1(IDEX_SrcReg1),
            .IFID_Stall(IFID_Stall), 
            .IF_PCDisrupt(IF_PCDisrupt), 
            .IF_Stall(IF_Stall),
            .IF_PCBranch(IF_PCBranch),
            .XtoXforward_En(IDEX_XtoXforward_En),
            .MtoXforward_En(IDEX_MtoXforward_En),
            .XX_Reg1(IDEX_XX_Reg1),
            .XX_Reg2(IDEX_XX_Reg2),
            .MX_Reg1(IDEX_MX_Reg1),
            .MX_Reg2(IDEX_MX_Reg2));
  // If noop is inserted, disable writing to the register file
  // (not strictly necessary, but makes the trace cleaner)
  assign IDEX_RF_Wr = IDEX_Noop ? 1'b0 : _IDEX_RF_Wr;

  // Execute
  wire EX_Mem_En, 
       EX_Mem_Wr, 
       EX_Hlt, 
       EX_XtoXforward_En,
       EX_MtoXforward_En,
       EX_XX_Reg1,
       EX_XX_Reg2,
       EX_MX_Reg1,
       EX_MX_Reg2;
  wire [1:0] EX_WB_Select;
  wire [2:0] EX_Flag;
  wire [3:0] EX_SrcReg1, WB_Opcode;
  wire [7:0] EX_Imm;
  wire [15:0] EX_RegRead1, 
              EX_RegRead2, 
              EX_PC, 
              EXMEM_ALUOut, 
              WB_MemOut,
              WB_ALUOut, 
              MEM_ALUOut;
  IDEXPipelineRegister IDEX(.clk(clk),
                            .rst(~rst_n),
                            .WriteEnable(1'b1),
                            .HltIn(ID_Hlt),
                            .RegRead1In(IDEX_RegRead1),
                            .RegRead2In(IDEX_RegRead2),
                            .RegWriteIn(IDEX_RegWrite),
                            .PCIn(ID_PC),
                            .ImmIn(IDEX_Imm),
                            .OpcodeIn(IDEX_Opcode),
                            .Flag_WrIn(IDEX_Flag_Wr),
                            .RF_WrIn(IDEX_RF_Wr),
                            .Mem_EnIn(IDEX_Mem_En),
                            .Mem_WrIn(IDEX_Mem_Wr),
                            .WB_SelectIn(IDEX_WB_Select),
                            .SrcReg1In(IDEX_SrcReg1),
                            .XtoXforward_EnIn(IDEX_XtoXforward_En),
                            .MtoXforward_EnIn(IDEX_MtoXforward_En),
                            .XX_Reg1In(IDEX_XX_Reg1),
                            .XX_Reg2In(IDEX_XX_Reg2),
                            .MX_Reg1In(IDEX_MX_Reg1),
                            .MX_Reg2In(IDEX_MX_Reg2),
                            .HltOut(EX_Hlt),
                            .RegRead1Out(EX_RegRead1),
                            .RegRead2Out(EX_RegRead2),
                            .RegWriteOut(EX_RegWrite),
                            .PCOut(EX_PC),
                            .ImmOut(EX_Imm),
                            .OpcodeOut(EX_Opcode),
                            .Flag_WrOut(EX_Flag_Wr),
                            .RF_WrOut(EX_RF_Wr),
                            .Mem_EnOut(EX_Mem_En),
                            .Mem_WrOut(EX_Mem_Wr),
                            .WB_SelectOut(EX_WB_Select),
                            .SrcReg1Out(EX_SrcReg1),
                            .XtoXforward_EnOut(EX_XtoXforward_En),
                            .MtoXforward_EnOut(EX_MtoXforward_En),
                            .XX_Reg1Out(EX_XX_Reg1),
                            .XX_Reg2Out(EX_XX_Reg2),
                            .MX_Reg1Out(EX_MX_Reg1),
                            .MX_Reg2Out(EX_MX_Reg2));
  Execute EX(.Imm(EX_Imm),
             .Opcode(EX_Opcode),
             .PC(EX_PC),
             .WB_Opcode(WB_Opcode),
             .RegRead1(EX_RegRead1),
             .RegRead2(EX_RegRead2),
             .MtoXforward_En(EX_MtoXforward_En),
             .XtoXforward_En(EX_XtoXforward_En),
             .MtoXforward_Data_Mem(WB_MemOut),
             .MtoXforward_Data_ALU(WB_ALUOut),
             .XtoXforward_Data(MEM_ALUOut),
             .XX_Reg1(EX_XX_Reg1),
             .XX_Reg2(EX_XX_Reg2),
             .MX_Reg1(EX_MX_Reg1),
             .MX_Reg2(EX_MX_Reg2),
             .Flag(EX_Flag),
             .ALUOut(EXMEM_ALUOut));
  Register_3 Flag(.clk(clk), 
                  .rst(~rst_n), 
                  .In(EX_Flag), 
                  .WriteEnable(EX_Flag_Wr), 
                  .Out(ID_Flag));

  // Memory
  wire MEM_Hlt, MEM_En, MEM_Wr;
  wire [1:0] MEM_WB_Select;
  wire [3:0] MEM_Opcode, MEM_SrcReg1;
  wire [15:0] MEM_RegRead1, MEM_PC, MEM_Out;
  EXMEM_PipelineRegister EXMEM(.clk(clk),
                               .rst(~rst_n),
                               .halt_In(EX_Hlt),
                               .WriteEnable(1'b1),
                               .WReg_In(EX_RegWrite),
                               .Mem_EnIn(EX_Mem_En),
                               .MemWr_In(EX_Mem_Wr),
                               .RF_WrIn(EX_RF_Wr),
                               .WB_SelectIn(EX_WB_Select),
                               .OpcodeIn(EX_Opcode),
                               .ALUOut_In(EXMEM_ALUOut),
                               .RegRead1_In(EX_RegRead1),
                               .SrcReg1_In(EX_SrcReg1),
                               .PC_In(EX_PC),
                               .halt_Out(MEM_Hlt),
                               .WReg_Out(MEM_RegWrite), // Reg to write to
                               .Mem_EnOut(MEM_En),
                               .Mem_WrOut(MEM_Wr),
                               .RF_WrOut(MEM_RF_Wr),
                               .OpcodeOut(MEM_Opcode),
                               .WB_SelectOut(MEM_WB_Select),
                               .ALUOut_Out(MEM_ALUOut),
                               .RegRead1_Out(MEM_RegRead1),
                               .SrcReg1_Out(MEM_SrcReg1),
                               .PC_Out(MEM_PC));

  MEM Memory(.clk(clk), // Inputs
             .rst(~rst_n),
             .Mem_En(MEM_En),
             .Mem_Wr(MEM_Wr),
             .OpcodeIn(MEM_Opcode),
             .WBOpcodeIn(WB_Opcode),
             .SrcReg1(MEM_SrcReg1),
             .RegRead1(MEM_RegRead1),
             .ALUOut(MEM_ALUOut),
             .WB_RegWrite(WB_RegWrite),
             .WB_MemOut(WB_MemOut),
             .MemOut(MEM_Out)); // Output

  // Write-back
  wire WB_Hlt, _WB_RF_Wr;
  wire [1:0] WB_WB_Select;
  wire [3:0] _WB_RegWrite;
  wire [15:0] WB_PC;
  MEMWB_PipelineRegister MEMWB(.clk(clk), 
                               .rst(~rst_n),
                               .halt_In(MEM_Hlt), 
                               .WriteEnable(1'b1), 
                               .WReg_In(MEM_RegWrite), 
                               .RegWrite_In(MEM_RF_Wr),
                               .Mem_DataIn(MEM_Out),
                               .WB_SelectIn(MEM_WB_Select),
                               .OpcodeIn(MEM_Opcode),
                               .PCIn(MEM_PC),
                               .ALUOut_In(MEM_ALUOut),
                               .halt_Out(WB_Hlt),  
                               .WReg_Out(_WB_RegWrite),  
                               .RegWrite_Out(_WB_RF_Wr),
                               .Mem_DataOut(WB_MemOut),
                               .WB_SelectOut(WB_WB_Select),
                               .OpcodeOut(WB_Opcode),
                               .PCOut(WB_PC),
                               .ALUOut_Out(WB_ALUOut));

  always @(WB_WB_Select, 
           WB_ALUOut, 
           WB_MemOut, 
           WB_PC, 
           _WB_RegWrite,
           _WB_RF_Wr) begin
    case(WB_WB_Select)
      0: begin
        WB_RegWrite = _WB_RegWrite;
        WB_RF_Wr = (WB_RegWrite == 4'h0) ? 1'b0 : _WB_RF_Wr;
        WB_WriteData = WB_ALUOut;
      end
      1: begin
        WB_RegWrite = _WB_RegWrite;
        WB_RF_Wr = (WB_RegWrite == 4'h0) ? 1'b0 : _WB_RF_Wr;
        WB_WriteData = WB_MemOut;
      end
      default: begin
        WB_RegWrite = _WB_RegWrite;
        WB_RF_Wr = (WB_RegWrite == 4'h0) ? 1'b0 : _WB_RF_Wr;
        WB_WriteData = WB_PC;
      end
    endcase
  end
  assign hlt = WB_Hlt;
  assign pc = WB_PC;

endmodule
