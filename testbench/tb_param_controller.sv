`timescale 1ns/1ps

module tb_param_controller;
    localparam ADDR_WIDTH = 8;
    localparam DATA_WIDTH = 8;
    localparam NUM_PARAMS = 8;
    localparam X_MAX = 400;
    localparam Y_MAX = 400;

    logic clk, n_rst;

    // SRAM ⇄ controller interface
    logic [$clog2(NUM_PARAMS)-1:0]  addr_params, addr_write_params;
    logic                           ren_params, wen_params;
    logic [DATA_WIDTH-1:0]          rdat_params, wdat_params;

    logic                           new_trans;
    logic                           img_done;
    logic [$clog2(X_MAX)-1:0]       max_x;
    logic [$clog2(Y_MAX)-1:0]       max_y;
    logic [7:0]                     kernel_size;
    logic [2:0]                     sigma;

    // Expand controller addresses to full SRAM width
    logic [ADDR_WIDTH-1:0] addr, addr_write;
    logic [DATA_WIDTH-1:0] wdat, rdat;
    logic                  wen, ren;

    assign addr       = {{(ADDR_WIDTH-$clog2(NUM_PARAMS)){1'b0}}, addr_params};
    assign addr_write = {{(ADDR_WIDTH-$clog2(NUM_PARAMS)){1'b0}}, addr_write_params};
    assign wdat       = wdat_params;
    assign wen        = wen_params;
    assign ren        = ren_params;
    assign rdat_params = rdat;

    // Clock
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // SRAM with preload
    sram_model #(
        .ADDR_WIDTH         (ADDR_WIDTH),
        .DATA_WIDTH         (DATA_WIDTH),
        .RAM_IS_SYNCHRONOUS (1),
        .DUAL               (1)
    ) DUT_RAM (
        .ramclk     (clk),
        .addr       (addr),
        .addr_write (addr_write),
        .wdat       (wdat),
        .wen        (wen),
        .ren        (ren),
        .rdat       (rdat)
    );

    // Controller
    param_controller #(
        .NUM_PARAMS (NUM_PARAMS),
        .BIT_DEPTH  (DATA_WIDTH),
        .X_MAX      (X_MAX),
        .Y_MAX      (Y_MAX)
    ) U_CTRL (
        .clk              (clk),
        .n_rst            (n_rst),
        .addr_params      (addr_params),
        .ren_params       (ren_params),
        .rdat_params      (rdat_params),
        .addr_write_params(addr_write_params),
        .wen_params       (wen_params),
        .wdat_params      (wdat_params),
        .new_trans        (new_trans),
        .img_done         (img_done),
        .max_x            (max_x),
        .max_y            (max_y),
        .kernel_size      (kernel_size),
        .sigma            (sigma)
    );

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

    initial begin
        img_done = 0;
        reset_dut;

        repeat (5) @(negedge clk);
        // Preload params
        DUT_RAM.rmh("image/params_init.hex");

        // Let controller read params and set outputs
        repeat (50) @(posedge clk);

        // Optionally assert img_done so it can set DONE flag
        img_done = 1;
        @(posedge clk);
        img_done = 0;

        repeat (50) @(posedge clk);
        $finish;
    end

endmodule