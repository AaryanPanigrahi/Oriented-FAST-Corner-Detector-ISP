`timescale 1ns/10ps

module tb_conv_memory;
    // Kernel Params
    parameter MAX_KERNAL = 3;
    parameter PIXEL_DEPTH = 8;

    // RAM Image
    localparam X_MAX = 16;
    localparam Y_MAX = 16;

    // Sync
    logic clk, n_rst;

    // getting from image SRAM
    logic [$clog2(X_MAX):0] x_addr_img;
    logic [$clog2(Y_MAX):0] y_addr_img;
    logic ren_img;
    logic [PIXEL_DEPTH-1:0] rdat_img;

    // getting from img_param SRAM
    logic [7:0] kernel_size;

    // pixel_pos.sv
    logic [1:0] next_dir;
    logic [$clog2(X_MAX) - 1:0] curr_x;
    logic [$clog2(Y_MAX) - 1:0] curr_y;

    // from gaussian conv
    logic new_sample_req;
    logic new_trans;

    logic [$clog2(X_MAX) - 1:0] max_x;
    logic [$clog2(Y_MAX) - 1:0] max_y;

    // to gaussian conv
    logic new_sample_ready;
    logic [MAX_KERNAL-1:0][MAX_KERNAL-1:0] [PIXEL_DEPTH - 1:0] working_memory;

    // Custom
    logic [PIXEL_DEPTH-1:0]     first, last, top_right, bottom_left;
    assign first = working_memory[0][0][7:0];
    assign last = working_memory[kernel_size - 1][kernel_size - 1][7:0]; 
    assign top_right =  working_memory[kernel_size - 1][0][7:0];
    assign bottom_left =  working_memory[0][kernel_size - 1][7:0];

    // DUT
    sram_image #(
        .PIXEL_DEPTH(PIXEL_DEPTH),
        .X_MAX(X_MAX),
        .Y_MAX(Y_MAX)
    ) IMAGE_RAM (
        .ramclk (clk),
        .x_addr   (x_addr_img),
        .y_addr   (y_addr_img),
        .wdat   (8'd0),
        .wen    (0),
        .ren    (ren_img),
        .rdat   (rdat_img)
    );

    // DUT instance
    conv_memory #(
        .MAX_KERNAL (MAX_KERNAL),
        .X_MAX      (X_MAX),
        .Y_MAX      (Y_MAX),
        .PIXEL_DEPTH(PIXEL_DEPTH)
    ) GAUSSIAN_MEM (
        .clk            (clk),
        .n_rst          (n_rst),
        .x_addr_img     (x_addr_img),
        .y_addr_img     (y_addr_img),
        .ren_img        (ren_img),
        .rdat_img       (rdat_img),
        .kernel_size    (kernel_size),
        .next_dir       (next_dir),
        .curr_x         (curr_x),
        .curr_y         (curr_y),
        .new_trans      (new_trans),
        .new_sample_req (new_sample_req),
        .new_sample_ready(new_sample_ready),
        .working_memory (working_memory)
    );

    // Instantiate DUT
    pixel_pos #(.X_MAX(X_MAX), .Y_MAX(Y_MAX)) PIXEL_CORR (
        .clk(clk),
        .n_rst(n_rst),
        .update_pos(new_sample_req),
        .new_trans(new_trans),
        .max_x(max_x),
        .max_y(max_y),
        .end_pos(),
        .next_dir(next_dir),
        .curr_x(curr_x),
        .curr_y(curr_y)
    );

    // Clk Gen -  100 Mhz
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;    
    end

    typedef enum bit [1:0] {
        IDLE, RIGHT, LEFT, DOWN
    } DIRECTION;

    DIRECTION next_move = IDLE;

    always #5 begin
        case (next_dir)
            2'b00: next_move = RIGHT;
            2'b01: next_move = LEFT;
            2'b10: next_move = DOWN;
            2'b11: next_move = DOWN;
            default: next_move = IDLE;
        endcase
    end

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
        repeat (1) @(posedge clk);
        n_rst = 1;
    end
    endtask

    task reset_trans;
    begin
        @(posedge clk);
        new_trans = 1;
        repeat (1) @(posedge clk);
        new_trans = 0;
    end
    endtask

    task req_new_sam;
    begin
        @(posedge clk);
        new_sample_req = 1'b1;
        @(posedge clk);
        new_sample_req = 1'b0;
    end
    endtask

    ////    ////    ////    ////    ////    ////    ////
    // ONLY FOR TESTING //
    logic [$clog2(X_MAX):0] x_addr_test;
    logic [$clog2(Y_MAX):0] y_addr_test;
    logic ren_test;
    logic [PIXEL_DEPTH-1:0] rdat_test;

    sram_image #(
        .PIXEL_DEPTH(PIXEL_DEPTH),
        .X_MAX(X_MAX),
        .Y_MAX(Y_MAX)
    ) IMAGE_RAM2 (
        .ramclk (clk),
        .x_addr   (x_addr_test),
        .y_addr   (y_addr_test),
        .wdat   (8'd0),
        .wen    (0),
        .ren    (ren_test),
        .rdat   (rdat_test)
    );

    task automatic do_read(input logic [$clog2(X_MAX):0] x,
                           input logic [$clog2(Y_MAX):0] y);
        @(posedge clk);
        x_addr_test <= x;
        y_addr_test <= y;
        ren_test  <= 1;
    endtask

    task automatic do_read_range(input logic [$clog2(X_MAX):0] x_int,
                                input logic [$clog2(X_MAX):0] x_end,
                                input logic [$clog2(X_MAX):0] y_int,
                                input logic [$clog2(Y_MAX):0] y_end);
        logic [$clog2(X_MAX):0] x_idx;
        logic [$clog2(X_MAX):0] y_idx;

        for (y_idx = y_int; y_idx < y_end; y_idx++) begin
            for (x_idx = x_int; x_idx < x_end; x_idx++) begin
                do_read(x_idx, y_idx);
            end
        end
        ren_test <= 0;
    endtask
    ////    ////    ////    ////    ////    ////    //// 

    task automatic run_conv(input logic [$clog2(X_MAX):0] x_dim,
                           input logic [$clog2(Y_MAX):0] y_dim,
                           input logic [$clog2(MAX_KERNAL):0] k_size);
    begin
        kernel_size = k_size;
        max_x = x_dim;
        max_y = y_dim;

        // New Trans
        reset_trans;

        // First Trans
        wait_time((k_size * k_size) + (k_size ** 2) + 10);
        req_new_sam;

        // Rest of transaction
        for (int idx = 0; idx < (x_dim) * (y_dim); idx++) begin
            wait_time(k_size ** 2);

            req_new_sam;
        end
    end
    endtask

    task init;
    begin
        n_rst = 1;
        new_trans = 0;

        // Default values
        kernel_size     = 8'd1;                   
        new_sample_req  = 1'b0;

        max_x = 4;
        max_y = 4;

        // Test SRAM
        x_addr_test <= 0;
        y_addr_test <= 0;
        ren_test <= 0;

        reset_dut;
    end
    endtask

    // Testbench
    initial begin
        init;

        // Check SRAM working
        IMAGE_RAM2.load_img("image/test_5x5.hex", 5, 5);
        wait_time (2);
        do_read_range(0, 5, 0, 5);

        // Preload Mem
        IMAGE_RAM.load_img("image/test_5x5.hex", 5, 5);
        wait_time (2);
        run_conv(5, 5, 3);

        wait_fifty;

        // Preload Mem
        IMAGE_RAM.load_img("image/test_9x9.hex", 9, 9);
        wait_time (2);
        run_conv(9, 9, 3);

        wait_fifty;

        // Preload Mem
        IMAGE_RAM.load_img("image/test_16x16.hex", 16, 16);
        wait_time (2);
        run_conv(16, 16, 3);

        wait_fifty;

        // Preload Mem
        IMAGE_RAM.load_img("image/test_200x200.hex", 200, 200);
        wait_time (2);
        run_conv(200, 200, 3);      
        
        wait_time(300);   

        $finish;
    end
endmodule
