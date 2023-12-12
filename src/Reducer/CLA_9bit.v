/*
Carry lookahead adder for 9 bits using three 4-bit CLAs
Author: Lilly Peralta
*/
module CLA_9bit (
  input [8:0] A,
  input [8:0] B,
  input Ci,
  output Co,
  output [8:0] Sum
);

  wire Co1;

  // create 4-bit CLAs
  CLA_4bit CLA1 (
    .A(A[3:0]),
    .B(B[3:0]),
    .Cin(Ci),
    .Cout(Co1),
    .Sum(Sum[3:0])
  );

  CLA_4bit CLA2 (
    .A(A[7:4]),
    .B(B[7:4]),
    .Cin(Co1), // Co1 from the first 4-bit CLA as the carry-in
    .Cout(Co),
    .Sum(Sum[7:4])
  );

  assign Sum[8] = Co;
 
endmodule

