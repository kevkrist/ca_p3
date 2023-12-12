// 1-bit full-adder
// author: Kevin Kristensen
module Adder_1bit(Sum, CarryOut, A, B, CarryIn);
	input A, B, CarryIn;
	output Sum, CarryOut;

	assign CarryOut = (B&CarryIn)|(A&CarryIn)|(A&B);
	assign Sum = ((A^B)&~CarryIn)|((A^~B)&CarryIn);

endmodule