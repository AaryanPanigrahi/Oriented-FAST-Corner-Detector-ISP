`timescale 1ns / 10ps

module ComputeKernel #(
    parameter [3:0] SIZE = 4'd3
)(
    input logic clk, n_rst,
    input logic [SIZE-1:0][SIZE-1:0][7:0] input_matrix, kernel,
    input logic start,
    input logic clear,
    output logic [7:0] blurred_pixel,
    output logic done,
    output logic clear_flag
);
logic readyFlag;  // Ready signal for moving through rows/columnsd
logic [3:0] cur_x, cur_y; // Indexs of the array
logic contConv;   // Prevents the counter from moving forward until the matrix is ready
logic [7:0] kernel_v, pixel_v; // Holds the value of the current cell
logic temp_rollover, done_in_the_next_cycle;

logic end_pos;

assign done_in_the_next_cycle = contConv && end_pos && readyFlag;

always_ff @(posedge clk, negedge n_rst) begin : Computation_FF
    if (~n_rst) begin
        contConv <= 1'b0;
        done <= 1'b0;
    end
    else begin
        done <= done_in_the_next_cycle;
        if (!done_in_the_next_cycle) contConv <= 1'b0;
        if (start) contConv <= 1'b1;
    end
end

logic single_pulse_start, start_prev;
always_ff @(posedge clk, negedge n_rst) begin
    if (!n_rst) start_prev <= 0;
    else start_prev <= start;
end

assign single_pulse_start = start && !start_prev;

pixel_pos #(.X_MAX(SIZE), .Y_MAX(SIZE), .MODE(1)) get_position (
    .clk(clk), .n_rst(n_rst),
    .new_trans(single_pulse_start),
    .max_x(SIZE), .max_y(SIZE),
    .update_pos(readyFlag && (contConv)),
    .curr_y(cur_y), .curr_x(cur_x),
    .end_pos(end_pos), .next_dir());

KernelAccumulator get_accumulator (
    .clk(clk),
    .n_rst(n_rst),
    .kernel_v(kernel_v),
    .pixel_v(pixel_v),
    .start(contConv),
    .clear(clear),
    .ready(readyFlag),
    .clear_flag(clear_flag),
    .sum(blurred_pixel));

MatrixIndex #(.SIZE(SIZE)) get_index (
    .clk(clk),
    .n_rst(n_rst),
    .cur_x(cur_x),
    .cur_y(cur_y),
    .kernel(kernel),
    .in(input_matrix),
    .en_strobe(readyFlag),
    .kernel_v(kernel_v),
    .pixel_v(pixel_v));

endmodule
