// Top-level verilog file, simulating a single-cycle CPU
// author: Kevin Kristensen
module cpu(clk, rst_n, hlt, pc);
  input clk, rst_n;
  output hlt;
  output [15:0] pc;
  
  reg[3:0] count;
  reg [15:0] WriteData;
  wire [15:0] OldPC, 
              NewPC, 
              Instruction, 
              DontCare, 
              RegRead1, 
              RegRead2,
              ALUOut,
              MemOut;
  wire [2:0] OldFlag, NewFlag;
  wire [3:0] SrcReg1, SrcReg2;
  wire [1:0] WB_Select;
  wire Br, Mem_En, Mem_Wr, RF_Wr, RF_En, Flag_Wr, Use_Top;

  assign DontCare = {16{1'b0}};

  /* Walk through pipeline */
  // 1: IF
  Register_16 PC(.clk(clk), 
                 .rst(~rst_n), 
                 .WriteEnable(1'b1),
                 .In(NewPC),
                 .Out(OldPC));
  InstructionMem InstructionMemory(.data_out(Instruction),
                                   .data_in(DontCare),
                                   .addr(OldPC),
                                   .enable(1'b1),
                                   .wr(1'b0),
                                   .clk(clk),
                                   .rst(~rst_n));
  assign hlt = (Instruction[15:12] == 4'hf) ? 1 : 0;

  // 2: ID
  // Gather control signals
  CPU_control Ctrl(.opc(Instruction[15:12]),
                   .Br(Br),
                   .Mem_En(Mem_En),
                   .Mem_Wr(Mem_Wr),
                   .RF_Wr(RF_Wr),
                   .RF_En(RF_En), // This signal is not used. TODO: delete (?)
                   .WB_Select(WB_Select),
                   .Flag_Wr(Flag_Wr),
                   .Use_Top(Use_Top));
  // If LLB/LHB, make first register read from bits [11:8] 
  //  (SrcReg2 ignored in this case)
  // If SW/LW, make second register read from bits [7:4]
  assign SrcReg1 = Use_Top ? Instruction[11:8] 
                           : Instruction[7:4];
  assign SrcReg2 = Use_Top ? Instruction[7:4]
                           : Instruction[3:0];
  RegisterFile RF(.clk(clk),
                  .rst(~rst_n),
                  .SrcReg1(SrcReg1),
                  .SrcReg2(SrcReg2),
                  .DstReg(Instruction[11:8]),
                  .WriteReg(RF_Wr),
                  .DstData(WriteData),
                  .SrcData1(RegRead1),
                  .SrcData2(RegRead2));

  // 3: EX
  Alu ALU(.Output(ALUOut), 
          .Flag(NewFlag), 
          .Reg1(RegRead1), 
          .Reg2(RegRead2), 
          .Imm(Instruction[7:0]), 
          .Opcode(Instruction[15:12]));
  Register_3 Flag(.clk(clk), 
                  .rst(~rst_n), 
                  .In(NewFlag), 
                  .WriteEnable(Flag_Wr), 
                  .Out(OldFlag));
  PC_Control PCCtrl(.Branch(Br),
                    .BranchType(Instruction[13:12]),
                    .C(Instruction[11:9]),
                    .I(Instruction[8:0]),
                    .F(OldFlag),
                    .Reg(RegRead1),
                    .PC_In(OldPC),
                    .PC_Out(NewPC));

  // 4: MEM
  
  /** Instantiate pipeline register here?
  MEMWB_PipelineRegister MEM_WB(
    .clk(clk),
    .rst(rst),
    .WriteEnable(1'b1), 
    ....
  );
  */

  DataMem DataMemory(.data_out(MemOut),
                     .data_in(RegRead1),
                     .addr(ALUOut),
                     .enable(Mem_En),
                     .wr(Mem_Wr),
                     .clk(clk),
                     .rst(~rst_n));

  // 5: WB

  always @(WB_Select, ALUOut, MemOut, NewPC) begin
    case(WB_Select)
      0: WriteData = ALUOut;
      1: WriteData = MemOut;
      default: WriteData = NewPC;
    endcase
  end
  assign pc = OldPC;
  
endmodule