// SRA: Configure input to pass into stack of multiplexor arrays
// author: Kevin Kristensen
// precondition: Base3_x inputs != 3
module ShiftRightArithmetic(In, Base3_0, Base3_1, Base3_2, Out);
  input [15:0] In;
  input[1:0] Base3_0, Base3_1, Base3_2;
  output [15:0] Out;

  wire Msb;
  wire [47:0] ArrayInput_0, ArrayInput_1, ArrayInput_2;
  wire [15:0] Out_0, Out_1;

  // Pick most significant bit for convenience
  assign Msb = In[15];

  // Configure inputs to multiplexor arrays
  assign ArrayInput_0 = {{2{Msb}}, In[15],
                         Msb, In[15:14],
                         In[15:13],
                         In[14:12],
                         In[13:11],
                         In[12:10],
                         In[11:9],
                         In[10:8],
                         In[9:7],
                         In[8:6],
                         In[7:5],
                         In[6:4],
                         In[5:3],
                         In[4:2],
                         In[3:1],
                         In[2:0]};

  assign ArrayInput_1 = {{2{Msb}}, Out_0[15],
                         {2{Msb}}, Out_0[14],
                         {2{Msb}}, Out_0[13],
                         Msb, Out_0[15], Out_0[12],
                         Msb, Out_0[14], Out_0[11],
                         Msb, Out_0[13], Out_0[10],
                         Out_0[15], Out_0[12], Out_0[9],
                         Out_0[14], Out_0[11], Out_0[8],
                         Out_0[13], Out_0[10], Out_0[7],
                         Out_0[12], Out_0[9], Out_0[6],
                         Out_0[11], Out_0[8], Out_0[5],
                         Out_0[10], Out_0[7], Out_0[4],
                         Out_0[9], Out_0[6], Out_0[3],
                         Out_0[8], Out_0[5], Out_0[2],
                         Out_0[7], Out_0[4], Out_0[1],
                         Out_0[6], Out_0[3], Out_0[0]};

  assign ArrayInput_2 = {{2{Msb}}, Out_1[15],
                         {2{Msb}}, Out_1[14],
                         {2{Msb}}, Out_1[13],
                         {2{Msb}}, Out_1[12],
                         {2{Msb}}, Out_1[11],
                         {2{Msb}}, Out_1[10],
                         {2{Msb}}, Out_1[9],
                         {2{Msb}}, Out_1[8],
                         {2{Msb}}, Out_1[7],
                         Msb, Out_1[15], Out_1[6],
                         Msb, Out_1[14], Out_1[5],
                         Msb, Out_1[13], Out_1[4],
                         Msb, Out_1[12], Out_1[3],
                         Msb, Out_1[11], Out_1[2],
                         Msb, Out_1[10], Out_1[1],
                         Msb, Out_1[9], Out_1[0]};

  // Instantiate multiplexor arrays to perform shift
  Mux_3_1_Array Array_0(.In(ArrayInput_0), .Sel(Base3_0), .Out(Out_0));
  Mux_3_1_Array Array_1(.In(ArrayInput_1), .Sel(Base3_1), .Out(Out_1));
  Mux_3_1_Array Array_2(.In(ArrayInput_2), .Sel(Base3_2), .Out(Out));
endmodule