// Test bench for the register file
// author: Kevin Kristensen
module TestReadDecoder();
  reg WriteReg;
  reg [3:0] RegId;
  wire [15:0] ReadWordline, WriteWordline;
  parameter CLOCK_PERIOD = 10; 

  // Instantiate the read decoder and write decoder
  ReadDecoder_4_16 RD(.RegId(RegId), .Wordline(ReadWordline));
  WriteDecoder_4_16 WD(.RegId(RegId), 
                       .WriteReg(WriteReg), 
                       .Wordline(WriteWordline));

  // Stimulus generation
  initial begin
    WriteReg = 1'b1;
    RegId = 4'b0011;

    #1
    if(ReadWordline != 8 | WriteWordline != 8) begin
      $display("Test FAILED.");
    end else begin
      $display("Test PASSED.");
    end
    $display("\tOUTPUT   Readline=%d, Writeline=%d", 
             ReadWordline, 
             WriteWordline);
    $display("\tEXPECTED Readline=%d, Writeline=%d\n", 16'h0008, 16'h0008);

    WriteReg = 1'b0;
    RegId = 4'b0101;
    #1
    if(ReadWordline !=32  | WriteWordline != 0) begin
      $display("Test FAILED.");
    end else begin
      $display("Test PASSED.");
    end
    $display("\tOUTPUT   Readline=%d, Writeline=%d", 
             ReadWordline, 
             WriteWordline);
    $display("\tEXPECTED Readline=%d, Writeline=%d\n", 16'h0020, 16'h0000);

  end

endmodule