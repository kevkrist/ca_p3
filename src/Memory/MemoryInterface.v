// Interface for the multicycle memory
// author: Kevin Kristensen
module MemoryInterface(input clk, // INPUTS
                       input rst,
                       input InstructionMemRequest,
                       input [15:0] InstructionMemAddress,
                       input MemMemRequest,
                       input MemMemWrite,
                       input [15:0] MemMemAddress,
                       input [15:0] MemMemData,
                       output InstructionMemStallOut, // To IF
                       output [15:0] DataOut); // To IF / MEM

  wire [15:0] MemoryDataOut, MemoryDataIn, MemoryAddress;
  wire MemoryEnable, MemoryWrite, ValidDummy;

  // Adjudication mechanism between memory request and instruction request
  assign MemoryAddress = MemMemRequest ? MemMemAddress :
                         InstructionMemRequest ? InstructionMemAddress
                                               : 16'h0000;
  assign MemoryDataIn = MemMemRequest ? MemMemData : 16'h0000;
  assign MemoryWrite = MemMemRequest & MemMemWrite;
  assign MemoryEnable = MemMemRequest | InstructionMemRequest;
  assign InstructionMemStallOut = MemMemRequest & InstructionMemRequest;

  memory4c Memory4C(.data_out(MemoryDataOut), // OUTPUT
                    .data_in(MemoryDataIn), // INPUT
                    .addr(MemoryAddress),
                    .enable(MemoryEnable),
                    .wr(MemoryWrite),
                    .clk(clk),
                    .rst(rst),
                    .data_valid(ValidDummy)); // Ignore valid bit

/* THE FOLLOWING OVERCOMPLICATES THINGS (I THINK)
  reg MemoryWrite, MemoryEnable;
  reg [2:0] CurState, NewState;
  reg [15:0] CurCount, 
             CurCount1, 
             NewCount, 
             MemoryDataOut, 
             MemoryDataIn, 
             MemoryAddress;
  wire ValidDummy, OverflowDummy;

  // MSB: 0 = idle, 1 = busy
  // LSB: 0 = read, 1 = write
  Register_2 State(.clk(clk),
                   .rst(rst),
                   .In(NewState),
                   .WriteEnable(),
                   .Out(CurState));
  Register_16 count(.clk(clk),
                    .rst(rst),
                    .In(NewCount),
                    .WriteEnable(),
                    .Out(CurCount));
  Adder_16bit CountAdder(.Sum(CurCount1),
                         .Overflow(OverflowDummy),
                         .A(CurCount),
                         .B(16'h001),
                         .Sub(1'b0));

  always @(CurState, 
           CurCount,
           CurCount1, 
           InstructionMemRequest, 
           MemMemRequest, 
           MemMemWrite,
           MemMemData,
           MemMemAddress) begin
    casex(CurState)
      2'b0?: begin // Currently idle.
        casex({MemMemRequest, InstructionMemRequest})
          2'b1?: begin // Service MEM request
            NewState = MemMemWrite? 2'b11 :  2'b10;
            MemoryEnable = 1'b1;
            MemoryWrite = MemMemWrite? 1'b1 : 1'b0;
            MemoryDataIn = MemMemData;
            MemoryAddress = MemMemAddress;
            NewCount = 16'h0000;
          end
          2'b01: begin // Service IF request
            NewState = 2'b10;
            MemoryEnable = 1'b1;
            MemoryWrite = 1'b0;
            MemoryDataIn = 16'h000;
            MemoryAddress = InstructionMemAddress;
            NewCount = 16'h000;
          end
          default: begin // No request, remain idle
            NewState = 2'b00;
            MemoryEnable = 1'b0;
            MemoryWrite = 1'b0;
            MemoryDataIn = 16'h000;
            MemoryAddress = 16'h000;
            NewCount = 16'h000;
          end
        endcase
      end
      2'b10: begin // Busy, servicing read
        case(CurCount)
          16'h004: begin // Memory is ready
            
          end
          default: begin // Memory is not ready
            NewState = CurState;
            MemoryEnable = 1'b1;
            MemoryWrite = 1'b0;
            MemoryDataIn  = 16'h0000;
            MemoryAddress = 
            NewCount = CurCount1;
          end
        endcase
      end
      2'b11: begin // Busy, servicing write (only takes 1 cycle)
        case(InstructionMemRequest)
          1: begin // Remain busy, service instruction request
            NewState = 2'b10;
            MemoryEnable = 1'b1;
            MemoryWrite = 1'b0;
            MemoryDataIn = 16'h0000;
            MemoryAddress = InstructionMemAddress;
            NewCount = 16'h000;
          end
          default: begin // Switch to idle state
            NewState = 2'b00;
            MemoryEnable = 1'b0;
            MemoryWrite = 1'b0;
            MemoryDataIn = 16'h0000;
            MemoryAddress = 16'h0000;
            NewCount = 16'h0000;
          end
        endcase
      end
      default: begin // Default to doing nothing
        NewState = CurState;
        MemoryEnable = 1'b0;
        MemoryWrite = 1'b0;
        MemoryDataIn = 16'h0000;
        MemoryAddress = 16'h0000;
        NewCount = 16'h0000;
      end
    endcase
  end

  memory4c Memory4C(.data_out(MemoryDataOut), // OUTPUT
                    .data_in(MemoryDataIn), // INPUT
                    .addr(MemoryAddress),
                    .enable(MemoryEnable),
                    .wr(MemoryWrite),
                    .clk(clk),
                    .rst(rst),
                    .data_valid(ValidDummy)); // Ignore valid bit */

endmodule