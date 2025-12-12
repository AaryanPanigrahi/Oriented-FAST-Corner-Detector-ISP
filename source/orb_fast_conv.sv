`timescale 1ns / 10ps

module orb_fast_conv #(
    parameter NUM_PARAMS = 8,
    parameter PARAM_DEPTH = 8,
    parameter MAX_KERNEL = 31,
    parameter X_MAX = 400,
    parameter Y_MAX = 400,
    parameter PIXEL_DEPTH = 8
) (
    // Sync
    input logic clk, n_rst,

    // IO
    output logic new_trans,
    output logic img_done,

    // IMAGE Input
    output logic [$clog2(X_MAX):0] x_addr_img, 
    output logic [$clog2(Y_MAX):0] y_addr_img,
    output logic ren_img,
    input logic [PIXEL_DEPTH-1:0] rdat_img,

    // IMAGE Params
    // Read Port
    output logic [$clog2(NUM_PARAMS)-1:0] addr_params,
    output logic ren_params,
    input logic [PARAM_DEPTH-1:0] rdat_params,
    // Write Port
    output logic [$clog2(NUM_PARAMS)-1:0] addr_write_params,
    output logic wen_params,
    output logic [PARAM_DEPTH-1:0] wdat_params,

    // Conv Output
    output logic [$clog2(X_MAX):0] x_addr_conv, 
    output logic [$clog2(Y_MAX):0] y_addr_conv,
    output logic wen_conv,
    output logic [PIXEL_DEPTH-1:0] wdat_conv,
    // Fast Reads from conv
    output logic [$clog2(X_MAX):0] x_addr_conv_fast, 
    output logic [$clog2(Y_MAX):0] y_addr_conv_fast,
    output logic ren_conv_fast,
    input logic [PIXEL_DEPTH-1:0] rdat_conv_fast,

    // FAST Output
    output logic x_addr_fast, 
    output logic y_addr_fast,
    output logic wen_fast,
    output logic wdat_fast
);

    // Global
    logic [2:0] sigma;
    logic [7:0] kernel_size;
    
    logic [$clog2(X_MAX) - 1:0] max_x;
    logic [$clog2(Y_MAX) - 1:0] max_y;

    // Gaussian 
    logic conv_done, pixel_done;
    assign img_done = conv_done;           // <<<< ---- change

    ////    ////    ////    ////    ////    ////    ////    
    // Control Inputs
    param_controller #(
        .NUM_PARAMS (NUM_PARAMS),
        .BIT_DEPTH  (PARAM_DEPTH),
        .X_MAX      (X_MAX),
        .Y_MAX      (Y_MAX)
    ) PARAM_CONTROL (
        .clk              (clk),
        .n_rst            (n_rst),
        // Param Read Ports
        .addr_params      (addr_params),
        .ren_params       (ren_params),
        .rdat_params      (rdat_params),
        // Param Write Ports
        .addr_write_params(addr_write_params),
        .wen_params       (wen_params),
        .wdat_params      (wdat_params),
        // Output Signals
        .new_trans        (new_trans),
        .img_done         (conv_done),
        .max_x            (max_x),
        .max_y            (max_y),
        .kernel_size      (kernel_size),
        .sigma            (sigma)
    ); 
    ////    ////    ////    ////    ////    ////    ////

    ////    ////    ////    ////    ////    ////    ////  
    // Perform Gaussian Convolution
    GaussianConv #(.MAX_KERNEL(MAX_KERNEL), .X_MAX(X_MAX), .Y_MAX(Y_MAX), .PIXEL_DEPTH(PIXEL_DEPTH)) DUT (
        .clk(clk), .n_rst(n_rst),
        // Kernel 
        .kernel_size(kernel_size),
        .sigma(sigma),
        // Pixel Pos
        .max_x(max_x),
        .max_y(max_y),
        // Starting Signals
        .new_trans(new_trans),
        // INPUT Image
        .x_addr_img(x_addr_img), 
        .y_addr_img(y_addr_img), 
        .ren_img(ren_img), 
        .rdat_img(rdat_img),
        // Conv Output
        .x_addr_conv(x_addr_conv), 
        .y_addr_conv(y_addr_conv),
        .wen_conv(wen_conv),
        .wdat_conv(wdat_conv),
        // Convolution Signals
        .conv_done(conv_done),
        .pixel_done(pixel_done)
    );
     ////    ////    ////    ////    ////    ////    ////        


endmodule
