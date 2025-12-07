`timescale 1ns / 10ps

module ComputeKernel #(
    parameter [3:0] SIZE = 4'd3
)(
    input logic clk, n_rst,
    input logic [SIZE-1:0][SIZE-1:0][7:0] input_matrix, kernel,
    input logic start,
    output logic [7:0] blurred_pixel,
    output logic done
);
logic readyFlag;  // Ready signal for moving through rows/columns
logic end_row;    // Clear signal move column
logic end_column; // Signal for end of kernel operations
logic [3:0] cur_x, cur_y; // Indexs of the array
logic contConv;   // Prevents the counter from moving forward until the matrix is ready
logic [7:0] kernel_v, pixel_v; // Holds the value of the current cell
logic temp_rollover, queue_clear, clear_flag, nextDone;

always_ff @(posedge clk, negedge n_rst) begin : Computation_FF
    if (~n_rst) begin
        contConv <= 1'b0;
        done <= 1'b0;
        temp_rollover <= 1'b0;
        queue_clear <= 1'b0;
    end
    else begin
        temp_rollover <= 1'b0;
        done <= 1'b0;
        
        if (start) contConv <= 1'b1;
        else if (contConv && end_column && end_row && readyFlag) begin
            contConv <= 1'b0;
            done <= 1'b1;
            queue_clear <= 1'b1;
        end
        else if (clear_flag) queue_clear <= 1'b0;
    end
end

FlexCounter #(.SIZE(4)) rows_compute (
    .clk(clk),
    .n_rst(n_rst),
    .count_enable(readyFlag && (contConv || temp_rollover)),
    .rollover_val(SIZE-4'd1),
    .clear(1'b0),
    .rollover_flag(end_row),
    .count_out(cur_x));

FlexCounter #(.SIZE(4)) columns_compute (
    .clk(clk),
    .n_rst(n_rst),
    .count_enable(end_row && readyFlag && (contConv || temp_rollover)),
    .rollover_val(SIZE-4'd1),
    .clear(1'b0),
    .rollover_flag(end_column),
    .count_out(cur_y));
// pixel_pos #(.X_MAX(SIZE), .Y_MAX(SIZE)) get_position (
//     .clk(clk), .n_rst(n_rst),
//     .max_x(SIZE-4'b1), .max_y(SIZE-4'b1),
//     .update_pos(readyFlag && (contConv || temp_rollover)),
//     .curr_y(cur_y), .curr_x(cur_x),
//     .end_pos(temp_rollover), .next_dir());

KernelAccumulator get_accumulator (
    .clk(clk),
    .n_rst(n_rst),
    .kernel_v(kernel_v),
    .pixel_v(pixel_v),
    .start(contConv || temp_rollover),
    .clear(queue_clear),
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
