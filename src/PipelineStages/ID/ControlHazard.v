// Control hazard detection unit
// author: Kevin Kristensen
module ControlHazard(TriggerControl,
                     BR, // Branch type (including PCS)
                     IFID_RegWrite, // The register to write to
                     IDEX_Flag_Wr,
                     IDEX_RF_Wr,
                     IDEX_RegWrite, // The register to write to
                     EXMEM_RF_Wr,
                     EXMEM_RegWrite, // The register to write to
                     Stall,
                     StallWrite);

  input [3:0] IFID_RegWrite, IDEX_RegWrite, EXMEM_RegWrite;
  input [1:0] BR;
  input TriggerControl, IDEX_Flag_Wr, IDEX_RF_Wr, EXMEM_RF_Wr;
  output reg Stall, StallWrite;

  wire EXWriteReg, MEMWriteReg;
  assign EXWriteReg = (IDEX_RF_Wr & (IDEX_RegWrite == IFID_RegWrite))
                      ? 1'b1 : 1'b0; // Whether EX stage writes to register
                                     // holding address to which to branch
  assign MEMWriteReg = (EXMEM_RF_Wr & (EXMEM_RegWrite == IFID_RegWrite))
                       ? 1'b1 : 1'b0; // Whether MEM stage writes to register
                                      // holding address to which to branch

  always @(TriggerControl, 
           BR,
           EXWriteReg,
           MEMWriteReg, 
           IDEX_Flag_Wr) begin
    case(TriggerControl)
      1: begin
        case(BR)
          0: begin // Branch (B) instruction. Only hazard is if previous 
                   // instruction writes to flag register (1 stall)
            case(IDEX_Flag_Wr)
              1: begin
                Stall = 1'b1;
                StallWrite = 1'b0;
              end
              default: begin
                Stall = 1'b0;
                StallWrite = 1'b0;
              end
            endcase
          end
          1: begin // Branch register (BR) instruction. Hazards occur if 
                   // previous instruction writes to flag register (1 stall),
                   // writes to destination register (2 stalls), or the 
                   // instruction in MEM stage writes to destination register
                   // (1 stall)
            casex({EXWriteReg, MEMWriteReg, IDEX_Flag_Wr})
              3'b1??: begin // Stall 2 cycles
                Stall = 1'b1;
                StallWrite = 1'b1;
              end
              3'b01?: begin // Stall 1 cycle
                Stall = 1'b1;
                StallWrite = 1'b0;
              end
              3'b0?1: begin // Stall 1 cycle
                Stall = 1'b1;
                StallWrite = 1'b0;
              end
              default: begin // No hazard, so do not stall
                Stall = 1'b0;
                StallWrite = 1'b0;
              end
            endcase
          end
          default: begin // BR = X/Z or PCS, so do not stall
            Stall = 1'b0;
            StallWrite = 1'b0;
          end
        endcase
      end
      default: begin // TriggerControl = 0/X/Z, so control detection not needed
        Stall = 1'b0;
        StallWrite = 1'b0;
      end
    endcase
  end

endmodule