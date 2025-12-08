`timescale 1ns / 10ps
/* verilator coverage_off */

module tb_GaussianConv ();

    localparam CLK_PERIOD = 10ns;

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars;
    end

    // Gaussian Conv Variables
    parameter [3:0] SIZE = 4'd3;

    // Signals
    logic clk, n_rst;
    logic [2:0] sigma;
    logic start_conv;
    logic new_trans;
    logic conv_done;
    logic [7:0] blurred_pixel;
    logic err;
    logic blur_complete;

    // SRAM Variables
    localparam X_MAX = 16;
    localparam Y_MAX = 16;
    localparam PIXEL_DEPTH = 8;

    // Signals
    logic [$clog2(X_MAX):0]   x_addr;
    logic [$clog2(Y_MAX):0]   y_addr;
    logic [PIXEL_DEPTH-1:0]     wdat;
    logic                       wen, ren;
    logic [PIXEL_DEPTH-1:0]     rdat;

    // Custom Vars
    logic [PIXEL_DEPTH-1:0] q;               // Read Var

    // clockgen
    always begin
        clk = 0;
        #(CLK_PERIOD / 2.0);
        clk = 1;
        #(CLK_PERIOD / 2.0);
    end

    task reset_dut;
    begin
        n_rst = 0;
        sigma = '0;
        start_conv = '0;
        new_trans = '0;
        @(posedge clk);
        @(posedge clk);
        @(negedge clk);
        n_rst = 1;
        @(posedge clk);
        @(posedge clk);
    end
    endtask

    // DUT
    GaussianConv #(.KERNEL_SIZE(SIZE), .MEM_W(16)) DUT (
        .clk(clk), .n_rst(n_rst),
        .new_trans(new_trans),
        .start_conv(start_conv),
        .ren_img(ren), 
        .rdat_img(rdat),
        .err(err),
        .conv_done(conv_done),
        .blur_complete(blur_complete),
        .blurred_pixel(blurred_pixel),
        .x_addr_img(x_addr), 
        .y_addr_img(y_addr), 
        .sigma(sigma));

    // SRAM Module
    sram_image #(
        .PIXEL_DEPTH(PIXEL_DEPTH),
        .X_MAX(X_MAX),
        .Y_MAX(Y_MAX)
    ) IMAGE_RAM (
        .ramclk (clk),
        .x_addr   (x_addr),
        .y_addr   (y_addr),
        .wdat   (wdat),
        .wen    (wen),
        .ren    (ren),
        .rdat   (rdat)
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

    task init;
    begin
        wdat = '0; 
        wen = 0; 

        // Custom
        q = '0;     

        // Preload Buffer
        IMAGE_RAM.load_img("image/test_16x16.hex", 16, 16);
        @(negedge clk);
    end
    endtask


    task start();
        start_conv = 1'b1;
        @(negedge clk);
        start_conv = 1'b0;
        @(negedge clk);
    endtask

    task begin_trans();
        new_trans = 1'b1;
        @(negedge clk);
        new_trans = 1'b0;
        @(negedge clk);
    endtask

    initial begin
        n_rst = 1'b1;
        reset_dut();
        repeat(20) @(negedge clk);
        init();

        sigma = 3'd3;
        begin_trans(); start();


        repeat (1000) @(negedge clk);
        // while(conv_done == 0) begin
        //     @(negedge clk);
        // end

        reset_dut;

        $finish;
    end
endmodule

/* verilator coverage_on */

