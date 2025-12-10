`timescale 1ns / 10ps

module ComputeKernel #(
    parameter MAX_KERNEL = 3
)(
    input logic clk, n_rst,
    input logic [MAX_KERNEL-1:0][MAX_KERNEL-1:0][7:0] input_matrix, kernel,
    input logic [$clog2(MAX_KERNEL)-1:0] kernel_size,
    input logic start,
    output logic clear_flag,
    input logic clear,
    output logic done,
    output logic [7:0] blurred_pixel
);

logic readyFlag, readyFlag_prev;  // Ready signal for moving through rows/columns
logic [$clog2(MAX_KERNEL)-1:0] cur_x, cur_y; // Indexs of the array
logic contConv;   // Prevents the counter from moving forward until the matrix is ready
logic [7:0] kernel_v, pixel_v; // Holds the value of the current cell
logic end_pos, end_pos_prev;

always_ff @(posedge clk, negedge n_rst) begin
    if (!n_rst) readyFlag_prev <= 0;
    else        readyFlag_prev <= readyFlag;
end

assign done = readyFlag && !readyFlag_prev && !contConv && end_pos_prev;
 
always_ff @(posedge clk, negedge n_rst) begin
    if (!n_rst) end_pos_prev <= 0;
    else begin
        if (readyFlag && (contConv))
            end_pos_prev <= end_pos;
    end
end


always_ff @(posedge clk, negedge n_rst) begin : Computation_FF
    if (~n_rst) begin
        contConv <= 1'b0;
    end
    else begin
        if (end_pos_prev) contConv <= 1'b0;
        if (start) contConv <= 1'b1;
    end
end

logic single_pulse_start, start_prev;
always_ff @(posedge clk, negedge n_rst) begin
    if (!n_rst) start_prev <= 0;
    else start_prev <= start;
end

assign single_pulse_start = start && !start_prev;

pixel_pos #(.X_MAX(MAX_KERNEL), .Y_MAX(MAX_KERNEL), .MODE(1)) get_position (
    .clk(clk), .n_rst(n_rst),
    // Update
    .new_trans(single_pulse_start),
    .update_pos(readyFlag && contConv),
    // Positiom
    .max_x(kernel_size), 
    .max_y(kernel_size),
    .curr_x(cur_x),
    .curr_y(cur_y), 
    .end_pos(end_pos), 
    .next_dir());

KernelAccumulator get_accumulator (
    .clk(clk),
    .n_rst(n_rst),
    // Kernel Value
    .kernel_v(kernel_v),
    .pixel_v(pixel_v),
    // IO
    .start(contConv),
    .clear(clear),
    .ready(readyFlag),
    .clear_flag(clear_flag),
    // Out
    .sum(blurred_pixel));

MatrixIndex #(.MAX_KERNEL(MAX_KERNEL)) get_index (
    .clk(clk),
    .n_rst(n_rst),
    // Position
    .cur_x(cur_x),
    .cur_y(cur_y),
    // Input Array
    .kernel(kernel),
    .in(input_matrix),
    // Enable
    .en_strobe(readyFlag),
    // Out
    .kernel_v(kernel_v),
    .pixel_v(pixel_v));

endmodule
