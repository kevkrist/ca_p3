// Array of 16 3-1 multiplexors for the shift unit
// author: Kevin Kristensen
module Mux_3_1_Array(In, Sel, Out);
  input [47:0] In;
  input [1:0] Sel;
  output [15:0] Out;

  Mux_3_1 M15(.Out(Out[15]), .In(In[47:45]), .Sel(Sel));
  Mux_3_1 M14(.Out(Out[14]), .In(In[44:42]), .Sel(Sel));
  Mux_3_1 M13(.Out(Out[13]), .In(In[41:39]), .Sel(Sel));
  Mux_3_1 M12(.Out(Out[12]), .In(In[38:36]), .Sel(Sel));
  Mux_3_1 M11(.Out(Out[11]), .In(In[35:33]), .Sel(Sel));
  Mux_3_1 M10(.Out(Out[10]), .In(In[32:30]), .Sel(Sel));
  Mux_3_1 M9(.Out(Out[9]), .In(In[29:27]), .Sel(Sel));
  Mux_3_1 M8(.Out(Out[8]), .In(In[26:24]), .Sel(Sel));
  Mux_3_1 M7(.Out(Out[7]), .In(In[23:21]), .Sel(Sel));
  Mux_3_1 M6(.Out(Out[6]), .In(In[20:18]), .Sel(Sel));
  Mux_3_1 M5(.Out(Out[5]), .In(In[17:15]), .Sel(Sel));
  Mux_3_1 M4(.Out(Out[4]), .In(In[14:12]), .Sel(Sel));
  Mux_3_1 M3(.Out(Out[3]), .In(In[11:9]), .Sel(Sel));
  Mux_3_1 M2(.Out(Out[2]), .In(In[8:6]), .Sel(Sel));
  Mux_3_1 M1(.Out(Out[1]), .In(In[5:3]), .Sel(Sel));
  Mux_3_1 M0(.Out(Out[0]), .In(In[2:0]), .Sel(Sel));
endmodule