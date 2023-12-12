 // 16-bit ripple-carry adder/subtractor
// Performs saturating arithmetic
 // author: Kevin Kristensen
 module Adder_16bit(Sum, Overflow, A, B, Sub);
  input [15:0] A, B;
  input Sub;
  output [15:0] Sum;
  output Overflow;

  wire [15:0] CarryOut;
  wire [15:0] SatVal, BSub, TempSum;

  assign SatVal = A[15] ? {1'b1, {15{1'b0}}} : {1'b0, {15{1'b1}}};
  assign BSub = Sub ? ~B : B;

  // 1-bit adder array
  Adder_1bit A0(.Sum(TempSum[0]),
                .CarryOut(CarryOut[0]),
                .A(A[0]),
                .B(BSub[0]),
                .CarryIn(Sub));
  Adder_1bit A1(.Sum(TempSum[1]),
                .CarryOut(CarryOut[1]),
                .A(A[1]),
                .B(BSub[1]),
                .CarryIn(CarryOut[0]));
  Adder_1bit A2(.Sum(TempSum[2]),
                .CarryOut(CarryOut[2]),
                .A(A[2]),
                .B(BSub[2]),
                .CarryIn(CarryOut[1]));
  Adder_1bit A3(.Sum(TempSum[3]),
                .CarryOut(CarryOut[3]),
                .A(A[3]),
                .B(BSub[3]),
                .CarryIn(CarryOut[2]));
  Adder_1bit A4(.Sum(TempSum[4]),
                .CarryOut(CarryOut[4]),
                .A(A[4]),
                .B(BSub[4]),
                .CarryIn(CarryOut[3]));
  Adder_1bit A5(.Sum(TempSum[5]),
                .CarryOut(CarryOut[5]),
                .A(A[5]),
                .B(BSub[5]),
                .CarryIn(CarryOut[4]));
  Adder_1bit A6(.Sum(TempSum[6]),
                .CarryOut(CarryOut[6]),
                .A(A[6]),
                .B(BSub[6]),
                .CarryIn(CarryOut[5]));
  Adder_1bit A7(.Sum(TempSum[7]),
                .CarryOut(CarryOut[7]),
                .A(A[7]),
                .B(BSub[7]),
                .CarryIn(CarryOut[6]));
  Adder_1bit A8(.Sum(TempSum[8]),
                .CarryOut(CarryOut[8]),
                .A(A[8]),
                .B(BSub[8]),
                .CarryIn(CarryOut[7]));
  Adder_1bit A9(.Sum(TempSum[9]),
                .CarryOut(CarryOut[9]),
                .A(A[9]),
                .B(BSub[9]),
                .CarryIn(CarryOut[8]));
  Adder_1bit A10(.Sum(TempSum[10]),
                 .CarryOut(CarryOut[10]),
                 .A(A[10]),
                 .B(BSub[10]),
                 .CarryIn(CarryOut[9]));
  Adder_1bit A11(.Sum(TempSum[11]),
                 .CarryOut(CarryOut[11]),
                 .A(A[11]),
                 .B(BSub[11]),
                 .CarryIn(CarryOut[10]));
  Adder_1bit A12(.Sum(TempSum[12]),
                 .CarryOut(CarryOut[12]),
                 .A(A[12]),
                 .B(BSub[12]),
                 .CarryIn(CarryOut[11]));
  Adder_1bit A13(.Sum(TempSum[13]),
                 .CarryOut(CarryOut[13]),
                 .A(A[13]),
                 .B(BSub[13]),
                 .CarryIn(CarryOut[12]));
  Adder_1bit A14(.Sum(TempSum[14]),
                 .CarryOut(CarryOut[14]),
                 .A(A[14]),
                 .B(BSub[14]),
                 .CarryIn(CarryOut[13]));
  Adder_1bit A15(.Sum(TempSum[15]),
                 .CarryOut(CarryOut[15]),
                 .A(A[15]),
                 .B(BSub[15]),
                 .CarryIn(CarryOut[14]));

  assign Overflow = CarryOut[15]^CarryOut[14];
  assign Sum = CarryOut[15]^CarryOut[14] ? SatVal : TempSum;

endmodule