// Test bench for ALU (specifically LW, SW, LLB, LHB)
// author: Kevin Kristensen
module TestALU_2();
  reg [15:0] Reg1, Reg2;
  reg [7:0] Imm;
  reg [3:0] Opcode;
  wire [15:0] Output;
  wire [2:0] Flag;

  // Instantiate ALU
  Alu ALU(.Output(Output),
          .Flag(Flag),
          .Reg1(Reg1),
          .Reg2(Reg2),
          .Imm(Imm),
          .Opcode(Opcode));

  initial begin
    // Test 1: LW
    Reg1 = 16'h0001;
    Reg2 = 16'h0000;
    Imm = 16'h0005;
    Opcode = 4'b1000;

    #1
    if(Output != 16'h000a) begin
      $display("Test FAILED.");
    end else begin
      $display("Test PASSED.");
    end   
    $display("\tOUTPUT  =%d", Output);
    $display("\tEXPECTED=%d\n", 16'h000a);

    // Test 2: SW
    Reg1 = 16'h0010;
    Reg2 = 16'hffff;
    Imm = 16'hfffe;
    Opcode = 4'b1001;

    #1
    if(Output != 16'h000c) begin
      $display("Test FAILED.");
    end else begin
      $display("Test PASSED.");
    end   
    $display("\tOUTPUT  =%d", Output);
    $display("\tEXPECTED=%d\n", 16'h000c);

    // Test 3: LLB
    Reg1 = 16'h0a01;
    Reg2 = 16'h0000;
    Imm = 8'hf0;
    Opcode = 4'b1010;

    #1
    if(Output != 16'h0af0) begin
      $display("Test FAILED.");
    end else begin
      $display("Test PASSED.");
    end   
    $display("\tOUTPUT  =%d", Output);
    $display("\tEXPECTED=%d\n", 16'h0af0);

    // Test 4: LHB
    Reg1 = 16'habcd;
    Reg2 = 16'hffff;
    Imm = 8'h01;
    Opcode = 4'b1011;

    #1
    if(Output != 16'h01cd) begin
      $display("Test FAILED.");
    end else begin
      $display("Test PASSED.");
    end   
    $display("\tOUTPUT  =%d", Output);
    $display("\tEXPECTED=%d\n", 16'h01cd);

    // Test 5: XOR (w/ nonzero output)
    Reg1 = 16'b0000111100000101;
    Reg2 = 16'b0000101011111010;
    Imm = 8'h00;
    Opcode = 4'b0010;

    #1
    if(Output != 16'b0000010111111111 | Flag[0] != 1'b0) begin
      $display("Test FAILED.");
    end else begin
      $display("Test PASSED.");
    end   
    $display("\tOUTPUT  =%d", Output);
    $display("\tZ       =%b", Flag[0]);
    $display("\tEXPECTED=%d", 16'b0000010111111111);
    $display("\tZ EXP   =%b\n", 1'b0);

    // Test 6: SLL (w/ zero output)
    Reg1 = 16'hab00;
    Reg2 = 16'haaaa;
    Imm = 8'h08;
    Opcode = 4'b0100;

    #1
    if(Output != 16'h0000 | Flag[0] != 1'b1) begin
      $display("Test FAILED.");
    end else begin
      $display("Test PASSED.");
    end   
    $display("\tOUTPUT  =%d", Output);
    $display("\tZ       =%b", Flag[0]);
    $display("\tEXPECTED=%d", 16'h0000);
    $display("\tZ EXP   =%b\n", 1'b1);

    // Test 6: PADDSB (w/ zero output)
    Reg1 = 16'h0123;
    Reg2 = 16'h45f6;
    Imm = 8'h00;
    Opcode = 4'b0111;

    #1
    if(Output != 16'h4617) begin
      $display("Test FAILED.");
    end else begin
      $display("Test PASSED.");
    end   
    $display("\tOUTPUT  =%4h", Output);
    $display("\tEXPECTED=%4h\n", 16'h4617);

    // Test 7: SUB (w/ neg output)
    Reg1 = 16'h0005;
    Reg2 = 16'h0007;
    Imm = 8'h00;
    Opcode = 4'b0001;

    #1
    if(Output != 16'hfffe | Flag != 3'b100) begin
      $display("Test FAILED.");
    end else begin
      $display("Test PASSED.");
    end   
    $display("\tOUTPUT  =%d", $signed(Output));
    $display("\tFlag    =%3b", Flag);
    $display("\tEXPECTED=%d", $signed(16'hfffe));
    $display("\tFlag EXP=%3b\n", 3'b100);

    // Test 7: ADD (w/ overflow)
    Reg1 = 16'h7ffe;
    Reg2 = 16'h7ffe;
    Imm = 8'h00;
    Opcode = 4'b0000;

    #1
    if(Output != 16'h7fff | Flag != 3'b010) begin
      $display("Test FAILED.");
    end else begin
      $display("Test PASSED.");
    end   
    $display("\tOUTPUT  =%d", $signed(Output));
    $display("\tFlag    =%3b", Flag);
    $display("\tEXPECTED=%d", $signed(16'h7fff));
    $display("\tFlag EXP=%3b\n", 3'b010);
  end

endmodule