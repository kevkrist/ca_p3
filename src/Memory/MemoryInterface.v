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
                       output [15:0] InstructionMemDataOut,
                       output [15:0] InstructionMemAddressOut,
                       output InstructionCacheWriteEnable,
                       output [15:0] MemMemDataOut, // To MEM
                       output [15:0] MemMemAddressOut,
                       output MemCacheWriteEnable,
                       output MemMemStallOut);

endmodule