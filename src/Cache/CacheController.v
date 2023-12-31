// Cach controller FSM
// The controller must handle the transfer of 8 2B chunks to deliver a full
// cache block to the cache
// author: Kevin Kristensen
module cache_fill_FSM(clk, // Inputs
                      rst_n,
                      miss_detected,
                      miss_address,
                      memory_stall,
                      fsm_busy, // Outputs
                      write_data_array,
                      write_tag_array,
                      memory_address,
                      memory_request,
                      cache_address);

  input clk, rst_n, miss_detected, memory_stall;
  input [15:0] miss_address;
  output reg fsm_busy, write_data_array, write_tag_array, memory_request;
  output reg [15:0] memory_address, cache_address;

  wire cur_state, 
       new_state, 
       dummy_overflow1, 
       dummy_overflow2; 
  reg state_wen, 
      count_wen,
      address_wen,
      rst_count;
  wire [15:0] cur_count, new_count, cur_address, add_address;
  reg [15:0] new_address;

  // Control switch to new state with write enable signal to state dff
  assign new_state = ~cur_state;

  // Idle: state = 0; Wait: state = 1
  // Freeze state when stall asserted by memory
  dff state(.q(cur_state), 
            .d(new_state),
            .wen(state_wen & ~memory_stall),
            .clk(clk),
            .rst(~rst_n));
  Register_16 count(.clk(clk),
                    .rst(rst_count | ~rst_n),
                    .In(new_count),
                    .WriteEnable(count_wen & ~memory_stall),
                    .Out(cur_count));

  // Functional units
  Adder_16bit count_adder(.Sum(new_count),
                          .Overflow(dummy_overflow1),
                          .A(cur_count),
                          .B(16'h0001),
                          .Sub(1'b0));
  Register_16 address(.clk(clk),
                      .rst(~rst_n),
                      .In(new_address),
                      .WriteEnable(address_wen),
                      .Out(cur_address));
  Adder_16bit address_adder(.Sum(add_address),
                            .Overflow(dummy_overflow2),
                            .A(cur_address),
                            .B(16'h0002),
                            .Sub(1'b0));   

  always @(cur_state, miss_detected, miss_address, cur_count) begin
    case(cur_state)
      0: begin // Currently in idle state.
        case(miss_detected)
          1: begin // Miss detected. Switch to wait state.
            fsm_busy = 1'b1; // Outputs
            write_data_array = 1'b0;
            write_tag_array = 1'b0;
            memory_address = miss_address & 16'hfff0; // Send request to memory
            cache_address = 16'h0000;
            state_wen = 1'b1; // Internal signals
            count_wen = 1'b0;
            rst_count = 1'b1;
            address_wen = 1'b1;
            // Ensure miss address is block-aligned
            new_address = miss_address & 16'hfff0;
            memory_request = 1'b1;
          end
          default: begin // No miss detected. Remain in idle state.
            fsm_busy = 1'b0; // Outputs
            write_data_array = 1'b0;
            write_tag_array = 1'b0;
            memory_address = 16'h0000;
            cache_address = 16'h0000;
            state_wen = 1'b0; // Internal signals
            count_wen = 1'b0;
            rst_count = 1'b0;
            address_wen = 1'b0;
            new_address = 16'h0000;
            memory_request = 1'b0;
          end
        endcase
      end
      1: begin // Currently in wait state.
        casex(cur_count)
          // Four cycles have elapsed. Memory is available to write to cache.
          16'h00?3, 16'h00?7, 16'h00?b, 16'h000f: begin
            fsm_busy = 1'b1; // Outputs
            write_data_array = 1'b1;
            write_tag_array = 1'b0;
            memory_address = add_address;
            cache_address = cur_address;
            state_wen = 1'b0; // Internal signals
            count_wen = 1'b1;
            rst_count = 1'b0;
            address_wen = 1'b1;
            new_address = add_address;
            memory_request = 1'b1;
          end
          16'h001f: begin // Memory transfer completed. Switch to idle state.
            fsm_busy = 1'b0; // Outputs
            write_data_array = 1'b1;
            write_tag_array = 1'b1;
            memory_address = 16'h0000;
            cache_address = cur_address;
            state_wen = 1'b1;
            count_wen = 1'b0;
            rst_count = 1'b1;
            address_wen = 1'b0;
            new_address = 16'h0000;
            memory_request = 1'b0;
          end
          default: begin // Remain in wait state.
            fsm_busy = 1'b1; // Outputs
            write_data_array = 1'b0;
            write_tag_array = 1'b0;
            memory_address = cur_address;
            cache_address = cur_address;
            state_wen = 1'b0; // Internal signals
            count_wen = 1'b1;
            rst_count = 1'b0;
            address_wen = 1'b0;
            new_address = cur_address;
            memory_request = 1'b0;
          end
        endcase
      end
      default: begin // Do nothing
        fsm_busy = 1'b0; // Outputs
        write_data_array = 1'b0;
        write_tag_array = 1'b0;
        memory_address = 16'h000;
        cache_address = 16'h0000;
        state_wen = 1'b0; // Internal signals
        count_wen = 1'b0;
        rst_count = 1'b0;
        address_wen = 1'b0;
        new_address = 16'h0000;
        memory_request = 1'b0;
      end
    endcase
  end

endmodule