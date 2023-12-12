// Test bench for adder unit
// NOTE: I was having with the timer and looping, so I am resorting to manual 
// testing henceforth
// author: Kevin Kristensen
module TestAdder();
  reg [15:0] A, B;
  reg Sub;
  wire[15:0] Sum, TrueSaturatedSum;
  wire Overflow, TrueOverflow;

  // Instantiate modules
  Adder_16bit Add(.Sum(Sum), .Overflow(Overflow), .A(A), .B(B), .Sub(Sub));
  TrueVals AddTrue(.TrueSaturatedSum(TrueSaturatedSum), 
                   .TrueOverflow(TrueOverflow), 
                   .A(A), 
                   .B(B), 
                   .Sub(Sub));
  
  // Test suite
  initial begin
    // Test 1: Saturation with addition
    A = 16'b0111111111111100;
    B = 16'b0000000000001111;
    Sub = 1'b0;      
    #1;

    // Test outputs
    if(TrueSaturatedSum == Sum & TrueOverflow == Overflow) begin
      $display("Test PASSED.");
    end else begin
      $display("Test FAILED.");
      $display("Input:  A=%d, B=%d, Sub=%b", $signed(A), $signed(B), Sub);
      $display("Output: Sum=%d, Overflow=%d", $signed(Sum), Overflow);
      $display("Truth:  Sum=%d, Overflow=%d", 
               $signed(TrueSaturatedSum), 
               TrueOverflow);
    end

    // Test 2: Saturation with subtraction
    A = 16'b1000000000000111;
    B = 16'b0111111111111100;
    Sub = 1'b1;      
    #1;

    // Test outputs
    if(TrueSaturatedSum == Sum & TrueOverflow == Overflow) begin
      $display("Test PASSED.");
    end else begin
      $display("Test FAILED.");
      $display("Input:  A=%d, B=%d, Sub=%b", $signed(A), $signed(B), Sub);
      $display("Output: Sum=%d, Overflow=%d", $signed(Sum), Overflow);
      $display("Truth:  Sum=%d, Overflow=%d", 
               $signed(TrueSaturatedSum), 
               TrueOverflow);
    end

    // Test 3: Normal addition
    A = 16'b1000000000000111;
    B = 16'b0000010101011000;
    Sub = 1'b0;      
    #1;

    // Test outputs
    if(TrueSaturatedSum == Sum & TrueOverflow == Overflow) begin
      $display("Test PASSED.");
    end else begin
      $display("Test FAILED.");
      $display("Input:  A=%d, B=%d, Sub=%b", $signed(A), $signed(B), Sub);
      $display("Output: Sum=%d, Overflow=%d", $signed(Sum), Overflow);
      $display("Truth:  Sum=%d, Overflow=%d", 
               $signed(TrueSaturatedSum), 
               TrueOverflow);
    end

    // Test 3: Normal subtraction
    A = 16'b1011111101101111;
    B = 16'b0000010101011000;
    Sub = 1'b1;      
    #1;

    // Test outputs
    if(TrueSaturatedSum == Sum & TrueOverflow == Overflow) begin
      $display("Test PASSED.");
    end else begin
      $display("Test FAILED.");
      $display("Input:  A=%d, B=%d, Sub=%b", $signed(A), $signed(B), Sub);
      $display("Output: Sum=%d, Overflow=%d", $signed(Sum), Overflow);
      $display("Truth:  Sum=%d, Overflow=%d", 
               $signed(TrueSaturatedSum), 
               TrueOverflow);
    end
  end
endmodule

// Module for collecting true values
module TrueVals(TrueSaturatedSum, TrueOverflow, A, B, Sub);
  output [15:0] TrueSaturatedSum;
  output TrueOverflow;
  input [15:0] A, B;
  input Sub;

  wire [15:0] TrueSum;
  wire [15:0] SatVal;
  wire TrueOverflowTemp;

  assign SatVal = A[15] ? {1'b1, {15{1'b0}}} : {1'b0, {15{1'b1}}};
  assign TrueSum = Sub ? (A - B) : (A + B);
  assign TrueOverflowTemp = ( (~Sub&~(A[15]^B[15])) | (Sub&(A[15]^B[15])) ) 
                            ? (A[15]^TrueSum[15]) : 0;
  assign TrueSaturatedSum = TrueOverflowTemp ?  SatVal : TrueSum;
  assign TrueOverflow = TrueOverflowTemp;
endmodule