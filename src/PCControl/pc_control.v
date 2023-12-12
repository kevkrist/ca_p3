// PC control for branch immediate instruction.
// The Branch indicator is set whenever the top 2 opcode bits are 1
// We use the following mapping of the BranchType from the bottom 2 bits of
// the opcode for branch (11 in top 2 bits) instructions:
// case(BranchType)
//   0: branch (B)
//   1: branch register (BR)
//   2: PCS
//   3: halt HLT
// Overflow is ignored per https://piazza.com/class/llwvyozomiqbj/post/64
// author: Kevin Kristensen
module PC_Control(Branch, BranchType, C, I, F, Reg, PC_In, PC_Out);
  input Branch; // whether to do branching logic
  input[1:0] BranchType;
  input [2:0] C; // condition
  input [8:0] I; // immediate
  input [2:0] F; // flag register with {N, V, Z} layout
  input [15:0] Reg; // register value for BR (otherwise ignored)
  input [15:0] PC_In;
  output reg [15:0] PC_Out;

  wire [15:0] I_SignExtend, PC_2, PC_Imm, PC_Imm_Reg;
  wire Overflow;

  // Sign-extend the immediate to get 16-bit immediate
  assign I_SignExtend = {{6{I[8]}}, I, 1'b0};

  // Add 2 to PC_In
  Adder_16bit Add2(.Sum(PC_2), 
                   .Overflow(Overflow), 
                   .A(PC_In), 
                   .B(16'h0002),
                   .Sub(1'b0));

  // Add immediate to PC + 2
  Adder_16bit AddImm(.Sum(PC_Imm), 
                     .Overflow(Overflow), 
                     .A(PC_2), 
                     .B(I_SignExtend),
                     .Sub(1'b0));

  // For convenience, choose between PC_Imm and Reg
  assign PC_Imm_Reg = (BranchType == 0) ? PC_Imm : Reg;
  
  always @(Branch, BranchType, PC_2, PC_Imm_Reg, PC_In) begin
    case(Branch)
      0: begin
        PC_Out = PC_2; // no branch
      end
      1: begin // branch
          case(BranchType)
            0, 1: begin
              case(C)
                0: PC_Out = (F[0] == 0) ? PC_Imm_Reg : PC_2;
                1: PC_Out = (F[0] == 1) ? PC_Imm_Reg : PC_2;
                2: PC_Out = (F[0] == 0 & F[2] == 0) ? PC_Imm_Reg : PC_2;
                3: PC_Out = (F[2] == 1) ? PC_Imm_Reg : PC_2;
                4: PC_Out = (F[0] == 1 | (F[0] == 0 & F[2] == 0)) ? PC_Imm_Reg 
                                                                  : PC_2;
                5: PC_Out = (F[2] == 1 | F[0] == 1)? PC_Imm_Reg : PC_2;
                6: PC_Out = (F[1] == 1) ? PC_Imm_Reg : PC_2;
                7: PC_Out = PC_Imm_Reg; // unconditional
                default: PC_Out = PC_Imm_Reg; // default to unconditional
              endcase
            end
            2: PC_Out = PC_2; // PCS
            3: PC_Out = PC_In; // halt (HLT)
            default: PC_Out = PC_2; // default to PC + 2
          endcase
      end
      default: PC_Out = PC_2; // default to Branch == 0 (no branch), i.e. PC + 2
    endcase
  end

endmodule