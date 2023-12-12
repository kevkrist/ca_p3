// Test bench for the FLAG register
// author: Kevin Kristensen
module TestFlagReg();
  reg clk, rst, WriteEnable, ReadEnable;
  reg [2:0] WriteInput;
  wire [2:0] ReadOutput;
  parameter CLOCK_PERIOD = 10; 


  // instantiate FLAG register
  FlagRg FLAG(.clk(clk), 
              .rst(rst), 
              .WriteInput(WriteInput), 
              .WriteEnable(WriteEnable), 
              .ReadOutput(ReadOutput), 
              .ReadEnable(ReadEnable));

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
    ReadEnable = 1'b1;
    WriteEnable = 1'b1;
    WriteInput = 3'b000;

    #10
    if(ReadOutput != 3'b000) begin
      $display("Test FAILED.");
    end else begin
      $display("Test PASSED.");
    end   
    $display("\tOUTPUT  =%3b", ReadOutput);
    $display("\tEXPECTED=%3b\n", 3'b000);
    WriteInput = 3'b111;

    #10
    if(ReadOutput != 3'b111) begin
      $display("Test FAILED.");
    end else begin
      $display("Test PASSED.");
    end   
    $display("\tOUTPUT  =%3b", ReadOutput);
    $display("\tEXPECTED=%3b\n", 3'b111);
    ReadEnable = 1'b0;

    #10
    if(ReadOutput != 3'bZZZ) begin
      $display("Test FAILED.");
    end else begin
      $display("Test PASSED.");
    end   
    $display("\tOUTPUT  =%3b", ReadOutput);
    $display("\tEXPECTED=%3b\n", 3'bZZZ);
    WriteInput = 3'b101;
    WriteEnable = 1'b0;
    ReadEnable = 1'b1;

    #10
    if(ReadOutput != 3'b111) begin
      $display("Test FAILED.");
    end else begin
      $display("Test PASSED.");
    end   
    $display("\tOUTPUT  =%3b", ReadOutput);
    $display("\tEXPECTED=%3b\n", 3'b111);
    rst = 1'b1;

    #10
    if(ReadOutput != 3'b000) begin
      $display("Test FAILED.");
    end else begin
      $display("Test PASSED.");
    end   
    $display("\tOUTPUT  =%3b", ReadOutput);
    $display("\tEXPECTED=%3b\n", 3'b000);
  end

endmodule