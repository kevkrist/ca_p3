// 4-16 write decoder
// author: Kevin Kristensen
module WriteDecoder_4_16(RegId, WriteReg, Wordline);
    input [3:0] RegId;
    input WriteReg;
    output [15:0] Wordline;
    wire [15:0] TempWordline;

    ReadDecoder_4_16 Decode(.RegId(RegId), .Wordline(TempWordline));
    assign Wordline = WriteReg ? TempWordline : 16'h0000;
endmodule