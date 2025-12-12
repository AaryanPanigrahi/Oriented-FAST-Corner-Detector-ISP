`timescale 1ns / 10ps
/* verilator coverage_off */

module tb_orb_fast_conv ();
    // SRAM Variables
    localparam MAX_KERNEL = 31;
    localparam NUM_PARAMS = 8;
    localparam PARAM_DEPTH = 8;
    localparam X_MAX = 400;
    localparam Y_MAX = 400;
    localparam PIXEL_DEPTH = 8;
    localparam COLOUR_DEPTH = 24;


    ////    ////    ////    ////    ////    ////    ////
    // ------------------------------------------------------------------
    // Clock & Reset
    // ------------------------------------------------------------------
    logic clk;
    logic n_rst;
    localparam CLK_PERIOD = 10ns;


    // clockgen
    always begin
        clk = 0;
        #(CLK_PERIOD / 2.0);
        clk = 1;
        #(CLK_PERIOD / 2.0);
    end

    // IO
    logic new_trans;
    logic img_done;

    // IMAGE Input
    logic [$clog2(X_MAX):0] x_addr_img;
    logic [$clog2(Y_MAX):0] y_addr_img;
    logic ren_img;
    logic [COLOUR_DEPTH-1:0] rdat_img;

    // IMAGE Params
    // Read Port
    logic [$clog2(NUM_PARAMS)-1:0] addr_params;
    logic ren_params;
    logic [PARAM_DEPTH-1:0] rdat_params;
    // Write Port
    logic [$clog2(NUM_PARAMS)-1:0] addr_write_params;
    logic wen_params;
    logic [PARAM_DEPTH-1:0] wdat_params;

    // BW IMAGE In
    logic [$clog2(X_MAX):0] x_addr_bw;
    logic [$clog2(Y_MAX):0] y_addr_bw;
    logic wen_bw;
    logic [PIXEL_DEPTH-1:0] wdat_bw;

    // BW IMAGE Out
    logic [$clog2(X_MAX):0] x_addr_bw_conv;
    logic [$clog2(Y_MAX):0] y_addr_bw_conv;
    logic ren_bw_conv;
    logic [PIXEL_DEPTH-1:0] rdat_bw_conv;

    // Conv Output
    logic [$clog2(X_MAX):0] x_addr_conv;
    logic [$clog2(Y_MAX):0] y_addr_conv;
    logic wen_conv;
    logic [PIXEL_DEPTH-1:0] wdat_conv;

    // Fast Reads from conv
    logic [$clog2(X_MAX):0] x_addr_conv_fast;
    logic [$clog2(Y_MAX):0] y_addr_conv_fast;
    logic ren_conv_fast;
    logic [PIXEL_DEPTH-1:0] rdat_conv_fast;

    // FAST Output / Input
    logic signed [$clog2(X_MAX):0] x_addr_fast;
    logic signed [$clog2(Y_MAX):0] y_addr_fast;
    logic wen_fast;
    logic wdat_fast;
    logic ren_fast;
    logic rdat_fast;

    // Circle Out
    logic [$clog2(X_MAX):0] x_addr_circle;
    logic [$clog2(Y_MAX):0] y_addr_circle;
    logic wen_circle;
    logic [COLOUR_DEPTH-1:0] wdat_circle;

    ////    ////    ////    ////    ////    ////    ////

    ////    ////    ////    ////    ////    ////    ////
    // Image SRAM BW
    sram_image #(
        .PIXEL_DEPTH(COLOUR_DEPTH),
        .X_MAX(X_MAX),
        .Y_MAX(Y_MAX),
        .DUAL(1)
    ) IMAGE_RAM (
        .ramclk (clk),
        // Gaussian Read
        .x_addr   (x_addr_img),
        .y_addr   (y_addr_img),
        .ren    (ren_img),
        .rdat   (rdat_img),
        // No Writes
        .x_addr_write   ('0),
        .y_addr_write   ('0),
        .wdat   ('0),
        .wen    ('0)
    );

    // SRAM for PARAMS
    sram_model #(
        .ADDR_WIDTH         ($clog2(NUM_PARAMS)),
        .DATA_WIDTH         (PARAM_DEPTH),
        .RAM_IS_SYNCHRONOUS (1),
        .DUAL               (1)
    ) PARAM_RAM (
        .ramclk     (clk),
        // Read Port
        .addr       (addr_params),
        .ren        (ren_params),
        .rdat       (rdat_params),
        // Write Port
        .addr_write (addr_write_params),
        .wdat       (wen_params),
        .wen        (wdat_params)
    );

    // Conv BW - DUAL Port
    sram_image #(
        .PIXEL_DEPTH(PIXEL_DEPTH),
        .X_MAX(X_MAX),
        .Y_MAX(Y_MAX),
        .DUAL(1)
    ) IMAGE_BW_RAM (
        .ramclk (clk),
        // BW Write
        .x_addr_write   (x_addr_bw),
        .y_addr_write   (y_addr_bw),
        .wdat   (wdat_bw),
        .wen    (wen_bw),
        // Conv Read
        .x_addr   (x_addr_bw_conv),
        .y_addr   (y_addr_bw_conv),
        .ren    (ren_bw_conv),
        .rdat   (rdat_bw_conv)
    );

    // Conv SRAM - DUAL Port
    sram_image #(
        .PIXEL_DEPTH(PIXEL_DEPTH),
        .X_MAX(X_MAX),
        .Y_MAX(Y_MAX),
        .DUAL(1)
    ) CONV_RAM (
        .ramclk (clk),
        // Conv Write
        .x_addr_write   (x_addr_conv),
        .y_addr_write   (y_addr_conv),
        .wdat   (wdat_conv),
        .wen    (wen_conv),
        // Fast Read
        .x_addr   (x_addr_conv_fast),
        .y_addr   (y_addr_conv_fast),
        .ren    (ren_conv_fast),
        .rdat   (rdat_conv_fast)
    );  

    // Fast SRAM - Single Port
    sram_image #(
        .PIXEL_DEPTH(1),
        .X_MAX(X_MAX),
        .Y_MAX(Y_MAX),
        .DUAL(0)
    ) FAST_RAM (
        .ramclk (clk),
        .x_addr   (x_addr_fast),
        .y_addr   (y_addr_fast),
        // Fast Write
        .wdat   (wdat_fast),
        .wen    (wen_fast),
        // Fast Read
        .ren    (ren_fast),
        .rdat   (rdat_fast)
    );  

    // Circle SRAM
    sram_image #(
        .PIXEL_DEPTH(COLOUR_DEPTH),
        .X_MAX(X_MAX),
        .Y_MAX(Y_MAX),
        .DUAL(0)
    ) OUT_RAM (
        .ramclk (clk),
        // Circles Write
        .x_addr   (x_addr_circle),
        .y_addr   (y_addr_circle),
        .wen    (wen_circle),
        .wdat   (wdat_circle),
        .ren    ('0),
        .rdat   ()
    );

    ////    ////    ////    ////    ////    ////    ////  

    ////    ////    ////    ////    ////    ////    ////  
    orb_fast_conv #(
        .NUM_PARAMS (NUM_PARAMS),
        .PARAM_DEPTH(PARAM_DEPTH),
        .MAX_KERNEL (MAX_KERNEL),
        .X_MAX      (X_MAX),
        .Y_MAX      (Y_MAX),
        .PIXEL_DEPTH(PIXEL_DEPTH)
    ) OVERALL (
        // Sync
        .clk(clk),
        .n_rst(n_rst),

        // IO
        .new_trans(new_trans),
        .img_done(img_done),

        // IMAGE Input
        .x_addr_img(x_addr_img),
        .y_addr_img(y_addr_img),
        .ren_img(ren_img),
        .rdat_img(rdat_img),

        // IMAGE Params
        // Read Port
        .addr_params(addr_params),
        .ren_params(ren_params),
        .rdat_params(rdat_params),
        // Write Port
        .addr_write_params(addr_write_params),
        .wen_params(wen_params),
        .wdat_params(wdat_params),

        // BW IMAGE In
        .x_addr_bw(x_addr_bw),
        .y_addr_bw(y_addr_bw),
        .wen_bw(wen_bw),
        .wdat_bw(wdat_bw),
        // BW IMAGE Out
        .x_addr_bw_conv(x_addr_bw_conv),
        .y_addr_bw_conv(y_addr_bw_conv),
        .ren_bw_conv(ren_bw_conv),
        .rdat_bw_conv(rdat_bw_conv),

        // Conv Output
        .x_addr_conv(x_addr_conv),
        .y_addr_conv(y_addr_conv),

        .wen_conv(wen_conv),
        .wdat_conv(wdat_conv),
        // Fast Reads from conv
        .x_addr_conv_fast(x_addr_conv_fast),
        .y_addr_conv_fast(y_addr_conv_fast),
        .ren_conv_fast(ren_conv_fast),

        .rdat_conv_fast(rdat_conv_fast),

        // FAST Output
        .x_addr_fast(x_addr_fast),
        .y_addr_fast(y_addr_fast),
        .wen_fast(wen_fast),
        .wdat_fast(wdat_fast),
        // FAST input
        .ren_fast(ren_fast),
        .rdat_fast(rdat_fast),

        // Circle Out
        .x_addr_circle(x_addr_circle),
        .y_addr_circle(y_addr_circle),
        .wen_circle(wen_circle),
        .wdat_circle(wdat_circle)
    );
    ////    ////    ////    ////    ////    ////    ////  

    task reset_dut;
    begin
        n_rst = 1;
        @(posedge clk);
        n_rst = 0;
        @(posedge clk);
        n_rst = 1;
        @(posedge clk);
    end
    endtask

    int img_x, img_y;

    initial begin
        reset_dut;

        img_x = 400;
        img_y = 400;

        repeat (5) @(negedge clk);
        IMAGE_RAM.load_img("image/rongbo.hex", img_x, img_y);
        OUT_RAM.load_img("image/rongbo.hex", img_x, img_y);
        
        repeat (5) @(negedge clk);
        // Preload params
        PARAM_RAM.rmh("image/params_init.hex");

        while (img_done == 0) @(negedge clk);

        repeat (10) @(negedge clk);
        IMAGE_BW_RAM.dump_img("img1.hex", img_x, img_y);
        repeat (10) @(negedge clk);
        CONV_RAM.dump_img("img2.hex", img_x, img_y);
        repeat (10) @(negedge clk);
        repeat (10) @(negedge clk);
        FAST_RAM.dump_img("img3.hex", img_x, img_y);
        repeat (10) @(negedge clk);
        OUT_RAM.dump_img("img4.hex", img_x, img_y);
        repeat (10) @(negedge clk);

        $finish;
    end

endmodule
