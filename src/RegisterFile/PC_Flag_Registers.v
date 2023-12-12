// For the PC and FLAG registers, we follow the structure
// of a register in the register file.
// author: Kevin Kristensen
module PCRg(clk,
            rst,
            WriteInput,
            ReadOutput);
  input clk, rst;
  input [15:0] WriteInput;
  inout [15:0] ReadOutput;

  wire WriteEnable, ReadEnable;
  assign WriteEnable = 1'b1;
  assign ReadEnable = 1'b1;

  BitCell_Flg_PC Bit0(.clk(clk),
                      .rst(rst),
                      .WriteBit(WriteInput[0]),
                      .WriteEnable(WriteEnable),
                      .ReadBit(ReadOutput[0]),
                      .ReadEnable(ReadEnable));
  BitCell_Flg_PC Bit1(.clk(clk),
                      .rst(rst),
                      .WriteBit(WriteInput[1]),
                      .WriteEnable(WriteEnable),
                      .ReadBit(ReadOutput[1]),
                      .ReadEnable(ReadEnable));
  BitCell_Flg_PC Bit2(.clk(clk),
                      .rst(rst),
                      .WriteBit(WriteInput[2]),
                      .WriteEnable(WriteEnable),
                      .ReadBit(ReadOutput[2]),
                      .ReadEnable(ReadEnable));
  BitCell_Flg_PC Bit3(.clk(clk),
                      .rst(rst),
                      .WriteBit(WriteInput[3]),
                      .WriteEnable(WriteEnable),
                      .ReadBit(ReadOutput[3]),
                      .ReadEnable(ReadEnable));
  BitCell_Flg_PC Bit4(.clk(clk),
                      .rst(rst),
                      .WriteBit(WriteInput[4]),
                      .WriteEnable(WriteEnable),
                      .ReadBit(ReadOutput[4]),
                      .ReadEnable(ReadEnable));
  BitCell_Flg_PC Bit5(.clk(clk),
                      .rst(rst),
                      .WriteBit(WriteInput[5]),
                      .WriteEnable(WriteEnable),
                      .ReadBit(ReadOutput[5]),
                      .ReadEnable(ReadEnable));
  BitCell_Flg_PC Bit6(.clk(clk),
                      .rst(rst),
                      .WriteBit(WriteInput[6]),
                      .WriteEnable(WriteEnable),
                      .ReadBit(ReadOutput[6]),
                      .ReadEnable(ReadEnable));
  BitCell_Flg_PC Bit7(.clk(clk),
                      .rst(rst),
                      .WriteBit(WriteInput[7]),
                      .WriteEnable(WriteEnable),
                      .ReadBit(ReadOutput[7]),
                      .ReadEnable(ReadEnable));
  BitCell_Flg_PC Bit8(.clk(clk),
                      .rst(rst),
                      .WriteBit(WriteInput[8]),
                      .WriteEnable(WriteEnable),
                      .ReadBit(ReadOutput[8]),
                      .ReadEnable(ReadEnable));
  BitCell_Flg_PC Bit9(.clk(clk),
                      .rst(rst),
                      .WriteBit(WriteInput[9]),
                      .WriteEnable(WriteEnable),
                      .ReadBit(ReadOutput[9]),
                      .ReadEnable(ReadEnable));
  BitCell_Flg_PC Bit10(.clk(clk),
                       .rst(rst),
                       .WriteBit(WriteInput[10]),
                       .WriteEnable(WriteEnable),
                       .ReadBit(ReadOutput[10]),
                       .ReadEnable(ReadEnable));
  BitCell_Flg_PC Bit11(.clk(clk),
                       .rst(rst),
                       .WriteBit(WriteInput[11]),
                       .WriteEnable(WriteEnable),
                       .ReadBit(ReadOutput[11]),
                       .ReadEnable(ReadEnable));
  BitCell_Flg_PC Bit12(.clk(clk),
                       .rst(rst),
                       .WriteBit(WriteInput[12]),
                       .WriteEnable(WriteEnable),
                       .ReadBit(ReadOutput[12]),
                       .ReadEnable(ReadEnable));
  BitCell_Flg_PC Bit13(.clk(clk),
                       .rst(rst),
                       .WriteBit(WriteInput[13]),
                       .WriteEnable(WriteEnable),
                       .ReadBit(ReadOutput[13]),
                       .ReadEnable(ReadEnable));
  BitCell_Flg_PC Bit14(.clk(clk),
                       .rst(rst),
                       .WriteBit(WriteInput[14]),
                       .WriteEnable(WriteEnable),
                       .ReadBit(ReadOutput[14]),
                       .ReadEnable(ReadEnable));
  BitCell_Flg_PC Bit15(.clk(clk),
                       .rst(rst),
                       .WriteBit(WriteInput[15]),
                       .WriteEnable(WriteEnable),
                       .ReadBit(ReadOutput[15]),
                       .ReadEnable(ReadEnable));
endmodule

// Flag register
// author: Kevin Kristensen
module FlagRg(clk,
              rst,
              WriteInput,
              WriteEnable,
              ReadOutput,
              ReadEnable);
  input clk, rst, WriteEnable, ReadEnable;
  input [2:0] WriteInput;
  inout [2:0] ReadOutput;

  BitCell_Flg_PC Bit0(.clk(clk),
                      .rst(rst),
                      .WriteBit(WriteInput[0]),
                      .WriteEnable(WriteEnable),
                      .ReadBit(ReadOutput[0]),
                      .ReadEnable(ReadEnable));
  BitCell_Flg_PC Bit1(.clk(clk),
                      .rst(rst),
                      .WriteBit(WriteInput[1]),
                      .WriteEnable(WriteEnable),
                      .ReadBit(ReadOutput[1]),
                      .ReadEnable(ReadEnable));
  BitCell_Flg_PC Bit2(.clk(clk),
                      .rst(rst),
                      .WriteBit(WriteInput[2]),
                      .WriteEnable(WriteEnable),
                      .ReadBit(ReadOutput[2]),
                      .ReadEnable(ReadEnable));

endmodule

// Bit cell consisting of a D flip-flop and a tri-state buffer,
// with only one read line.
// author: Kevin Kristensen
module BitCell_Flg_PC(clk, 
                      rst, // Reset (for flip-flop)
                      WriteBit, 
                      WriteEnable,
                      ReadBit,
                      ReadEnable);
  input clk, rst, WriteBit, WriteEnable, ReadEnable;
  inout ReadBit;

  wire Q; // DFF output

  dff DFlipFlop(.q(Q), .d(WriteBit), .wen(WriteEnable), .clk(clk), .rst(rst));
  TriStateBuffer T(.Data(Q), .OutputEnable(ReadEnable), .Output(ReadBit));
endmodule