// Test bench for the PC register
// author: Kevin Kristensen
module TestPCReg();
  reg clk, rst;
  reg [15:0] WriteInput;
  wire [15:0] ReadOutput;
  parameter CLOCK_PERIOD = 10; 


  // Instantiate PC register
  PCRg PC(.clk(clk), 
          .rst(rst), 
          .WriteInput(WriteInput),
          .ReadOutput(ReadOutput));

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
    WriteInput = 16'h0123;

    #10
    if(ReadOutput != 16'h0123) begin
      $display("Test FAILED.");
    end else begin
      $display("Test PASSED.");
    end   
    $display("\tOUTPUT  =%d", ReadOutput);
    $display("\tEXPECTED=%d\n", 16'h0123);
    WriteInput = 16'hf0f0;

    #10
    if(ReadOutput != 16'hf0f0) begin
      $display("Test FAILED.");
    end else begin
      $display("Test PASSED.");
    end   
    $display("\tOUTPUT  =%d", ReadOutput);
    $display("\tEXPECTED=%d\n", 16'hf0f0);
    rst = 1'b1;

    #10
    if(ReadOutput != 16'h0000) begin
      $display("Test FAILED.");
    end else begin
      $display("Test PASSED.");
    end   
    $display("\tOUTPUT  =%d", ReadOutput);
    $display("\tEXPECTED=%d\n", 16'h0000);
  end

endmodule