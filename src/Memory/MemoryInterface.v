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
  assign DataOut = MemoryDataOut;

endmodule