`timescale 1ns / 10ps

module KernelAccumulator #(
    // parameter [3:0] SIZE = 4'd3
)(
    input logic clk, n_rst,
    input logic [7:0] kernel_v, pixel_v,
    // input logic done,
    // input logic [3:0] cur_x, cur_y,
    input logic clear, start,
    output logic ready, clear_flag,
    output logic [7:0] sum
);

typedef enum bit [1:0] {
    IDLE =  2'd0,
    RESET = 2'd1,
    COMP_IDLE =  2'd2,
    SUM0 =  2'd3
} ACCU;

ACCU state, nextState;

logic [15:0] nextSum, bufferSum, temp_kv, temp_pv, product, nextProduct;
assign temp_kv = {8'b0, kernel_v};
assign temp_pv = {8'b0, pixel_v};
assign sum = bufferSum[15:8]; // Takes the 8 LSBs of the sum
// This is done to account for the mulitplication by decimal
// Stores the value stored at the kernel/pixel indexed

always_ff @(posedge clk, negedge n_rst) begin
    if (~n_rst) begin 
        bufferSum <= '0;
        product <= '0;
        state <= IDLE;
    end
    else begin 
        bufferSum <= nextSum;
        product <= nextProduct;
        state <= nextState;
    end
end

always_comb begin : Summing_Logic
    // nextProduct = '0;
    nextSum = '0;
    case (state)
        IDLE: begin
            nextSum = bufferSum;
            // nextProduct = '0;
        end
        RESET: begin
            nextSum = '0;
            // nextProduct = '0;
        end
        COMP_IDLE: begin
            nextSum = bufferSum;

        end
        SUM0: begin
            nextSum = bufferSum + (temp_kv * temp_pv);
        end
        default: begin
            nextSum = bufferSum;
            // nextProduct = '0;
        end
    endcase
end

always_comb begin : Accumulator_Control_FSM
    nextState = IDLE;
    ready = 1'b0;
    clear_flag = 1'b0;
    case (state)
        IDLE: begin
            if (clear) nextState = RESET;
            else if (start) nextState = SUM0;
            else nextState = state;
            ready = 1'b0;
            clear_flag = 1'b0;
        end
        RESET: begin
            nextState = IDLE;
            ready = 1'b0;
            clear_flag = 1'b1;
        end
        COMP_IDLE: begin
            if (start) nextState = SUM0;
            else nextState = IDLE;
            ready = 1'b1;
        end
        SUM0: begin
            nextState = COMP_IDLE;
            ready = 1'b0;
            clear_flag = 1'b0;
        end
        default: begin
            nextState = IDLE;
            ready = 1'b0;
            clear_flag = 1'b0;
        end
    endcase
end

// AccumulatorControl controller (
//     .clk(clk),
//     .n_rst(n_rst),
//     .clear(clear),
//     .start(start),
//     .dest(dest),
//     .ready(ready),
//     .state(state));

endmodule
