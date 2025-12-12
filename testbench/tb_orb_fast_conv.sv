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

    // ------------------------------------------------------------------
    // IO Signals
    // ------------------------------------------------------------------
    logic new_trans;
    logic img_done;

    // ------------------------------------------------------------------
    // Image Input Interface
    // ------------------------------------------------------------------
    logic [$clog2(X_MAX):0] x_addr_img;
    logic [$clog2(Y_MAX):0] y_addr_img;
    logic ren_img;
    logic [PIXEL_DEPTH-1:0] rdat_img;

    // ------------------------------------------------------------------
    // Parameter Memory Interface
    // ------------------------------------------------------------------
    logic [$clog2(NUM_PARAMS)-1:0] addr_params;
    logic ren_params;
    logic [PARAM_DEPTH-1:0] rdat_params;

    logic [$clog2(NUM_PARAMS)-1:0] addr_write_params;
    logic wen_params;
    logic [PARAM_DEPTH-1:0] wdat_params;

    // ------------------------------------------------------------------
    // Convolution Output
    // ------------------------------------------------------------------
    logic [$clog2(X_MAX):0] x_addr_conv;
    logic [$clog2(Y_MAX):0] y_addr_conv;
    logic wen_conv;
    logic [PIXEL_DEPTH-1:0] wdat_conv;

    // Fast read from conv memory
    logic [$clog2(X_MAX):0] x_addr_conv_fast;
    logic [$clog2(Y_MAX):0] y_addr_conv_fast;
    logic ren_conv_fast;
    logic [PIXEL_DEPTH-1:0] rdat_conv_fast;

    // ------------------------------------------------------------------
    // FAST Output
    // ------------------------------------------------------------------
    logic x_addr_fast;
    logic y_addr_fast;
    logic wen_fast;
    logic wdat_fast;
    ////    ////    ////    ////    ////    ////    ////

    ////    ////    ////    ////    ////    ////    ////
    // Image SRAM BW
    sram_image #(
        .PIXEL_DEPTH(PIXEL_DEPTH),
        .X_MAX(X_MAX),
        .Y_MAX(Y_MAX),
        .DUAL(0)
    ) IMAGE_BW_RAM (
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

    // Conv SRAM - DUAL Port
    sram_image #(
        .PIXEL_DEPTH(PIXEL_DEPTH),
        .X_MAX(X_MAX),
        .Y_MAX(Y_MAX),
        .DUAL(1)
    ) CONV_SRAM (
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

      
    ////    ////    ////    ////    ////    ////    ////  

    ////    ////    ////    ////    ////    ////    ////  
    orb_fast_conv #(
        .NUM_PARAMS (NUM_PARAMS),
        .PARAM_DEPTH(PARAM_DEPTH),
        .MAX_KERNEL (MAX_KERNEL),
        .X_MAX      (X_MAX),
        .Y_MAX      (Y_MAX),
        .PIXEL_DEPTH(PIXEL_DEPTH)
    ) dut (
        .clk                (clk),
        .n_rst              (n_rst),

        .new_trans          (new_trans),
        .img_done           (img_done), 

        .x_addr_img         (x_addr_img),
        .y_addr_img         (y_addr_img),
        .ren_img            (ren_img),
        .rdat_img           (rdat_img),

        .addr_params        (addr_params),
        .ren_params         (ren_params),
        .rdat_params        (rdat_params),

        .addr_write_params  (addr_write_params),
        .wen_params         (wen_params),
        .wdat_params        (wdat_params),

        .x_addr_conv        (x_addr_conv),
        .y_addr_conv        (y_addr_conv),
        .wen_conv           (wen_conv),
        .wdat_conv          (wdat_conv),

        .x_addr_conv_fast   (x_addr_conv_fast),
        .y_addr_conv_fast   (y_addr_conv_fast),
        .ren_conv_fast      (ren_conv_fast),
        .rdat_conv_fast     (rdat_conv_fast),

        .x_addr_fast        (x_addr_fast),
        .y_addr_fast        (y_addr_fast),
        .wen_fast           (wen_fast),
        .wdat_fast          (wdat_fast)
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
        IMAGE_BW_RAM.load_img("image/doggo_image.hex", img_x, img_y);
        
        repeat (5) @(negedge clk);
        // Preload params
        PARAM_RAM.rmh("image/params_init.hex");

        while (img_done == 0) @(negedge clk);

        repeat (10) @(negedge clk);
        CONV_SRAM.dump_img("gaussian_image.hex", img_x, img_y);
        repeat (10) @(negedge clk);

        $finish;
    end

endmodule
