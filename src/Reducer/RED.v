/**
Reducer module for two 16-bit operands that get split into four operands
Author: Lilly Peralta
*/
module RED (
  input [15:0] rs,
  input [15:0] rt,
  output [15:0] rd
);

  wire [7:0] a, b, c, d; // 8-bit segments of rs and rt
  wire [8:0] sumac, sumbd; // 9-bit results of (a+c) and (b+d)
  wire [8:0] result;
  wire cout1;
  wire cout2;

  // Split rs and rt into 8-bit segments
  assign a = rs[15:8];
  assign b = rs[7:0];
  assign c = rt[15:8];
  assign d = rt[7:0];

  // First level
  CLA_4bit adder_a1 (
    .A(a[3:0]),
    .B(c[3:0]),
    .Cin(1'b0), // No carry-in
    .Cout(cout1),
    .Sum(sumac[3:0])
  );

  CLA_4bit adder_a2 (
    .A(a[7:4]),
    .B(c[7:4]),
    .Cin(cout1), // No carry-in
    .Cout(sumac[8]),
    .Sum(sumac[7:4])
  );

  CLA_4bit adder_b1 (
    .A(b[3:0]),
    .B(d[3:0]),
    .Cin(1'b0), // No carry-in
    .Cout(cout2),
    .Sum(sumbd[3:0])
  );

  CLA_4bit adder_b2 (
    .A(b[7:4]),
    .B(d[7:4]),
    .Cin(cout2), // No carry-in
    .Cout(sumbd[8]),
    .Sum(sumbd[7:4])
  );

  // Second level using 9-bit adder
  CLA_9bit adder_final (
    .A({sumac[8:4], sumac[3:0]}),
    .B({sumbd[8:4], sumbd[3:0]}),
    .Ci(1'b0), // No carry-in
    .Co(),
    .Sum(result)
  );

  // Assign the result to rd
  assign rd = {{7{result[8]}}, result[8:0]};

endmodule


