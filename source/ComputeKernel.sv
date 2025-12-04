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
logic ready;
logic readyFlag;      // Ready signal for moving through rows/columns
assign ready = (readyFlag || start);
logic end_row;    // Clear signal move column
logic end_column; // Signal for end of kernel operations
logic [3:0] cur_x, cur_y; // Indexs of the array
assign done = end_column && end_row; // Indicates when the computation is done
logic contConv; // Prevents the counter from moving forward until the matrix is ready


always_latch begin : Computation_Latch
    if (start) contConv <= 1;
    if (done) contConv <= 0;
end

FlexCounter #(.SIZE(4)) rows (
    .clk(clk),
    .n_rst(n_rst),
    .count_enable(readyFlag && (contConv || done)),
    .rollover_val(SIZE-1),
    .clear(),
    .rollover_flag(end_row),
    .count_out(cur_x));

FlexCounter #(.SIZE(4)) columns (
    .clk(clk),
    .n_rst(n_rst),
    .count_enable(end_row && readyFlag && (contConv || done)),
    .rollover_val(SIZE-1),
    .clear(),
    .rollover_flag(end_column),
    .count_out(cur_y));

KernelAccumulator #(.SIZE(SIZE)) get_accumulator (
    .clk(clk),
    .n_rst(n_rst),
    .cur_x(cur_x),
    .cur_y(cur_y),
    .start(contConv),
    .clear(done),
    .in(input_matrix),
    .kernel(kernel),
    .en_strobe(ready),
    .ready(readyFlag),
    .sum(blurred_pixel));

endmodule
