// ALU
// Reg1 selected by bits [7:4]
// Reg2 selected by bits [3:0]
//   EXCEPT for LLB/LHB and SW, in which case: 
//     Reg1 selected by bits [11:8]
//     Reg2 selected by bits [7:4] (only used for SW)
// Imm from bits [7:0]
// author: Kevin Kristensen
module Alu(Output, Flag, Reg1, Reg2, Imm, Opcode, PC);
  output reg [15:0] Output;
  output reg [2:0]  Flag; // Flag register, format: {N, V, Z}
  input [15:0] Reg1, Reg2, PC;
  input [7:0] Imm;
  input [3:0] Opcode; // Passing opcode directly to ALU for simplicity

  wire [15:0] Sum, Shift, Red, SubSum, Mem, SEShift_4, PC_2;
  wire V, DummyOverflow1, DummyOverflow2, DummyOverflow3;

  assign SEShift_4 = {{11{Imm[3]}}, Imm[3:0], 1'b0};

  // Instantiate modules
  Adder_16bit Add(.Sum(Sum), 
                  .Overflow(V), 
                  .A(Reg1), 
                  .B(Reg2), 
                  .Sub(Opcode[0]));
  Shifter Shift1(.ShiftOut(Shift), 
                 .ShiftIn(Reg1), 
                 .ShiftVal(Imm[3:0]), 
                 .Mode(Opcode[1:0]));
  RED Reduce(.rs(Reg1), .rt(Reg2), .rd(Red));
  PSWAdder SWAdd(.SubSum(SubSum),
                 .Overflow(DummyOverflow1),
                 .A(Reg1),
                 .B(Reg2));
  Adder_16bit MemOp(.Sum(Mem),
                    .Overflow(DummyOverflow2),
                    .A(Reg2 & 16'hfffe),
                    .B(SEShift_4),
                    .Sub(1'b0));
  Adder_16bit PCS(.Sum(PC_2),
                  .Overflow(DummyOverflow3),
                  .A(PC),
                  .B(16'h0002),
                  .Sub(1'b0));

  always @(Opcode, Sum, Reg1, Reg2, Shift, SubSum, Mem, Imm) begin
    case(Opcode)
      0, 1: begin // ADD, SUB
        Output = Sum;
        Flag = {Output[15], V, ~(| Output)};
      end
      2: begin // XOR
        Output = Reg1 ^ Reg2;
        Flag[0] = ~(| Output);
      end
      3: begin // RED
        Output = Red;
        Flag[0] = ~(| Output);
      end
      4, 5, 6: begin // SLL, SRA, ROR
        Output = Shift;
        Flag[0] = ~(| Output);
      end
      7: begin // PADDSB
        Output = SubSum;
      end
      8, 9: begin // LW, SW
        Output = Mem;
      end
      10: begin // LLB
        Output = {Reg1[15:8], Imm};
      end
      11: begin // LHB
        Output = {Imm, Reg1[7:0]};
      end
      14: begin // PCS
        Output = PC_2;
      end 
      default: Output = {15{1'b0}}; // All control functions handled by PC Ctrl
    endcase
  end

endmodule