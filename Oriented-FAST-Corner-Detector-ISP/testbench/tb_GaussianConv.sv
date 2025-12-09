`timescale 1ns / 10ps
/* verilator coverage_off */

module tb_GaussianConv ();

    localparam CLK_PERIOD = 10ns;

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars;
    end

    // SRAM Variables
    localparam MAX_KERNAL = 8'd5;
    localparam X_MAX = 16;
    localparam Y_MAX = 16;
    localparam PIXEL_DEPTH = 8;

    // What do with err

    // Signals
    logic clk, n_rst;
    logic [2:0] sigma;
    logic new_trans;
    logic conv_done;
    logic [$clog2(X_MAX) - 1:0] max_x;
    logic [$clog2(Y_MAX) - 1:0] max_y;
    logic [7:0] kernel_size;

    assign kernel_size = MAX_KERNAL;

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
    GaussianConv #(.MAX_KERNAL(MAX_KERNAL), .X_MAX(X_MAX), .Y_MAX(Y_MAX), .PIXEL_DEPTH(PIXEL_DEPTH)) DUT (
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
        // Convolution Signals
        .conv_done(conv_done),
        // Kernel 
        .kernel_size(kernel_size),
        .sigma(sigma));

    // SRAM Module
    sram_image #(
        .PIXEL_DEPTH(PIXEL_DEPTH),
        .X_MAX(X_MAX),
        .Y_MAX(Y_MAX)
    ) IMAGE_RAM (
        .ramclk (clk),
        .x_addr   (x_addr_img),
        .y_addr   (y_addr_img),
        .wdat   (wdat_img),
        .wen    (wen_img),
        .ren    (ren_img),
        .rdat   (rdat_img)
    );

    // SRAM Module
    sram_image #(
        .PIXEL_DEPTH(PIXEL_DEPTH),
        .X_MAX(X_MAX),
        .Y_MAX(Y_MAX)
    ) CONV_SRAM (
        .ramclk (clk),
        .x_addr   (x_addr_conv),
        .y_addr   (y_addr_conv),
        .wdat   (wdat_conv),
        .wen    (wen_conv),
        .ren    (ren_conv),
        .rdat   (rdat_conv)
    );

    // task automatic do_write(input logic [PIXEL_DEPTH-1:0] d);
    //     @(negedge clk);
    //     wdat <= d;
    //     wen  <= 1;
    //     @(negedge clk);
    //     wen  <= 0;
    // endtask

    // task automatic do_read(output logic [PIXEL_DEPTH-1:0] q);
    //     @(negedge clk);
    //     wen  <= 0;
    //     @(negedge clk);            // sync read: data valid after this edge
    //     q = rdat;
    // endtask

    task reset_dut;
    begin
        n_rst = 0;
        @(negedge clk);
        n_rst = 1;
        @(posedge clk);
    end
    endtask

    task init;
    begin
        wdat_img = '0; 
        wen_img = 0; 

        ren_conv = 0;

        sigma = '0;
        new_trans = '0;

        n_rst = 1'b1;
        reset_dut();

        // Preload Buffer
        IMAGE_RAM.load_img("image/test_16x16.hex", 16, 16);
        @(negedge clk);
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

        sigma = 3'd3;
        begin_trans();

        // repeat (1000) @(negedge clk);
        while(conv_done == 0) begin
            @(negedge clk);
        end

        reset_dut;

        $finish;
    end
endmodule

/* verilator coverage_on */
