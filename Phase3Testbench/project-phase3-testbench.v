module cpu_ptb();
  

   wire [15:0] PC;
   wire [15:0] Inst;           /* This should be the 15 bits of the FF that
                                  stores instructions fetched from instruction memory
                               */
   wire        RegWrite;       /* Whether register file is being written to */
   wire [3:0]  WriteRegister;  /* What register is written */
   wire [15:0] WriteData;      /* Data */
   wire        MemWrite;       /* Similar as above but for memory */
   wire        MemRead;
   wire [15:0] MemAddress;
   wire [15:0] MemDataIn;	/* Read from Memory */
   wire [15:0] MemDataOut;	/* Written to Memory */
   wire        DCacheHit;
   wire        ICacheHit;
   wire        DCacheReq;
   wire        ICacheReq;

   wire        Halt;         /* Halt executed and in Memory or writeback stage */
        
   integer     inst_count;
   integer     cycle_count;

   integer     trace_file;
   integer     sim_log_file;


   integer     DCacheHit_count;
   integer     ICacheHit_count;
   integer     DCacheReq_count;
   integer     ICacheReq_count;


   reg clk; /* Clock input */
   reg rst_n; /* (Active low) Reset input */

     

   cpu DUT(.clk(clk), .rst_n(rst_n), .pc(PC), .hlt(Halt)); /* Instantiate your processor */
   






   /* Setup */
   initial begin
      $display("Hello world...simulation starting");
      $display("See verilogsim.plog and verilogsim.ptrace for output");
      inst_count = 0;
      DCacheHit_count = 0;
      ICacheHit_count = 0;
      DCacheReq_count = 0;
      ICacheReq_count = 0;

      trace_file = $fopen("TestOutput/Test2/verilogsim.ptrace");
      sim_log_file = $fopen("TestOutput/Test2/verilogsim.plog");
      
   end





  /* Clock and Reset */
// Clock period is 100 time units, and reset length
// to 201 time units (two rising edges of clock).

   initial begin
      $dumpvars;
      cycle_count = 0;
      rst_n = 0; /* Intial reset state */
      clk = 1;
      #201 rst_n = 1; // delay until slightly after two clock periods
    end

    always #50 begin   // delay 1/2 clock period each time thru loop
      clk = ~clk;
    end
	
    always @(posedge clk) begin
    	cycle_count = cycle_count + 1;
	if (cycle_count > 100000) begin
		$display("hmm....more than 100000 cycles of simulation...error?\n");
		$finish;
	end
    end








  /* Stats */
   always @ (posedge clk) begin
      if (rst_n) begin
         if (Halt || RegWrite || MemWrite) begin
            inst_count = inst_count + 1;
         end
	 if (DCacheHit) begin
            DCacheHit_count = DCacheHit_count + 1;	 	
         end	
	 if (ICacheHit) begin
            ICacheHit_count = ICacheHit_count + 1;	 	
	 end    
	 if (DCacheReq) begin
            DCacheReq_count = DCacheReq_count + 1;	 	
         end	
	 if (ICacheReq) begin
            ICacheReq_count = ICacheReq_count + 1;	 	
	 end 

         $fdisplay(sim_log_file, "SIMLOG:: Cycle %d PC: %8x I: %8x R: %d %3d %8x M: %d %d %8x %8x %8x",
                  cycle_count,
                  PC,
                  Inst,
                  RegWrite,
                  WriteRegister,
                  WriteData,
                  MemRead,
                  MemWrite,
                  MemAddress,
                  MemDataIn,
		  MemDataOut);
         if (RegWrite) begin
            $fdisplay(trace_file,"REG: %d VALUE: 0x%04x",
                      WriteRegister,
                      WriteData );            
         end
         if (MemRead) begin
            $fdisplay(trace_file,"LOAD: ADDR: 0x%04x VALUE: 0x%04x",
                      MemAddress, MemDataOut );
         end

         if (MemWrite) begin
            $fdisplay(trace_file,"STORE: ADDR: 0x%04x VALUE: 0x%04x",
                      MemAddress, MemDataIn  );
         end
         if (Halt) begin
            $fdisplay(sim_log_file, "SIMLOG:: Processor halted\n");
            $fdisplay(sim_log_file, "SIMLOG:: sim_cycles %d\n", cycle_count);
            $fdisplay(sim_log_file, "SIMLOG:: inst_count %d\n", inst_count);
            $fdisplay(sim_log_file, "SIMLOG:: dcachehit_count %d\n", DCacheHit_count);
            $fdisplay(sim_log_file, "SIMLOG:: icachehit_count %d\n", ICacheHit_count);
            $fdisplay(sim_log_file, "SIMLOG:: dcachereq_count %d\n", DCacheReq_count);
            $fdisplay(sim_log_file, "SIMLOG:: icachereq_count %d\n", ICacheReq_count);


            $fclose(trace_file);
            $fclose(sim_log_file);
	    #5;
            $finish;
         end 
      end
      
   end
   /* Assign internal signals to top level wires
      The internal module names and signal names will vary depending
      on your naming convention and your design */

   // Edit the example below. You must change the signal
   // names on the right hand side
    
//   assign PC = DUT.fetch0.pcCurrent; //You won't need this because it's part of the main cpu interface
   
//   assign Halt = DUT.memory0.halt; //You won't need this because it's part of the main cpu interface
   // Is processor halted (1 bit signal)
   

   assign Inst = DUT.IF_Instruction;
   //Instruction fetched in the current cycle
   
   assign RegWrite = DUT.GlobalStall ? 1'b0 : DUT.WB_RF_Wr;
   // Is register file being written to in this cycle, one bit signal (1 means yes, 0 means no)
  
   assign WriteRegister = DUT.WB_RegWrite;
   // If above is true, this should hold the name of the register being written to. (4 bit signal)
   
   assign WriteData = DUT.WB_WriteData;
   // If above is true, this should hold the Data being written to the register. (16 bits)
   
   assign MemRead = DUT.GlobalStall ? 1'b0 : (DUT.MEM_En & ~DUT.MEM_Wr);
   // Is memory being read from, in this cycle. one bit signal (1 means yes, 0 means no)
   
   assign MemWrite = DUT.GlobalStall ? 1'b0 : (DUT.MEM_En & DUT.MEM_Wr);
   // Is memory being written to, in this cycle (1 bit signal)
   
   assign MemAddress = DUT.MEM_ALUOut;
   // If there's a memory access this cycle, this should hold the address to access memory with (for both reads and writes to memory, 16 bits)
   
   assign MemDataIn = ((DUT.MEM_Opcode == 4'b1001) 
                       & (DUT.WB_Opcode == 4'b1000) 
                       & (DUT.MEM_SrcReg1 == DUT.WB_RegWrite)) ? DUT.WB_MemOut 
                                                               : DUT.MEM_RegRead1;
   // If there's a memory write in this cycle, this is the Data being written to memory (16 bits)
   
   assign MemDataOut = DUT.MEM_Out;
   // If there's a memory read in this cycle, this is the data being read out of memory (16 bits)

   assign ICacheReq = ~DUT.Fetch.InstructionCache.CacheEnable;
   // Signal indicating a valid instruction read request to cache
   
   assign ICacheHit = ~DUT.Fetch.InstructionCache.Miss;
   // Signal indicating a valid instruction cache hit

   assign DCacheReq = DUT.Memory.MemoryCache.CacheEnable;
   // Signal indicating a valid instruction data read or write request to cache
   
   assign DCacheHit = ~DUT.Memory.MemoryCache.Miss;
   // Signal indicating a valid data cache hit

   
endmodule
