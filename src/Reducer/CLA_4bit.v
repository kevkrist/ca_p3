/*
Carry lookahead adder for 4 bits
Author: Lilly Peralta
*/
module CLA_4bit (
  input [3:0] A,
  input [3:0] B,
  input Cin,
  output [3:0] Sum,
  output Cout
);

  // Full adders for each bit
  wire [3:0] C; // Carry-out

  Adder_1bit U_fullAdder_1bit_0(
    .Sum(Sum[0]),
    .CarryOut(C[0]),
    .A(A[0]),
    .B(B[0]),
    .CarryIn(Cin)
  );

  Adder_1bit U_fullAdder_1bit_1(
    .Sum(Sum[1]),
    .CarryOut(C[1]),
    .A(A[1]),
    .B(B[1]),
    .CarryIn(C[0])
  );

  Adder_1bit U_fullAdder_1bit_2(
    .Sum(Sum[2]),
    .CarryOut(C[2]),
    .A(A[2]),
    .B(B[2]),
    .CarryIn(C[1])
  );

  Adder_1bit U_fullAdder_1bit_3(
    .Sum(Sum[3]),
    .CarryOut(C[3]), 
    .A(A[3]),
    .B(B[3]),
    .CarryIn(C[2])
  );

  assign Cout = C[3];
  
endmodule

