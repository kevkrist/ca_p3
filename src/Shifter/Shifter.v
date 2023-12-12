// 4-bit shifter from 3-1 multiplexors
// author: Kevin Kristensen
module Shifter(ShiftOut, ShiftIn, ShiftVal, Mode);
    input [15:0] ShiftIn;
    input [3:0] ShiftVal;
    input [1:0] Mode; // 0: SLL, 1: SRA, 2: ROR
    output reg [15:0] ShiftOut;

    wire [1:0] Base3_2, Base3_1, Base3_0;
    wire [15:0] SllOut, SraOut, RorOut;

    // Convert shamt to base-3 for use as selector signals for 3-1 multiplexors
    Base3Converter Conv(.Out0(Base3_0), 
                        .Out1(Base3_1), 
                        .Out2(Base3_2), 
                        .In(ShiftVal));

    ShiftLeftLogical Sll (.In(ShiftIn), 
                          .Base3_0(Base3_0),
                          .Base3_1(Base3_1),
                          .Base3_2(Base3_2),
                          .Out(SllOut));
    
    ShiftRightArithmetic Sra(.In(ShiftIn),
                             .Base3_0(Base3_0),
                             .Base3_1(Base3_1),
                             .Base3_2(Base3_2),
                             .Out(SraOut));

    RotateRight Ror(.In(ShiftIn),
                    .Base3_0(Base3_0),
                    .Base3_1(Base3_1),
                    .Base3_2(Base3_2),
                    .Out(RorOut));

    always @(Mode, SllOut, SraOut, RorOut) begin
      case(Mode)
        0: ShiftOut = SllOut;
        1: ShiftOut = SraOut;
        2: ShiftOut = RorOut;
        default: ShiftOut = 16'bX;
      endcase
    end

endmodule

// Base-3 converter. Out2 is highest digit, Out0 is lowest digit
module Base3Converter(Out0, Out1, Out2, In);
    input [3:0] In;
    output reg [1:0] Out2, Out1, Out0; // The three output digits

    always @(In) begin
        case(In)
            0: begin Out2 = 0; Out1 = 0; Out0 = 0; end
            1: begin Out2 = 0; Out1 = 0; Out0 = 1; end
            2: begin Out2 = 0; Out1 = 0; Out0 = 2; end
            3: begin Out2 = 0; Out1 = 1; Out0 = 0; end
            4: begin Out2 = 0; Out1 = 1; Out0 = 1; end
            5: begin Out2 = 0; Out1 = 1; Out0 = 2; end
            6: begin Out2 = 0; Out1 = 2; Out0 = 0; end
            7: begin Out2 = 0; Out1 = 2; Out0 = 1; end
            8: begin Out2 = 0; Out1 = 2; Out0 = 2; end
            9: begin Out2 = 1; Out1 = 0; Out0 = 0; end
            10: begin Out2 = 1; Out1 = 0; Out0 = 1; end
            11: begin Out2 = 1; Out1 = 0; Out0 = 2; end
            12: begin Out2 = 1; Out1 = 1; Out0 = 0; end
            13: begin Out2 = 1; Out1 = 1; Out0 = 1; end
            14: begin Out2 = 1; Out1 = 1; Out0 = 2; end
            15: begin Out2 = 1; Out1 = 2; Out0 = 0; end
        endcase
    end
endmodule