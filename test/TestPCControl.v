// Test bench for PC control
// author: Kevin Kristensen
module TestPCControl();
  reg Branch;
  reg [1:0] BranchType;
  reg [2:0] C, F; // Condition code and flag register
  reg [8:0] I; // Immediate PC-relative branch destination
  reg [15:0] Reg, PC_In;
  wire [15:0] PC_Out;

  reg [15:0] PC_OutTrue;

  // Instantiate modules
  PC_control PCC(.Branch(Branch),
                 .BranchType(BranchType),
                 .C(C), 
                 .I(I), 
                 .F(F), 
                 .Reg(Reg), 
                 .PC_In(PC_In), 
                 .PC_Out(PC_Out));
  
  // Test suite
  initial begin
    // Test 1: No branch
    Branch = 1'b0;
    BranchType = 2'b00;
    C = 3'b000;
    I = {8{1'b0}};
    F = 3'b000;
    Reg = {16{1'b0}};
    PC_In = 16'b0000000000000010;
    PC_OutTrue = 16'b0000000000000100;
    #1;

    // Test outputs
    if(PC_Out == PC_OutTrue) begin
      $display("Test PASSED.");
    end else begin
      $display("Test FAILED.");
      $display("\tInput:  PC_In=%d", PC_In);
      $display("\tOutput: PC_Out=%d", PC_Out);
      $display("\tTruth:  PC_True=%d", PC_OutTrue);
    end

    // Test 2: Branch on equal
    Branch = 1'b1;
    BranchType = 2'b00;
    C = 3'b001;
    I = 8'b00000011;
    F = 3'b001; // Branch on equal
    Reg = {16{1'b0}};
    PC_In = 16'b0000000000000100;
    PC_OutTrue = 16'b0000000000001100;
    #1;

    // Test outputs
    if(PC_Out == PC_OutTrue) begin
      $display("Test PASSED.");
    end else begin
      $display("Test FAILED.");
      $display("\tInput:  PC_In=%d", PC_In);
      $display("\tOutput: PC_Out=%d", PC_Out);
      $display("\tTruth:  PC_True=%d", PC_OutTrue);
    end

    // Test 3: Branch register on greater than
    Branch = 1'b1;
    BranchType = 2'b01;
    C = 3'b010;
    I = 8'b00000000;
    F = 3'b000; // Branch on greater than
    Reg = 16'b0000000011111110;
    PC_In = 16'b0000000000000110;
    PC_OutTrue = 16'b0000000011111110;
    #1;

    // Test outputs
    if(PC_Out == PC_OutTrue) begin
      $display("Test PASSED.");
    end else begin
      $display("Test FAILED.");
      $display("\tInput:  PC_In=%d", PC_In);
      $display("\tOutput: PC_Out=%d", PC_Out);
      $display("\tTruth:  PC_True=%d", PC_OutTrue);
    end

    // Test 4: PCS
    Branch = 1'b1;
    BranchType = 2'b10;
    C = 3'b111;
    I = 8'b00000011;
    F = 3'b000;
    Reg = 16'b0000000000000000;
    PC_In = 16'b0000000000001000;
    PC_OutTrue = 16'b0000000000001010;
    #1;

    // Test outputs
    if(PC_Out == PC_OutTrue) begin
      $display("Test PASSED.");
    end else begin
      $display("Test FAILED.");
      $display("\tInput:  PC_In=%d", PC_In);
      $display("\tOutput: PC_Out=%d", PC_Out);
      $display("\tTruth:  PC_True=%d", PC_OutTrue);
    end

    // Test 5: HLT
    Branch = 1'b1;
    BranchType = 2'b11;
    C = 3'b101;
    I = 8'b00000011;
    F = 3'b000;
    Reg = 16'b0000000000000110;
    PC_In = 16'b0000000000001100;
    PC_OutTrue = 16'b0000000000001100;
    #1;

    // Test outputs
    if(PC_Out == PC_OutTrue) begin
      $display("Test PASSED.");
    end else begin
      $display("Test FAILED.");
      $display("\tInput:  PC_In=%d", PC_In);
      $display("\tOutput: PC_Out=%d", PC_Out);
      $display("\tTruth:  PC_True=%d", PC_OutTrue);
    end

    // Test 5: Branch with failed condition
    Branch = 1'b1;
    BranchType = 2'b00;
    C = 3'b011; // Branch on less than
    I = 8'b00000011;
    F = 3'b001; // Not less than
    Reg = 16'b0000000000000110;
    PC_In = 16'b0000000000001110;
    PC_OutTrue = 16'b0000000000010000;
    #1;

    // Test outputs
    if(PC_Out == PC_OutTrue) begin
      $display("Test PASSED.");
    end else begin
      $display("Test FAILED.");
      $display("\tInput:  PC_In=%d", PC_In);
      $display("\tOutput: PC_Out=%d", PC_Out);
      $display("\tTruth:  PC_True=%d", PC_OutTrue);
    end

    // Test 6: Branch register with different condition
    Branch = 1'b1;
    BranchType = 2'b01;
    C = 3'b111; // Branch unconditionally
    I = 8'b00000011;
    F = 3'b101; 
    Reg = 16'b0000000000001010;
    PC_In = 16'b0000000011101110;
    PC_OutTrue = 16'b0000000000001010;
    #1;

    // Test outputs
    if(PC_Out == PC_OutTrue) begin
      $display("Test PASSED.");
    end else begin
      $display("Test FAILED.");
      $display("\tInput:  PC_In=%d", PC_In);
      $display("\tOutput: PC_Out=%d", PC_Out);
      $display("\tTruth:  PC_True=%d", PC_OutTrue);
    end
  end
endmodule