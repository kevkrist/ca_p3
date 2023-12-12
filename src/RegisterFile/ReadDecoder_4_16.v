// 4-16 read decoder
// author: Kevin Kristensen
module ReadDecoder_4_16(RegId, Wordline);
    input [3:0] RegId;
    output [15:0] Wordline;
    wire [15:0] Wordline0, Wordline1, Wordline2, Wordline3;

    assign Wordline0 = 16'h0001;
    assign Wordline1 = RegId[0] ? Wordline0 << 1 : Wordline0;
    assign Wordline2 = RegId[1] ? Wordline1 << 2 : Wordline1;
    assign Wordline3 = RegId[2] ? Wordline2 << 4 : Wordline2;
    assign Wordline = RegId[3] ? Wordline3 << 8 : Wordline3;
endmodule