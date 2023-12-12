// Parallel sub-word adder
// author: Kevin Kristensen
module PSWAdder(SubSum, Overflow, A, B);
  input [15:0] A, B;
  output [15:0] SubSum;
  output Overflow;

  wire [3:0] OverflowArray;
  wire CarryIn;

  assign CarryIn = 1'b0;

  // Note that we don't care about CarryOut
  Adder_4bit A1(.Sum(SubSum[3:0]),
                .Overflow(OverflowArray[0]),
                .A(A[3:0]),
                .B(B[3:0]),
                .CarryIn(CarryIn));
  Adder_4bit A2(.Sum(SubSum[7:4]),
                .Overflow(OverflowArray[1]),
                .A(A[7:4]),
                .B(B[7:4]),
                .CarryIn(CarryIn));
  Adder_4bit A3(.Sum(SubSum[11:8]),
                .Overflow(OverflowArray[2]),
                .A(A[11:8]),
                .B(B[11:8]),
                .CarryIn(CarryIn));
  Adder_4bit A4(.Sum(SubSum[15:12]),
                .Overflow(OverflowArray[3]),
                .A(A[15:12]),
                .B(B[15:12]),
                .CarryIn(CarryIn));
  assign Overflow = OverflowArray[0] 
                    | OverflowArray[1] 
                    | OverflowArray[2] 
                    | OverflowArray[3];

endmodule