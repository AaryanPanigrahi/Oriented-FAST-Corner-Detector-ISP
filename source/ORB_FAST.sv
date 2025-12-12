`timescale 1ns / 10ps

module orb_fast #(// SRAM Variables
    parameter PARAM_WIDTH = 1,
    parameter MAX_KERNEL = 31,
    parameter X_MAX = 400,
    parameter Y_MAX = 400,
    parameter PIXEL_DEPTH = 8
    ) (
    // IMAGE Input
    output logic [$clog2(X_MAX):0] x_addr_img, 
    output logic [$clog2(Y_MAX):0] y_addr_img,
    output logic ren_img,
    input logic [PIXEL_DEPTH-1:0] rdat_img,

    // IMAGE Params
    output logic [$clog2(PARAM_WIDTH)-1:0] addr_params,
    output logic ren_params,
    input logic [PIXEL_DEPTH-1:0] rdat_params,

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
    output logic [$clog2(X_MAX):0] x_addr_fast, 
    output logic [$clog2(Y_MAX):0] y_addr_fast,
    output logic wen_fast,
    output logic [PIXEL_DEPTH-1:0] wdat_fast,
);
    // Local Paramters
    localparam PIXEL_DEPTH_FAST = 12;

    // Address Locations
    localparam NEW_IMG_ADDR     = 0;
    localparam X_MAX_LOWER_ADDR = 1;
    localparam X_MAX_UPPER_ADDR = 2;
    localparam Y_MAX_LOWER_ADDR = 3;
    localparam Y_MAX_UPPER_ADDR = 4;
    localparam KERNEL_ADDR      = 5;
    localparam SIGMA_ADDR       = 6;
    localparam DONE_ADDR        = 7;


    // Perform Gaussian Convolution
    GaussianConv #(.MAX_KERNEL(MAX_KERNEL), .X_MAX(X_MAX), .Y_MAX(Y_MAX), .PIXEL_DEPTH(PIXEL_DEPTH)) DUT (
        .clk(clk), .n_rst(n_rst),
        // Kernel 
        .kernel_size(kernel_size),
        .sigma(sigma)
        // Pixel Pos
        .max_x(max_x),
        .max_y(max_y),
        // Starting Signals
        .new_trans(new_trans),
        // SRAM
        .x_addr_img(x_addr_img), 
        .y_addr_img(y_addr_img), 
        .ren_img(ren_img), 
        .rdat_img(rdat_img),
        // SRAM Output
        .x_addr_conv(x_addr_conv), 
        .y_addr_conv(y_addr_conv),
        .wen_conv(wen_conv),
        .wdat_conv(wdat_conv),
        // Convolution Signals
        .conv_done(conv_done),
        .pixel_done(pixel_done)
    );

    //  


endmodule