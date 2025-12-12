`timescale 1ns / 10ps

module orb_fast_conv #(
    // Image
    parameter X_MAX = 400,
    parameter Y_MAX = 400,
    parameter PIXEL_DEPTH = 8,
    parameter COLOUR_DEPTH = 24,

    // Params
    parameter NUM_PARAMS = 8,
    parameter PARAM_DEPTH = 8,

    // Gaussian
    parameter MAX_KERNEL = 31,
    // Fast
    parameter THRESHOLD = 20
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
    input logic [COLOUR_DEPTH-1:0] rdat_img,

    // IMAGE Params
    // Read Port
    output logic [$clog2(NUM_PARAMS)-1:0] addr_params,
    output logic ren_params,
    input logic [PARAM_DEPTH-1:0] rdat_params,
    // Write Port
    output logic [$clog2(NUM_PARAMS)-1:0] addr_write_params,
    output logic wen_params,
    output logic [PARAM_DEPTH-1:0] wdat_params,

    // BW IMAGE In
    output logic [$clog2(X_MAX):0] x_addr_bw, 
    output logic [$clog2(Y_MAX):0] y_addr_bw,
    output logic wen_bw,
    output logic [PIXEL_DEPTH-1:0] wdat_bw,
    // BW IMAGE Out
    output logic [$clog2(X_MAX):0] x_addr_bw_conv, 
    output logic [$clog2(Y_MAX):0] y_addr_bw_conv,
    output logic ren_bw_conv,
    input logic [PIXEL_DEPTH-1:0] rdat_bw_conv,

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
    output logic [$clog2(X_MAX)] x_addr_fast, 
    output logic [$clog2(Y_MAX)] y_addr_fast,
    output logic wen_fast,
    output logic wdat_fast,
    // FAST input
    output logic ren_fast,
    input logic rdat_fast,

    // Circle Out
    output logic [$clog2(X_MAX):0] x_addr_circle, 
    output logic [$clog2(Y_MAX):0] y_addr_circle,
    output logic wen_circle,
    output logic [COLOUR_DEPTH-1:0] wdat_circle
);

    // Global
    logic [2:0] sigma;
    logic [7:0] kernel_size;
    
    logic [$clog2(X_MAX) - 1:0] max_x;
    logic [$clog2(Y_MAX) - 1:0] max_y;

    // Gaussian 
    logic conv_done, pixel_done;

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
        .img_done         (img_done),
        .max_x            (max_x),
        .max_y            (max_y),
        .kernel_size      (kernel_size),
        .sigma            (sigma)
    ); 
    ////    ////    ////    ////    ////    ////    ////

    ////    ////    ////    ////    ////    ////    //// 
    ConvertBW #(.X_MAX(X_MAX), .Y_MAX(X_MAX), .PIXEL_DEPTH(COLOUR_DEPTH) ) convert_bw (
        // Sync
        .clk(clk),
        .n_rst(n_rst),
        // Control
        .new_trans(new_trans),
        .start(new_trans),
        .bw_done(bw_done),

        // Image
        .max_x(max_x),
        .max_y(max_y),

        // SRAM Input
        .x_addr_img(x_addr_img),
        .y_addr_img(y_addr_img),
        .ren_img(ren_img),
        .rdat_img(rdat_img),

        // SRAM Output
        .x_addr_bw(x_addr_bw),
        .y_addr_bw(y_addr_bw),
        .wen_bw(wen_bw),
        .wdat_bw(wdat_bw)
    );
    ////    ////    ////    ////    ////    ////    //// 


    ////    ////    ////    ////    ////    ////    ////  
    // Perform Gaussian Convolution
    GaussianConv #(.MAX_KERNEL(MAX_KERNEL), .X_MAX(X_MAX), .Y_MAX(Y_MAX), .PIXEL_DEPTH(PIXEL_DEPTH)) GAUSS_COMP (
        .clk(clk), .n_rst(n_rst),

        // Kernel 
        .kernel_size(kernel_size),
        .sigma(sigma),

        // Pixel Pos
        .max_x(max_x),
        .max_y(max_y),
        // Control
        .new_trans(bw_done),
        .pixel_done(pixel_done),
        .conv_done(conv_done),

        // INPUT Image
        .x_addr_img(x_addr_bw_conv), 
        .y_addr_img(y_addr_bw_conv), 
        .ren_img(ren_bw_conv), 
        .rdat_img(rdat_bw_conv),
        // Conv Output
        .x_addr_conv(x_addr_conv), 
        .y_addr_conv(y_addr_conv),
        .wen_conv(wen_conv),
        .wdat_conv(wdat_conv)
    );
     ////    ////    ////    ////    ////    ////    //// 

    ////    ////    ////    ////    ////    ////    ////
    fast_top_level #(.X_MAX(X_MAX), .Y_MAX(Y_MAX), .THRESHOLD(THRESHOLD)) FAST_COMP (
        // sync
        .clk(clk),
        .n_rst(n_rst),

        // Control
        .new_trans(bw_done),
        .gaus_sample_flag(pixel_done),
        .gaus_done(conv_done),
        .done(img_done),

        //Signals
        .max_x(max_x),
        .max_y(max_y),

        // Read From Gauss
        .x_addr_gaus(x_addr_conv_fast),
        .y_addr_gaus(y_addr_conv_fast),
        .read_SRAM_gaus(ren_conv_fast),
        .SRAM_in_gaus(rdat_conv_fast),

        // Fast 1 bit Write
        .x_addr_fast(x_addr_fast),
        .y_addr_fast(y_addr_fast),
        .write_SRAM_fast(wen_fast),
        // 1 Bit Read
        .read_SRAM_fast(ren_fast),
        .SRAM_in_fast(rdat_fast),

        // Make Circles
        .x_addr_OUT(x_addr_circle),
        .y_addr_OUT(y_addr_circle),
        .write_SRAM_OUT(wen_circle),
        .SRAM_OUT_wdata(wdat_circle)
    );       

    assign wdat_fast = 1;
    ////    ////    ////    ////    ////    ////    ////


endmodule
