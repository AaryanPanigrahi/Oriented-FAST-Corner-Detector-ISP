`timescale 1ns/1ps

module tb_sram_image;
    localparam X_MAX = 200;
    localparam Y_MAX = 200;
    localparam PIXEL_DEPTH = 8;
    localparam DUAL = 1;

    // Signals
    logic                       clk;
    logic [$clog2(X_MAX):0]   x_addr, x_addr_write;
    logic [$clog2(Y_MAX):0]   y_addr, y_addr_write;
    logic [PIXEL_DEPTH-1:0]     wdat;
    logic                       wen, ren;
    logic [PIXEL_DEPTH-1:0]     rdat;

    // DUT
    sram_image #(
        .PIXEL_DEPTH(PIXEL_DEPTH),
        .X_MAX(X_MAX),
        .Y_MAX(Y_MAX),
        .DUAL(DUAL)
    ) IMAGE_RAM (
        .ramclk (clk),
        .x_addr   (x_addr),
        .y_addr   (y_addr),
        .x_addr_write (x_addr_write),
        .y_addr_write (y_addr_write),
        .wdat   (wdat),
        .wen    (wen),
        .ren    (ren),
        .rdat   (rdat)
    );

    // Clk Gen - 100 Mhz
    initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end

    // Simple tasks
    task automatic do_write(input logic [$clog2(X_MAX)-1:0] x,
                            input logic [$clog2(Y_MAX)-1:0] y,
                            input logic [PIXEL_DEPTH-1:0] d);
        @(posedge clk);
        x_addr <= x;
        y_addr <= y;
        wdat <= d;
        wen  <= 1;
        ren  <= 0;
        @(posedge clk);
        wen  <= 0;
    endtask

    // Simple tasks
    task automatic do_write_dual(input logic [$clog2(X_MAX)-1:0] x,
                            input logic [$clog2(Y_MAX)-1:0] y,
                            input logic [PIXEL_DEPTH-1:0] d);
        @(posedge clk);
        x_addr_write <= x;
        y_addr_write <= y;
        wdat <= d;
        wen  <= 1;
        ren  <= 0;
        @(posedge clk);
        wen  <= 0;
    endtask

    task automatic do_read(input logic [$clog2(X_MAX)-1:0] x,
                           input logic [$clog2(Y_MAX)-1:0] y);
        @(posedge clk);
        x_addr <= x;
        y_addr <= y;
        wen  <= 0;
        ren  <= 1;

        // @(posedge clk);            // sync read: data valid after this edge
        // ren <= 0;
    endtask

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

    task init;
    begin
        x_addr = '0; 
        y_addr = '0; 
        wdat <= '0; 
        wen = 0; 
        ren = 0;    

        // Preload Buffer
        IMAGE_RAM.load_img("image/test_200x200.hex", 200, 200);
        wait_time(1);   
    end
    endtask

    // Test sequence
    initial begin
        init();

        ////    ////    ////    ////    ////
        // Preload Mem
        IMAGE_RAM.load_img("image/test_16x16.hex", 16, 16);
        wait_time(5);   

        // Loaded Image Read Check
        for (int idx_y = 0; idx_y < 16; idx_y++) begin
            for (int idx_x = 0; idx_x < 16; idx_x++) begin
                do_read(idx_x, idx_y);
            end
        end
        ////    ////    ////    ////    ////   

        ////    ////    ////    ////    ////  
        // Write Check
        for (int idx_y = 0; idx_y < 4; idx_y++) begin
            for (int idx_x = 0; idx_x < 4; idx_x++) begin
                do_write(idx_x, idx_y, (idx_x + 1)*(idx_y + 1)*4);
            end
        end
        
        // Read Check
        for (int idx_y = 0; idx_y < 4; idx_y++) begin
            for (int idx_x = 0; idx_x < 4; idx_x++) begin
                do_read(idx_x, idx_y);
            end
        end
        ////    ////    ////    ////    ////   

        ////    ////    ////    ////    ////
        // Checking DUAL PORT Behaviour
        // Write Check
        for (int idx_y = 0; idx_y < 4; idx_y++) begin
            for (int idx_x = 0; idx_x < 4; idx_x++) begin
                do_write_dual(idx_x, idx_y, (idx_x + 1)*(idx_y + 1)*4);
            end
        end
        ////    ////    ////    ////    ////   

        ////    ////    ////    ////    ////
        // RAW Checker
        do_write(8'h10, 8'h2, 32'hDEADBEEF);
        do_read(8'h10, 8'h2);
        ////    ////    ////    ////    ////

        ////    ////    ////    ////    ////
        // Write Image to whole buffer
        IMAGE_RAM.load_img("image/test_200x200.hex", 200, 200);
        ////    ////    ////    ////    ////

        ////    ////    ////    ////    ////
        // Out of Bounds Checker
        // X out of bound
        do_read(8'd255, 8'd2);

        // Y out of bound
        do_read(8'd20, 8'd254);

        // X-Y out of bound
        do_read(8'd254, 8'd255);
        ////    ////    ////    ////    ////

        ////    ////    ////    ////    ////
        // Read Write Tests
        IMAGE_RAM.load_img("image/test_5x5.hex", 5, 5);
        wait_time(5); 
        IMAGE_RAM.dump_img("write_5x5.hex", 5, 5);
        ////    ////    ////    ////    ////

        // End
        wait_time(5);
        $finish;
    end

endmodule
