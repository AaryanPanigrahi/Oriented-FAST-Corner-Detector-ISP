`timescale 1ns / 10ps

module GaussianConv #(
    parameter [3:0] KERNEL_SIZE = 4'd3
)(
    input logic clk, n_rst,
    input logic [8:0] x_pos, y_pos,
    input logic [2:0] sigma,
    input logic [KERNEL_SIZE-1:0][KERNEL_SIZE-1:0][7:0] input_buffer,
    input logic start_conv, 
    input logic [1:0] next_dir,
    output logic [7:0] blurred_pixel,
    output logic err
    output logic blur_complete
);
logic [KERNEL_SIZE-1:0][KERNEL_SIZE-1:0][7:0] kernel, input_matrix;
logic done, prop_ready, kernel_start;

always_comb kernel_start = (prop_ready || start_conv); // Indicates when to begin next kernel comp

CreateKernel #(.SIZE(KERNEL_SIZE)) get_kernel (
    .clk(clk),
    .n_rst(n_rst),
    .sigma(sigma),
    .start(start_conv),
    .kernel(kernel),
    .err(err));

PropogateBuffer #(.SIZE(KERNEL_SIZE)) shift_buffer (
    .clk(clk),
    .n_rst(n_rst),
    .input_buffer(input_buffer),
    .next_dir(next_dir),
    .done(pixel_ready),
    .input_matrix(input_matrix)
    .ready(prop_ready));

ComputeKernel #(.SIZE(KERNEL_SIZE)) pixel_blur (
    .clk(clk),
    .n_rst(n_rst),
    .kernel(kernel),
    .start(kernel_start),
    .input_matrix(input_matrix),
    .done(blur_complete),
    .blurred_pixel(blurred_pixel));

endmodule
