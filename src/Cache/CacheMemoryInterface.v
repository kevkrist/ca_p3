module CacheMemoryInterface(
    input wire clk,
    input wire rst,
    input wire i_cache_request,
    input wire [15:0] i_cache_address,
    input wire d_cache_request,
    input wire [15:0] d_cache_address,
    input wire mem_ready,
    output reg i_cache_grant,
    output reg i_cache_stall,
    output reg d_cache_grant,
    output reg d_cache_stall,
    output reg [15:0] mem_address_out,
    output reg mem_request
);

parameter IDLE = 2'b00;
parameter D_CACHE_ACTIVE = 2'b01;
parameter I_CACHE_ACTIVE = 2'b10;

reg [1:0] state, next_state;

always @(rst) begin
    case (rst) 
        1: begin
            state <= IDLE;
        end 
        0: begin
        state <= next_state;
        end
    endcase
end

always @(*) begin
    case (state)
        IDLE: begin
            case ({d_cache_request, i_cache_request})
                2'b10: next_state = D_CACHE_ACTIVE; // D-cache has priority
                2'b11: next_state = D_CACHE_ACTIVE;
                2'b01: next_state = I_CACHE_ACTIVE; // No D-cache request, but I-cache is requesting
                default: next_state = IDLE; // No requests
            endcase
        end
        D_CACHE_ACTIVE: begin
            next_state = mem_ready ? IDLE : D_CACHE_ACTIVE; // Remain active until mem_ready
        end
        I_CACHE_ACTIVE: begin
            next_state = mem_ready ? IDLE : I_CACHE_ACTIVE; // Remain active until mem_ready
        end
        default: next_state = IDLE;
    endcase
end

always @(*) begin
    case (state)
        IDLE: begin
            mem_request = (d_cache_request | i_cache_request);
            mem_address_out = d_cache_request ? d_cache_address : i_cache_address;
            i_cache_grant = i_cache_request & ~d_cache_request;
            d_cache_grant = d_cache_request;
        end
        D_CACHE_ACTIVE: begin
            d_cache_grant = 1;
            i_cache_stall = 1;
            mem_address_out = d_cache_address;
            mem_request = 1;
        end
        I_CACHE_ACTIVE: begin
            i_cache_grant = 1;
            d_cache_stall = 1;
            mem_address_out = i_cache_address;
            mem_request = 1;
        end
        default: begin
            i_cache_grant = 0;
            i_cache_stall = 0;
            d_cache_grant = 0;
            d_cache_stall = 0;
            mem_request = 0;
            mem_address_out = 16'b0; 
        end
    endcase
end

endmodule
