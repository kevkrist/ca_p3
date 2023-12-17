// Execute stage module
// Author: Garret Johnson, Kevin Kristensen
module Execute (
  input [7:0] Imm, // Immediate field
  input [3:0] Opcode, // Current opcode
  input [15:0] PC, // Current PC
  input [3:0] WB_Opcode, // Opcode from previous mem stage
  input [15:0] RegRead1, // Reg 1 to read
  input [15:0] RegRead2, // Reg 2 to read
  input MtoXforward_En, // Mem to Ex forwarding enable
  input XtoXforward_En, // Ex to Ex forwaring enable
  input [15:0] MtoXforward_Data_Mem, // WB_MemOut
  input [15:0] MtoXforward_Data_ALU, // WB_ALUOut
  input [15:0] XtoXforward_Data, // EXMEM_PipelineRegister's WriteData_Out
  input XX_Reg1,
  input XX_Reg2, 
  input MX_Reg1,
  input MX_Reg2,
  output [2:0] Flag, // flag register signals
  output [15:0] ALUOut // output data
);
  // Internal signals
  wire [15:0] ALUin1, ALUin2, MtoXforward_Data;

  assign MtoXforward_Data = (WB_Opcode == 4'b1000) ? MtoXforward_Data_Mem
                                                   : MtoXforward_Data_ALU;
  
  // Muxes (EX-EX forwarding has higher priority)
  assign ALUin1 = (XtoXforward_En & XX_Reg1) ? XtoXforward_Data 
                  : (MtoXforward_En & MX_Reg1) ? MtoXforward_Data : RegRead1;
  assign ALUin2 = (XtoXforward_En & XX_Reg2) ? XtoXforward_Data 
                  : (MtoXforward_En & MX_Reg2) ? MtoXforward_Data : RegRead2;
  
  // Instantiate ALU
  Alu ALU(.Output(ALUOut), 
          .Flag(Flag), 
          .Reg1(ALUin1), 
          .Reg2(ALUin2), 
          .Imm(Imm), 
          .Opcode(Opcode),
          .PC(PC));

endmodule