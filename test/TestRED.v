module RED_tb;

  reg [15:0] rs;
  reg [15:0] rt;
  wire [15:0] rd;
  reg [15:0] pass;

  RED uut (
    .rs(rs),
    .rt(rt),
    .rd(rd)
  );

  initial begin

    rs = 16'b0000_0001_0000_0001; // aaaaaaaa_bbbbbbbb
    rt = 16'b0000_0001_0000_0001; // cccccccc_dddddddd
    //ac = 1100101
    //bd = 10100100
    //ex = 100001001

    //rs = 16'b0000_0000_0000_0000; // aaaaaaaa_bbbbbbbb
    //rt = 16'b0000_0000_0000_0000; // cccccccc_dddddddd
    

    #5;
    $display("rs = %b", rs);
    $display("rt = %b", rt);

    //pass = (rd == 16'b1111_1111_0000_1001); // Expected result
    pass = (rd == 16'b0000_0000_0000_0100); // Expected result

    $display("rd = %b", rd);
    $display("ex = %b", 16'b1111_1111_0000_1001);
    $display("Test %s", pass ? "passed" : "failed");

    $stop();
  end

endmodule
