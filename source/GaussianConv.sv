`timescale 1ns / 10ps

module GaussianConv #(
    parameter [3:0] KERNEL_SIZE = 4'd3,
    parameter MEM_W = 200
)(
    input logic clk, n_rst,
    input logic [7:0] rdat_img,
    input logic [2:0] sigma,
    input logic start_conv, new_trans,
    output logic [7:0] blurred_pixel,
    output logic err,
    output logic blur_complete, 
    output logic ren_img,
    output logic conv_done, 
    output logic [$clog2(MEM_W)-1:0] x_addr_img, y_addr_img
);
localparam int MEM_ADDR_W = $clog2(MEM_W);

logic [KERNEL_SIZE-1:0][KERNEL_SIZE-1:0][7:0] kernel, input_matrix;
logic comp_start, kernel_done;
logic end_pos, new_sample_ready;
logic [MEM_W-1:0] curr_x, curr_y;
logic [1:0] next_dir;
logic new_sample_req;
logic [$clog2(MEM_W)-1:0] max_x, max_y;
assign max_x = MEM_W; assign max_y = MEM_W;
assign conv_done = (end_pos && blur_complete);

always_comb begin
    // comp_start = (new_sample_ready); // Indicates when to begin next kernel comp
    new_sample_req = 1'b0;
    if ((blur_complete | new_trans) && (new_sample_ready && !new_trans)) new_sample_req = 1'b1;
end

CreateKernel #(.SIZE(KERNEL_SIZE)) get_kernel (
    .clk(clk),
    .n_rst(n_rst),
    .sigma(sigma),
    .start(start_conv),
    .kernel(kernel),
    .done(kernel_done),
    .err(err));

pixel_pos #(.X_MAX(MEM_W), .Y_MAX(MEM_W))
    image_pos (
    .clk(clk), .n_rst(n_rst),
    .update_pos(new_sample_req),
    .new_trans(new_trans),
    .max_x(max_x),
    .max_y(max_y),
    .end_pos(end_pos),
    .next_dir(next_dir),
    .curr_x(curr_x),
    .curr_y(curr_y));

conv_memory #(
    .MAX_KERNAL(31), .PIXEL_DEPTH(8), .X_MAX(MEM_W), .Y_MAX(MEM_W)) 
    propogate_buffer (
    .clk(clk), .n_rst(n_rst),
    .x_addr_img(x_addr_img),
    .y_addr_img(y_addr_img),
    .ren_img(ren_img),
    .rdat_img(rdat_img),
    .kernel_size({4'b0, KERNEL_SIZE}),
    .next_dir(next_dir),
    .curr_x(curr_x),
    .curr_y(curr_y),
    .new_sample_req(new_sample_req),
    .new_trans(new_trans),
    .new_sample_ready(new_sample_ready),
    .working_memory(input_matrix));

ComputeKernel #(.SIZE(KERNEL_SIZE)) pixel_blur (
    .clk(clk),
    .n_rst(n_rst),
    .kernel(kernel),
    .start(new_sample_ready ),
    .input_matrix(input_matrix),
    .done(blur_complete),
    .blurred_pixel(blurred_pixel));

endmodule
