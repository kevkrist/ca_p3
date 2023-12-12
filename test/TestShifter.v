// Test bench for 16-bit shifter (project)
module TestShifter;
  // Module inputs and outputs. Loop variable.
  reg [15:0] ShiftIn, ShiftTrue;
  wire [15:0] ShiftOut;
  reg [3:0] ShiftVal;
  reg [1:0] Mode;
  integer i, j; // Loop vars

  // Instantiate module
  Shifter Shift(.ShiftOut(ShiftOut), 
                .ShiftIn(ShiftIn), 
                .ShiftVal(ShiftVal), 
                .Mode(Mode));

  // Test
  initial begin
    $random(123); // Change to explore different inputs,
                  // or set ShiftIn here to explore specific values
    for(j=0; j<3; j=j+1) begin
      // Set input (toggle between random and hard-coded)
      // ShiftIn = $random;
      ShiftIn = 16'hab00;
      Mode = j;

      // Loop over shift amounts
      for(i=0; i<16; i=i+1) begin
        ShiftVal = i;
      
        // Gather true values
        if(Mode == 0) begin // sll
          ShiftTrue = ShiftIn << ShiftVal;
        end else if(Mode == 1) begin // sra
          ShiftTrue = $signed(ShiftIn) >>> ShiftVal;
        end else begin // ror
          ShiftTrue = (ShiftIn >> ShiftVal) | (ShiftIn << (16 - ShiftVal));
        end

        // Propagate inputs
        #1;
  
        // Test outputs
        if(ShiftTrue != ShiftOut) begin
          $display("TEST FAILED");
          $display("\tINPUT    Shift_In =%16b, Shift_Val=%d, Mode=%d", 
                   ShiftIn, 
                   ShiftVal, 
                   Mode);
          $display("\tOUTPUT   Shift_Out=%16b", ShiftOut);
          $display("\tEXPECTED Shift_Out=%16b\n", ShiftTrue);
        end else begin
          $display("TEST PASSED");
          $display("\tINPUT    Shift_In =%16b, Shift_Val=%d, Mode=%d", 
                   ShiftIn, 
                   ShiftVal, 
                   Mode);
          $display("\tOUTPUT   Shift_Out=%16b\n", ShiftOut);
        end      
      end
    end
  end
endmodule