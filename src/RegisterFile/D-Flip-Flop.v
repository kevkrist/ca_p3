// Gokul's D-flipflop
// author: provided by instructor team
module dff (q, // DFF output
            d, // DFF input
            wen, // Write Enable
            clk, // Clock
            rst); // Reset (used synchronously)
  output q; 
  input d, wen, clk, rst;
  reg state;

  assign q = state;
  always @(posedge clk) begin
    state = rst ? 0 : (wen ? d : state);
  end
endmodule
