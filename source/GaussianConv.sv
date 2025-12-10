`timescale 1ns / 10ps

module GaussianConv #(
    parameter MAX_KERNEL = 3,
    parameter X_MAX = 200,
    parameter Y_MAX = 200,
    parameter PIXEL_DEPTH = 8
)(
    input logic clk, n_rst,

    // Starting
    input logic new_trans,
    output logic conv_done, 

    // PIXEL POS
    input logic [$clog2(X_MAX) - 1:0] max_x,
    input logic [$clog2(Y_MAX) - 1:0] max_y,

    // Kernel
    input logic [2:0] sigma,
    input logic [$clog2(MAX_KERNEL)-1:0] kernel_size,

    // SRAM Input
    output logic [$clog2(X_MAX):0] x_addr_img, 
    output logic [$clog2(Y_MAX):0] y_addr_img,
    output logic ren_img,
    input logic [PIXEL_DEPTH-1:0] rdat_img,

    // SRAM Output
    output logic [$clog2(X_MAX):0] x_addr_conv, 
    output logic [$clog2(Y_MAX):0] y_addr_conv,
    output logic wen_conv,
    output logic [PIXEL_DEPTH-1:0] wdat_conv
);
////    ////    ////    ////    ////    ////    ////    ////    
localparam int MEM_ADDR_W = $clog2(Y_MAX * X_MAX);

// Memory and Kernel
logic [MAX_KERNEL-1:0][MAX_KERNEL-1:0][PIXEL_DEPTH-1:0] kernel, input_matrix;
logic kernel_done;

// Pixel Info
logic blur_complete, err;
logic [PIXEL_DEPTH-1:0] blurred_pixel;

logic [$clog2(X_MAX) - 1:0] curr_x;
logic [$clog2(Y_MAX) - 1:0] curr_y;
logic [1:0] next_dir;
logic end_pos, end_pos_latch;
////    ////    ////    ////    ////    ////    ////    ////    

////    ////    ////    ////    ////    ////    ////    ////   
// Control Signals
logic new_sample_ready;
logic new_sample_req;

////    ////    ////    ////    ////    ////    ////    ////    
// Input Latches
logic init_trans, init_trans_sample, init_trans_sample_latch, init_trans_kernel, init_trans_kernel_latch;
always_ff @(posedge clk, negedge n_rst) begin
    if (!n_rst) begin
        init_trans <= 0;

        init_trans_sample_latch <= 0;
        init_trans_kernel_latch <= 0;
    end

    else begin
        init_trans <= new_trans || init_trans_sample_latch || init_trans_kernel_latch;

        init_trans_sample_latch <= init_trans_sample;
        init_trans_kernel_latch <= init_trans_kernel;
    end

end

always_comb begin
    init_trans_sample = init_trans_sample_latch && !new_sample_ready;
    init_trans_kernel = init_trans_kernel_latch && !kernel_done;

    if (new_trans) begin
        init_trans_sample = 1;
        init_trans_kernel = 1;
    end
end
////    ////    ////    ////    ////    ////    ////    ////    

////    ////    ////    ////    ////    ////    ////    //// 
logic compLatch, compLatch_prev, compAck, comp_clear_flag;

logic new_sample_req_in_the_next_cycle;
assign new_sample_req_in_the_next_cycle = (((compLatch && !compLatch_prev) || init_trans_sample_latch) && new_sample_ready && !new_trans);

always_ff @(posedge clk, negedge n_rst) begin
    if(~n_rst) begin 
        compLatch <= 1'b0;
        compLatch_prev <= 0;
        new_sample_req <= 1'b0;
        compAck <= 1'b0;
        end_pos_latch <= 1'b0;
    end
    else begin
        new_sample_req <= new_sample_req_in_the_next_cycle;
        compLatch_prev <= compLatch;

        // end_pos_latch 
        if (end_pos) end_pos_latch <= 1'b1;
        else if (conv_done) end_pos_latch <= 1'b0;

        // compLatch or compAck
        if (blur_complete) begin 
            compLatch <= 1'b1;
            compAck <= 1'b1;
        end
        else if (new_sample_req) compLatch <= 1'b0;
        if (comp_clear_flag) compAck <= 1'b0;
    end
end
////    ////    ////    ////    ////    ////    ////    ////    

////    ////    ////    ////    ////    ////    ////    ////    
// Writing to SRAM
always_ff @(posedge clk, negedge n_rst) begin
    if (!n_rst) begin
        x_addr_conv <= 0;
        y_addr_conv <= 0;
        wen_conv    <= 0;
        wdat_conv   <= 0;
    end

    else begin
        x_addr_conv <= curr_x;
        y_addr_conv <= curr_y;
        wen_conv    <= blur_complete;
        wdat_conv   <= blurred_pixel;
    end
end
////    ////    ////    ////    ////    ////    ////    //// 

////    ////    ////    ////    ////    ////    ////    ////    
CreateKernel #(.MAX_KERNEL(MAX_KERNEL)) get_kernel (
    .clk(clk),
    .n_rst(n_rst),
    // Params
    .sigma(sigma),
    .kernel_size(kernel_size),
    // Telemetry
    .start(new_trans),
    .done(kernel_done),
    // Output
    .err(err),
    .kernel(kernel));
////    ////    ////    ////    ////    ////    ////    ////    

////    ////    ////    ////    ////    ////    ////    ////
pixel_pos #(.X_MAX(X_MAX), .Y_MAX(Y_MAX), .MODE(0)) image_pos (
    .clk(clk), .n_rst(n_rst),
    .new_trans(new_trans),
    .update_pos(new_sample_req),
    .max_x(max_x),          
    .max_y(max_y),         
    .curr_x(curr_x),
    .curr_y(curr_y),
    .end_pos(end_pos),
    .next_dir(next_dir));

// Output
assign conv_done = (end_pos && blur_complete);
////    ////    ////    ////    ////    ////    ////    ////    

////    ////    ////    ////    ////    ////    ////    ////
conv_memory #(.MAX_KERNEL(MAX_KERNEL), .PIXEL_DEPTH(PIXEL_DEPTH), .X_MAX(X_MAX), .Y_MAX(Y_MAX)) propogate_buffer (
    .clk(clk), .n_rst(n_rst),
    // Start Stop Signals
    .new_trans(new_trans),
    .new_sample_req(new_sample_req),
    .new_sample_ready(new_sample_ready),
    // Image
    .x_addr_img(x_addr_img),
    .y_addr_img(y_addr_img),
    .ren_img(ren_img),
    .rdat_img(rdat_img),
    // Kernel
    .kernel_size(kernel_size),
    // Pixel Pos
    .next_dir(next_dir),
    .curr_x(curr_x),
    .curr_y(curr_y),
    .working_memory(input_matrix));
////    ////    ////    ////    ////    ////    ////    ////    

////    ////    ////    ////    ////    ////    ////    ////
ComputeKernel #(.MAX_KERNEL(MAX_KERNEL)) pixel_blur (
    .clk(clk),
    .n_rst(n_rst),
    // Telemetry
    .start((new_sample_ready && compLatch)),
    .done(blur_complete),

    // Params
    .kernel_size(kernel_size),

    // Memory Input
    .kernel(kernel),
    .input_matrix(input_matrix),

    // Other Control
    .clear(compAck),
    .clear_flag(comp_clear_flag),
    .blurred_pixel(blurred_pixel));
////    ////    ////    ////    ////    ////    ////    ////
endmodule
