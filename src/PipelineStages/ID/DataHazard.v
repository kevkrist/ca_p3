// Data hazard detection unit
// Author: Garret Johnson, Kevin Kristensen

module DataHazard (input IDEX_RF_WrIn,
                   input [3:0] IDEX_RegWriteIn,
                   input [3:0] IDEX_Opcode,
                   input [3:0] ID_Opcode,
                   input [3:0] ID_SrcReg1,
                   input [3:0] ID_SrcReg2,
                   input EXMEM_RF_WrIn,
                   input [3:0] EXMEM_RegWriteIn,
                   output XtoXforward_En,
                   output MtoXforward_En,
                   output stall,
                   output XX_Reg1,
                   output XX_Reg2,
                   output MX_Reg1,
                   output MX_Reg2);

  // Internal signals
  wire loadOp, use1, use2, use_either, load_to_use, mx1, mx2, mx_either;

  // Determine if EX-EX forwarding is needed, or load-to-use stall
  assign loadOp = (IDEX_Opcode == 4'b1000); // LW in EX stage?
  assign storeOp = (ID_Opcode == 4'b1001); // SW in ID stage?
  assign use1 = IDEX_RF_WrIn & (IDEX_RegWriteIn == ID_SrcReg1);
  assign use2 = IDEX_RF_WrIn & (IDEX_RegWriteIn == ID_SrcReg2);
  assign use_either = use1 | use2;
  // NOT load-to-use if current instruction is store, as it is
  // handled by MEM-MEM forwarding. 
  assign load_to_use = use_either & loadOp & ~storeOp;
  assign stall = load_to_use & ~storeOp;
  assign XtoXforward_En = use_either & ~loadOp;

  // Determine if MEM-EX forwarding is needed
  assign mx1 = EXMEM_RF_WrIn & (EXMEM_RegWriteIn == ID_SrcReg1);
  assign mx2 = EXMEM_RF_WrIn & (EXMEM_RegWriteIn == ID_SrcReg2); 
  assign mx_either = mx1 | mx2;
  assign MtoXforward_En = load_to_use | mx_either;

  // Determine registers to forward to
  assign XX_Reg1 = use1 & ~loadOp;
  assign XX_Reg2 = use2 & ~loadOp;
  assign MX_Reg1 = mx1 | (use1 & loadOp);
  assign MX_Reg2 = mx2 | (use2 & loadOp);

endmodule
