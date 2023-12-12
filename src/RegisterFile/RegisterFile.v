// A register file
module RegisterFile(clk,
                    rst, // Reset state
                    SrcReg1,
                    SrcReg2,
                    DstReg,
                    WriteReg, // Data to write to DstReg
                    DstData,
                    SrcData1,
                    SrcData2);
  input clk, rst, WriteReg;
  input [3:0] SrcReg1, SrcReg2, DstReg;
  input [15:0] DstData;
  inout [15:0] SrcData1, SrcData2;
  wire [15:0] ReadWordline1, 
              ReadWordline2, 
              WriteWordline, 
              SrcData1Temp, 
              SrcData2Temp;

  // Decode
  ReadDecoder_4_16 RDecode1(.RegId(SrcReg1), .Wordline(ReadWordline1));
  ReadDecoder_4_16 RDecode2(.RegId(SrcReg2), .Wordline(ReadWordline2));
  WriteDecoder_4_16 WDecode(.RegId(DstReg), 
                            .WriteReg(WriteReg), 
                            .Wordline(WriteWordline));

  // Select register based on Wordline
  Rg Rg1(.clk(clk),
         .rst(rst),
         .D(DstData),
         .WriteReg(WriteWordline[1]),
         .ReadEnable1(ReadWordline1[1]),
         .ReadEnable2(ReadWordline2[1]),
         .Bitline1(SrcData1Temp),
         .Bitline2(SrcData2Temp));
  Rg Rg2(.clk(clk),
         .rst(rst),
         .D(DstData),
         .WriteReg(WriteWordline[2]),
         .ReadEnable1(ReadWordline1[2]),
         .ReadEnable2(ReadWordline2[2]),
         .Bitline1(SrcData1Temp),
         .Bitline2(SrcData2Temp));
  Rg Rg3(.clk(clk),
         .rst(rst),
         .D(DstData),
         .WriteReg(WriteWordline[3]),
         .ReadEnable1(ReadWordline1[3]),
         .ReadEnable2(ReadWordline2[3]),
         .Bitline1(SrcData1Temp),
         .Bitline2(SrcData2Temp));
  Rg Rg4(.clk(clk),
         .rst(rst),
         .D(DstData),
         .WriteReg(WriteWordline[4]),
         .ReadEnable1(ReadWordline1[4]),
         .ReadEnable2(ReadWordline2[4]),
         .Bitline1(SrcData1Temp),
         .Bitline2(SrcData2Temp));
  Rg Rg5(.clk(clk),
         .rst(rst),
         .D(DstData),
         .WriteReg(WriteWordline[5]),
         .ReadEnable1(ReadWordline1[5]),
         .ReadEnable2(ReadWordline2[5]),
         .Bitline1(SrcData1Temp),
         .Bitline2(SrcData2Temp));
  Rg Rg6(.clk(clk),
         .rst(rst),
         .D(DstData),
         .WriteReg(WriteWordline[6]),
         .ReadEnable1(ReadWordline1[6]),
         .ReadEnable2(ReadWordline2[6]),
         .Bitline1(SrcData1Temp),
         .Bitline2(SrcData2Temp));
  Rg Rg7(.clk(clk),
         .rst(rst),
         .D(DstData),
         .WriteReg(WriteWordline[7]),
         .ReadEnable1(ReadWordline1[7]),
         .ReadEnable2(ReadWordline2[7]),
         .Bitline1(SrcData1Temp),
         .Bitline2(SrcData2Temp));
  Rg Rg8(.clk(clk),
         .rst(rst),
         .D(DstData),
         .WriteReg(WriteWordline[8]),
         .ReadEnable1(ReadWordline1[8]),
         .ReadEnable2(ReadWordline2[8]),
         .Bitline1(SrcData1Temp),
         .Bitline2(SrcData2Temp));
  Rg Rg9(.clk(clk),
         .rst(rst),
         .D(DstData),
         .WriteReg(WriteWordline[9]),
         .ReadEnable1(ReadWordline1[9]),
         .ReadEnable2(ReadWordline2[9]),
         .Bitline1(SrcData1Temp),
         .Bitline2(SrcData2Temp));
  Rg Rg10(.clk(clk),
          .rst(rst),
          .D(DstData),
          .WriteReg(WriteWordline[10]),
          .ReadEnable1(ReadWordline1[10]),
          .ReadEnable2(ReadWordline2[10]),
          .Bitline1(SrcData1Temp),
          .Bitline2(SrcData2Temp));
  Rg Rg11(.clk(clk),
          .rst(rst),
          .D(DstData),
          .WriteReg(WriteWordline[11]),
          .ReadEnable1(ReadWordline1[11]),
          .ReadEnable2(ReadWordline2[11]),
          .Bitline1(SrcData1Temp),
          .Bitline2(SrcData2Temp));
  Rg Rg12(.clk(clk),
          .rst(rst),
          .D(DstData),
          .WriteReg(WriteWordline[12]),
          .ReadEnable1(ReadWordline1[12]),
          .ReadEnable2(ReadWordline2[12]),
          .Bitline1(SrcData1Temp),
          .Bitline2(SrcData2Temp));
  Rg Rg13(.clk(clk),
          .rst(rst),
          .D(DstData),
          .WriteReg(WriteWordline[13]),
          .ReadEnable1(ReadWordline1[13]),
          .ReadEnable2(ReadWordline2[13]),
          .Bitline1(SrcData1Temp),
          .Bitline2(SrcData2Temp));
  Rg Rg14(.clk(clk),
          .rst(rst),
          .D(DstData),
          .WriteReg(WriteWordline[14]),
          .ReadEnable1(ReadWordline1[14]),
          .ReadEnable2(ReadWordline2[14]),
          .Bitline1(SrcData1Temp),
          .Bitline2(SrcData2Temp));
  Rg Rg15(.clk(clk),
          .rst(rst),
          .D(DstData),
          .WriteReg(WriteWordline[15]),
          .ReadEnable1(ReadWordline1[15]),
          .ReadEnable2(ReadWordline2[15]),
          .Bitline1(SrcData1Temp),
          .Bitline2(SrcData2Temp));

  // Handle hardwired ZERO register read output
  /* For single-cycle implementation, RF bypassing causing race condition
  assign SrcData1 = ReadWordline1[0] ? 16'h0000 : SrcData1Temp;
  assign SrcData2 = ReadWordline2[0] ? 16'h0000 : SrcData2Temp;
  */

  // RF bypassing
  assign SrcData1 = ReadWordline1[0] ? 16'h0000
                    : (((SrcReg1 == DstReg) & WriteReg) ? WriteReg 
                                                        : SrcData1Temp);
  assign SrcData2 = ReadWordline2[0] ? 16'h0000
                    : (((SrcReg2 == DstReg) & WriteReg) ? WriteReg
                                                        : SrcData2Temp);
endmodule