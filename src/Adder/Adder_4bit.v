// 4-bit ripple-carry adder/subtractor
// Since PADDSB only performs addition, no need for a Sub wire here.
// Performs saturating arithmetic.
// author: Kevin Kristensen
module Adder_4bit(Sum, Overflow, A, B, CarryIn);
	input [3:0] A, B;
	input CarryIn;
	output [3:0] Sum;
	output Overflow;

	wire [3:0] SatVal;
	wire [3:0] TempSum;
	wire [3:0] CarryOutArray;

	assign SatVal = A[3] ? 4'b1000 : 4'b0111;

	Adder_1bit A0(.Sum(TempSum[0]), 
                .CarryOut(CarryOutArray[0]), 
                .A(A[0]), 
                .B(B[0]), 
                .CarryIn(CarryIn));
	Adder_1bit A1(.Sum(TempSum[1]), 
                .CarryOut(CarryOutArray[1]), 
                .A(A[1]), 
                .B(B[1]), 
                .CarryIn(CarryOutArray[0]));
	Adder_1bit A2(.Sum(TempSum[2]), 
                .CarryOut(CarryOutArray[2]), 
                .A(A[2]), 
                .B(B[2]), 
                .CarryIn(CarryOutArray[1]));
	Adder_1bit A3(.Sum(TempSum[3]), 
                .CarryOut(CarryOutArray[3]), 
                .A(A[3]), 
                .B(B[3]), 
                .CarryIn(CarryOutArray[2]));

  assign Overflow = CarryOutArray[3]^CarryOutArray[2];
  assign Sum = CarryOutArray[3]^CarryOutArray[2] ? SatVal : TempSum;

endmodule