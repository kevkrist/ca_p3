// Test bench for adder unit
// author: Kevin Kristensen
module TestPSWAdder();
  // Module inputs and outputs. Loop variable.
  reg [15:0] A, B;
  wire[15:0] Sum, TrueSatSubSum;
  wire Overflow, TrueOverflow;

  // Instantiate modules
  PSWAdder Add(.SubSum(Sum), .Overflow(Overflow), .A(A), .B(B));
  TrueVals PSWAddTrue(.TrueSatSubSum(TrueSatSubSum), 
                      .TrueOverflow(TrueOverflow), 
                      .A(A), 
                      .B(B));

  // Test suite
  initial begin
    // Test 1: No saturation
    A = {4'b0000, 4'b0001, 4'b0010, 4'b0011};
    B = {4'b0100, 4'b0101, 4'b0000, 4'b0001};
    #1;

    if(TrueSatSubSum == Sum & TrueOverflow == Overflow) begin
      $display("Test PASSED.");
    end else begin
      $display("Test FAILED.");
      $display("INPUT");
      $display("\tA0=%d, A1=%d, A2=%d, A3=%d", 
              $signed(A[3:0]),
              $signed(A[7:4]),
              $signed(A[11:8]),
              $signed(A[15:12]));
      $display("\tB0=%d, B1=%d, B2=%d, B3=%d", 
              $signed(B[3:0]),
              $signed(B[7:4]),
              $signed(B[11:8]),
              $signed(B[15:12]));
      $display("OUTPUT");
      $display("\tS0=%d, S1=%d, S2=%d, S3=%d, Overflow=%b", 
              $signed(Sum[3:0]),
              $signed(Sum[7:4]),
              $signed(Sum[11:8]),
              $signed(Sum[15:12]),
              Overflow);
      $display("TRUTH");
      $display("\tS0=%d, S1=%d, S2=%d, S3=%d, Overflow=%b", 
              $signed(TrueSatSubSum[3:0]),
              $signed(TrueSatSubSum[7:4]),
              $signed(TrueSatSubSum[11:8]),
              $signed(TrueSatSubSum[15:12]),
              TrueOverflow);
    end
    
    // Test 2: Saturate negatively
    A = {4'b1001, 4'b1111, 4'b1110, 4'b1101};
    B = {4'b1100, 4'b0001, 4'b0010, 4'b0011};
    #1;

    if(TrueSatSubSum == Sum & TrueOverflow == Overflow) begin
      $display("Test PASSED.");
    end else begin
      $display("Test FAILED.");
      $display("INPUT");
      $display("\tA0=%d, A1=%d, A2=%d, A3=%d", 
              $signed(A[3:0]),
              $signed(A[7:4]),
              $signed(A[11:8]),
              $signed(A[15:12]));
      $display("\tB0=%d, B1=%d, B2=%d, B3=%d", 
              $signed(B[3:0]),
              $signed(B[7:4]),
              $signed(B[11:8]),
              $signed(B[15:12]));
      $display("OUTPUT");
      $display("\tS0=%d, S1=%d, S2=%d, S3=%d, Overflow=%b", 
              $signed(Sum[3:0]),
              $signed(Sum[7:4]),
              $signed(Sum[11:8]),
              $signed(Sum[15:12]),
              Overflow);
      $display("TRUTH");
      $display("\tS0=%d, S1=%d, S2=%d, S3=%d, Overflow=%b", 
              $signed(TrueSatSubSum[3:0]),
              $signed(TrueSatSubSum[7:4]),
              $signed(TrueSatSubSum[11:8]),
              $signed(TrueSatSubSum[15:12]),
              TrueOverflow);
    end

    // Test 3: Saturate 2 cells, one negatively, one positively
    A = {4'b0110, 4'b1111, 4'b1110, 4'b1101};
    B = {4'b0101, 4'b0010, 4'b1110, 4'b0101};
    #1;

    if(TrueSatSubSum == Sum & TrueOverflow == Overflow) begin
      $display("Test PASSED.");
    end else begin
      $display("Test FAILED.");
      $display("INPUT");
      $display("\tA0=%d, A1=%d, A2=%d, A3=%d", 
              $signed(A[3:0]),
              $signed(A[7:4]),
              $signed(A[11:8]),
              $signed(A[15:12]));
      $display("\tB0=%d, B1=%d, B2=%d, B3=%d", 
              $signed(B[3:0]),
              $signed(B[7:4]),
              $signed(B[11:8]),
              $signed(B[15:12]));
      $display("OUTPUT");
      $display("\tS0=%d, S1=%d, S2=%d, S3=%d, Overflow=%b", 
              $signed(Sum[3:0]),
              $signed(Sum[7:4]),
              $signed(Sum[11:8]),
              $signed(Sum[15:12]),
              Overflow);
      $display("TRUTH");
      $display("\tS0=%d, S1=%d, S2=%d, S3=%d, Overflow=%b", 
              $signed(TrueSatSubSum[3:0]),
              $signed(TrueSatSubSum[7:4]),
              $signed(TrueSatSubSum[11:8]),
              $signed(TrueSatSubSum[15:12]),
              TrueOverflow);
    end
  end
endmodule

module TrueVals(TrueSatSubSum, TrueOverflow, A, B);
  output [15:0] TrueSatSubSum;
  output TrueOverflow;
  input [15:0] A, B;

  wire [15:0] OverflowArray, SatValArray, TrueSubSum;
  
  assign SatValArray[3:0] = A[3] ? 4'b1000 : 4'b0111;
  assign SatValArray[7:4] = A[7] ? 4'b1000 : 4'b0111;
  assign SatValArray[11:8] = A[11] ? 4'b1000 : 4'b0111;
  assign SatValArray[15:12] = A[15] ? 4'b1000 : 4'b0111;
  assign TrueSubSum[3:0] = A[3:0] + B[3:0];
  assign TrueSubSum[7:4] = A[7:4] + B[7:4];
  assign TrueSubSum[11:8] = A[11:8] + B[11:8];
  assign TrueSubSum[15:12] = A[15:12] + B[15:12];
  assign OverflowArray[0] = A[3]~^B[3] ? A[3]^TrueSubSum[3] : 0;
  assign OverflowArray[1] = A[7]~^B[7] ? A[7]^TrueSubSum[7] : 0;
  assign OverflowArray[2] = A[11]~^B[11] ? A[11]^TrueSubSum[11] : 0;
  assign OverflowArray[3] = A[15]~^B[15] ? A[15]^TrueSubSum[15] : 0;
  assign TrueSatSubSum[3:0] = OverflowArray[0] ? SatValArray[3:0] 
                                               : TrueSubSum[3:0];
  assign TrueSatSubSum[7:4] = OverflowArray[1] ? SatValArray[7:4] 
                                               : TrueSubSum[7:4];
  assign TrueSatSubSum[11:8] = OverflowArray[2] ? SatValArray[11:8] 
                                                : TrueSubSum[11:8];
  assign TrueSatSubSum[15:12] = OverflowArray[3] ? SatValArray[15:12] 
                                                 : TrueSubSum[15:12];
  assign TrueOverflow = OverflowArray[0] 
                        | OverflowArray[1] 
                        | OverflowArray[2] 
                        | OverflowArray[3];
endmodule