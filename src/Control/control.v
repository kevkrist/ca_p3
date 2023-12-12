module CPU_control(opc, Br, Mem_En, Mem_Wr, RF_Wr, WB_Select, Flag_Wr, Use_Top);

input [15:12] opc;
output Br, Mem_En, Mem_Wr, RF_Wr, Flag_Wr, Use_Top;
output [1:0] WB_Select;

reg  r_Br, r_Mem_En, r_Mem_Wr, r_RF_Wr, r_WB_Select, r_Flag_Wr, r_Use_Top;
always @(*) begin
  casex (opc)
  4'b00??: begin        //ADD, SUB, XOR, RED
    r_Br = 0;
    r_Mem_En = 0;
    r_Mem_Wr = 0;
    r_RF_Wr = 1;
    r_WB_Select = 2'b00; //set to ALU
    r_Flag_Wr = (opc == 4'b0011 ? 0 : 1); //set to 0 for RED, 1 for ADD, SUB, XOR
    r_Use_Top = 0;
  end
  4'b0111: begin        //PADDSB
    r_Br = 0;
    r_Mem_En = 0;
    r_Mem_Wr = 0;
    r_RF_Wr = 1;
    r_WB_Select = 2'b00; //set to ALU
    r_Flag_Wr = 0; 
    r_Use_Top = 0;
  end
  4'b01??: begin        //Shift operations SLL SRA ROR
    r_Br = 0;
    r_Mem_En = 0;
    r_Mem_Wr = 0;
    r_RF_Wr = 1;
    r_WB_Select = 2'b00; //set to ALU
    r_Flag_Wr = 1;
    r_Use_Top = 0; 
  end
  4'b1000: begin        //LW
    r_Br = 0;
    r_Mem_En = 1;
    r_Mem_Wr = 0;
    r_RF_Wr = 1;
    r_WB_Select = 2'b01; // set to MEM
    r_Flag_Wr = 0; 
    r_Use_Top = 1;
  end
  4'b1001: begin        //SW
    r_Br = 0;
    r_Mem_En = 1;
    r_Mem_Wr = 1;
    r_RF_Wr = 0;
    r_WB_Select = 2'b01; // set to MEM 
    r_Flag_Wr = 0;
    r_Use_Top = 1;
  end
  4'b1010: begin        //LLB
    r_Br = 0;
    r_Mem_En = 0;
    r_Mem_Wr = 0;
    r_RF_Wr = 1;
    r_WB_Select = 2'b00; // set to ALU // send to a MUX? 
    r_Flag_Wr = 0;
    r_Use_Top = 1;
  end
  4'b1011: begin        //LHB
    r_Br = 0;
    r_Mem_En = 0;
    r_Mem_Wr = 0;
    r_RF_Wr = 1;
    r_WB_Select = 2'b00; // set to ALU send to a MUX?
    r_Flag_Wr = 0;
    r_Use_Top = 1;
  end
  4'b1100: begin        //B
    r_Br = 1;
    r_Mem_En = 0;
    r_Mem_Wr = 0;
    r_RF_Wr = 0;
    r_WB_Select = 2'b10; // set to PC
    r_Flag_Wr = 0;
    r_Use_Top = 0;
  end
  4'b1101: begin        //BR
    r_Br = 1;
    r_Mem_En = 0;
    r_Mem_Wr = 0;
    r_RF_Wr = 0;
    r_WB_Select = 2'b10; // set to PC
    r_Flag_Wr = 0;
    r_Use_Top = 0;
  end
  4'b1110: begin        //PCS
    r_Br = 1;
    r_Mem_En = 0;
    r_Mem_Wr = 0;
    r_RF_Wr = 1;
    r_WB_Select = 2'b10; // set to PC
    r_Flag_Wr = 0;
    r_Use_Top = 0;
  end
  4'b1111: begin        //HLT
    r_Br = 1;
    r_Mem_En = 0;
    r_Mem_Wr = 0;
    r_RF_Wr = 1;
    r_WB_Select = 2'b10; // set to PC
    r_Flag_Wr = 0;
    r_Use_Top = 0;
  end
  default: begin
    r_Br = 0;
    r_Mem_En = 0;
    r_Mem_Wr = 0;
    r_RF_Wr = 0;
    r_WB_Select = 2'b11; // set to nothing ??
    r_Flag_Wr = 0;
    r_Use_Top = 0;
  end
  endcase
end

assign Br = r_Br;
assign Mem_En = r_Mem_En;
assign Mem_Wr = r_Mem_Wr;
assign RF_Wr = r_RF_Wr;
assign WB_Select = r_WB_Select;
assign Flag_Wr = r_Flag_Wr;
assign Use_Top = r_Use_Top;

endmodule
