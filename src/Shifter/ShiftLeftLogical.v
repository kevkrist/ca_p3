// SLL: Configure input to pass into stack of multiplexor arrays
// author: Kevin Kristensen
// precondition: Base3_x inputs != 3
module ShiftLeftLogical(In, Base3_0, Base3_1, Base3_2, Out);
  input [15:0] In;
  input[1:0] Base3_0, Base3_1, Base3_2;
  output [15:0] Out;

  wire [47:0] ArrayInput_0, ArrayInput_1, ArrayInput_2;
  wire [15:0] Out_0, Out_1;

  // Configure inputs to multiplexor arrays
  assign ArrayInput_0 = {In[13], In[14], In[15], 
                         In[12], In[13], In[14], 
                         In[11], In[12], In[13],
                         In[10], In[11], In[12],
                         In[9], In[10], In[11],
                         In[8], In[9], In[10],
                         In[7], In[8], In[9],
                         In[6], In[7], In[8],
                         In[5], In[6], In[7],
                         In[4], In[5], In[6],
                         In[3], In[4], In[5],
                         In[2], In[3], In[4],
                         In[1], In[2], In[3],
                         In[0], In[1], In[2],
                         1'b0, In[0], In[1],
                         2'b0, In[0]};

  assign ArrayInput_1 = {Out_0[9], Out_0[12], Out_0[15],
                         Out_0[8], Out_0[11], Out_0[14],
                         Out_0[7], Out_0[10], Out_0[13],
                         Out_0[6], Out_0[9], Out_0[12],
                         Out_0[5], Out_0[8], Out_0[11],
                         Out_0[4], Out_0[7], Out_0[10],
                         Out_0[3], Out_0[6], Out_0[9],
                         Out_0[2], Out_0[5], Out_0[8],
                         Out_0[1], Out_0[4], Out_0[7],
                         Out_0[0], Out_0[3], Out_0[6],
                         1'b0, Out_0[2], Out_0[5],
                         1'b0, Out_0[1], Out_0[4],
                         1'b0, Out_0[0], Out_0[3],
                         2'b0, Out_0[2],
                         2'b0, Out_0[1],
                         2'b0, Out_0[0]};

  assign ArrayInput_2 = {1'b0, Out_1[6], Out_1[15],
                         1'b0, Out_1[5], Out_1[14],
                         1'b0, Out_1[4], Out_1[13],
                         1'b0, Out_1[3], Out_1[12],
                         1'b0, Out_1[2], Out_1[11],
                         1'b0, Out_1[1], Out_1[10],
                         1'b0, Out_1[0], Out_1[9],
                         2'b0, Out_1[8],
                         2'b0, Out_1[7],
                         2'b0, Out_1[6],
                         2'b0, Out_1[5],
                         2'b0, Out_1[4],
                         2'b0, Out_1[3],
                         2'b0, Out_1[2],
                         2'b0, Out_1[1],
                         2'b0, Out_1[0]};
  
  // Instantiate multiplexor arrays to perform shift
  Mux_3_1_Array Array_0(.In(ArrayInput_0), .Sel(Base3_0), .Out(Out_0));
  Mux_3_1_Array Array_1(.In(ArrayInput_1), .Sel(Base3_1), .Out(Out_1));
  Mux_3_1_Array Array_2(.In(ArrayInput_2), .Sel(Base3_2), .Out(Out));
endmodule