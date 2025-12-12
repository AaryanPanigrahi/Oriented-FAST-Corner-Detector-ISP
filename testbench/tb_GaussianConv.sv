`timescale 1ns / 10ps
/* verilator coverage_off */

module tb_GaussianConv ();

    localparam CLK_PERIOD = 10ns;

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars;
    end

    // SRAM Variables
    localparam MAX_KERNEL = 8'd5;
    localparam X_MAX = 400;
    localparam Y_MAX = 400;
    localparam PIXEL_DEPTH = 8;

    // What do with err

    // Signals
    logic clk, n_rst;
    logic [2:0] sigma;
    logic new_trans;
    logic conv_done, pixel_done;
    logic [$clog2(X_MAX) - 1:0] max_x;
    logic [$clog2(Y_MAX) - 1:0] max_y;
    logic [7:0] kernel_size;

    // Signals
    logic [$clog2(X_MAX):0]   x_addr_img, x_addr_conv;
    logic [$clog2(Y_MAX):0]   y_addr_img, y_addr_conv;
    logic                     wen_img, wen_conv, ren_img, ren_conv;
    logic [PIXEL_DEPTH-1:0]   wdat_img, wdat_conv, rdat_img, rdat_conv;

    // clockgen
    always begin
        clk = 0;
        #(CLK_PERIOD / 2.0);
        clk = 1;
        #(CLK_PERIOD / 2.0);
    end

    // DUT
    GaussianConv #(.MAX_KERNEL(MAX_KERNEL), .X_MAX(X_MAX), .Y_MAX(Y_MAX), .PIXEL_DEPTH(PIXEL_DEPTH)) DUT (
        .clk(clk), .n_rst(n_rst),
        // Starting Signals
        .new_trans(new_trans),
        // Pixel Pos
        .max_x(max_x),
        .max_y(max_y),
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
        .pixel_done(pixel_done),
        // Kernel 
        .kernel_size(kernel_size),
        .sigma(sigma));

    // SRAM Module
    sram_image #(
        .PIXEL_DEPTH(PIXEL_DEPTH),
        .X_MAX(X_MAX),
        .Y_MAX(Y_MAX),
        .DUAL(0)
    ) IMAGE_RAM (
        .ramclk (clk),
        .x_addr   (x_addr_img),
        .y_addr   (y_addr_img),
        .x_addr_write   ('0),
        .y_addr_write   ('0),
        .wdat   (wdat_img),
        .wen    (wen_img),
        .ren    (ren_img),
        .rdat   (rdat_img)
    );

    // SRAM Module - DUAL Port
    sram_image #(
        .PIXEL_DEPTH(PIXEL_DEPTH),
        .X_MAX(X_MAX),
        .Y_MAX(Y_MAX),
        .DUAL(0)
    ) CONV_SRAM (
        .ramclk (clk),
        .x_addr   (x_addr_conv),
        .y_addr   (y_addr_conv),
        .x_addr_write   ('0),
        .y_addr_write   ('0),
        .wdat   (wdat_conv),
        .wen    (wen_conv),
        .ren    (ren_conv),
        .rdat   (rdat_conv)
    );

        // Aux
    task wait_time(input int wait_t);
        begin
            repeat(wait_t) @(negedge clk);
        end
    endtask

    task wait_ten;
        begin
            repeat(10) @(negedge clk);
        end
    endtask

    task wait_fifty;
        begin
            repeat(50) @(negedge clk);
        end
    endtask

    // Reset Gen
    task reset_dut;
    begin
        @(posedge clk);
        n_rst = 0;
        @(posedge clk);
        n_rst = 1;
    end
    endtask

    task init;
    begin
        wdat_img = '0; 
        wen_img = 0; 
        max_x = 1;
        max_y = 1;

        ren_conv = 0;

        sigma = 1;
        kernel_size = 1;
        new_trans = '0;

        n_rst = 1'b1;
        reset_dut();
    end
    endtask

    task begin_trans();
        @(posedge clk);
        new_trans = 1'b1;
        @(posedge clk);
        new_trans = 1'b0;
    endtask

    initial begin
        init();

        repeat (5) @(negedge clk);

        sigma = 3'd2;
        kernel_size = 5;
        max_x = 400;
        max_y = 242;
        @(negedge clk);
        IMAGE_RAM.load_img("image/doggo_image.hex", max_x, max_y);
        @(negedge clk);
        begin_trans();

        // repeat (1000) @(negedge clk);
        while(conv_done == 0) begin
            @(negedge clk);
        end

        wait_ten;

        CONV_SRAM.dump_img("gaussian_image.hex", max_x, max_y);
        wait_ten;

        $finish;
    end
endmodule

/* verilator coverage_on */
