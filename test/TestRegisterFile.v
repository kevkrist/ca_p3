// Test bench for the register file
// author: Kevin Kristensen
module TestRegisterFile();
  reg clk, rst, WriteReg;
  reg [3:0] ReadRegNum1, ReadRegNum2, WriteRegNum;
  reg [15:0] WriteInput;
  wire [15:0] ReadOutput1, ReadOutput2;
  parameter CLOCK_PERIOD = 10; 

  // Instantiate the register file
  RegisterFile RF(.clk(clk),
                  .rst(rst),
                  .SrcReg1(ReadRegNum1),
                  .SrcReg2(ReadRegNum2),
                  .DstReg(WriteRegNum),
                  .WriteReg(WriteReg),
                  .DstData(WriteInput),
                  .SrcData1(ReadOutput1),
                  .SrcData2(ReadOutput2));

  // Clock generation
  initial begin
    clk = 1'b1;
    forever begin
      #(CLOCK_PERIOD/2) clk = ~clk;
    end
  end

  // Stimulus generation
  initial begin
    rst = 1'b0;
    WriteReg = 1'b1;
    ReadRegNum1 = 4'h1;
    ReadRegNum2 = 4'h2;
    WriteRegNum = 4'h1;
    WriteInput = 16'h0101;
    #10
    WriteRegNum = 4'h2;
    WriteInput = 16'h1010;

    #10
    if(ReadOutput1 != 16'h0101 | ReadOutput2 != 16'h1010) begin
      $display("Test FAILED.");
    end else begin
      $display("Test PASSED.");
    end   
    $display("\tOUTPUT   Read1=%d, Read2=%d", ReadOutput1, ReadOutput2);
    $display("\tEXPECTED Read1=%d, Read2=%d\n", 16'h0101, 16'h1010);
    WriteRegNum = 4'h3;
    WriteInput = 16'h00aa;
    ReadRegNum1 = 4'h3; // Should RF bypass
    ReadRegNum2 = 4'h1;

    #10
    if(ReadOutput1 != 16'h00aa | ReadOutput2 != 16'h0101) begin
      $display("Test FAILED.");
    end else begin
      $display("Test PASSED.");
    end   
    $display("\tOUTPUT   Read1=%d, Read2=%d", ReadOutput1, ReadOutput2);
    $display("\tEXPECTED Read1=%d, Read2=%d\n", 16'h00aa, 16'h0101);
    WriteReg = 1'b0;
    WriteRegNum = 4'h1;
    WriteInput = 16'hbbcc;
    ReadRegNum1 = 4'h2;

    #10 // Nothing should overwrite previous contents of register 1
    if(ReadOutput1 != 16'h1010 | ReadOutput2 != 16'h0101) begin
      $display("Test FAILED.");
    end else begin
      $display("Test PASSED.");
    end   
    $display("\tOUTPUT   Read1=%d, Read2=%d", ReadOutput1, ReadOutput2);
    $display("\tEXPECTED Read1=%d, Read2=%d\n", 16'h1010, 16'h0101);
    WriteReg = 1'b1;
    WriteRegNum = 4'h8;
    WriteInput = 16'habcd;
    ReadRegNum1 = 4'h0;
    ReadRegNum2 = 4'h8;

    #10
    if(ReadOutput1 != 16'h0000 | ReadOutput2 != 16'habcd) begin
      $display("Test FAILED.");
    end else begin
      $display("Test PASSED.");
    end   
    $display("\tOUTPUT   Read1=%d, Read2=%d", ReadOutput1, ReadOutput2);
    $display("\tEXPECTED Read1=%d, Read2=%d\n", 16'h0000, 16'habcd);

  end

endmodule