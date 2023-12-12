module CLA9_tb();

    reg [7:0] A, B;
    reg [8:0] Expected;
    wire [8:0] Sum;
    reg Ci;
    wire Co;

    CLA_9bit cla(
        .A(A),
        .B(B),
        .Sum(Sum),
        .Ci(Ci),
        .Co(Co)
    );

    initial begin
        $random;

        repeat(10) begin
            //A=$random;
            //B=$random;

            $display("Testing...");
            A = 8'b1111_1110;
            B = 8'b0000_0001;
            Ci = 1;
            Expected = A + B + Ci;
            
            
            #10;

            if(Co != 1)begin
                $display("Failed COUT--------------------");
                $stop();
            end
            // if (Sum != Expected) begin
            //     $display("Failed--------------------");
            //     $display(A);
            //     $display(B);
            //     $display(Sum);
            //     $display(Expected);
            //     $stop();
            // end
        end

        $display("SUCCESS");
    end

endmodule