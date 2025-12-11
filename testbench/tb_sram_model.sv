`timescale 1ns/1ps

module tb_sram_model;

    localparam ADDR_WIDTH = 8;
    localparam DATA_WIDTH = 32;
    localparam DUAL = 1;

    // Signals
    logic                   clk;
    logic [ADDR_WIDTH-1:0]  addr;
    logic [ADDR_WIDTH-1:0]  addr_write;
    logic [DATA_WIDTH-1:0]  wdat;
    logic                   wen, ren;
    logic [DATA_WIDTH-1:0]  rdat;

    // DUT
    sram_model #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH),
        .RAM_IS_SYNCHRONOUS(1),
        .DUAL(DUAL)
    ) DUT (
        .ramclk         (clk),
        .addr           (addr),
        .addr_write     (addr_write),
        .wdat           (wdat),
        .wen            (wen),
        .ren            (ren),
        .rdat           (rdat)
    );

    // Clk Gen - 100 Mhz
    initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end

    // Simple tasks
    task automatic do_write(input logic [ADDR_WIDTH-1:0] a,
                            input logic [DATA_WIDTH-1:0] d);
        @(posedge clk);
        addr <= a;

        wdat <= d;
        wen  <= 1;
        ren  <= 0;
        @(posedge clk);
        wen  <= 0;
    endtask

    task automatic do_write_dual(input logic [ADDR_WIDTH-1:0] a,
                            input logic [DATA_WIDTH-1:0] d);
        @(posedge clk);
        addr_write <= a; 

        wdat <= d;
        wen  <= 1;
        ren  <= 0;
        @(posedge clk);
        wen  <= 0;
    endtask

    task automatic do_read(input  logic [ADDR_WIDTH-1:0] a);
        @(posedge clk);
        addr <= a;
        wen  <= 0;
        ren  <= 1;
        @(posedge clk);       
        ren <= 0;
    endtask

    task automatic do_read_write(input  logic [ADDR_WIDTH-1:0] a,
                                input  logic [ADDR_WIDTH-1:0] a_w,
                                input logic [DATA_WIDTH-1:0] d);
        @(posedge clk);
        addr <= a;
        addr_write <= a_w;

        wen  <= 1;
        ren  <= 1;

        wdat <= d;
        @(posedge clk);
        wen  <= 0;
        ren <= 0;
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
        addr = 0;
        addr_write = 0;
        wdat = '0; 
        wen = 0; 
        ren = 0;      
    end
    endtask

    // Test sequence
    initial begin
        init();

        ////    ////    ////    ////    ////    ////
        // Preload Mem
        DUT.rmh("image/init_mem.hex");

        // Read Loaded Data
        for (int i = 0; i < 16; i++) begin
            do_read(i);
        end
        ////    ////    ////    ////    ////    ////

        ////    ////    ////    ////    ////    ////
        // Write Check
        for (int i = 0; i < 16; i++) begin
            do_write(i, i*4);
        end

        // Read Check
        for (int i = 0; i < 16; i++) begin
            do_read(i);
        end
        ////    ////    ////    ////    ////    ////

        ////    ////    ////    ////    ////    ////
        // Do Read and Write checks at the same time
        for (int i = 0; i < 4; i++) begin
            do_read_write(i + 1, i, i * i + 1);
        end

        // RAW CHECK
        for (int i = 5; i < 12; i++) begin
            do_read_write(i + 1, i, i * i);
        end
        ////    ////    ////    ////    ////    ////

        ////    ////    ////    ////    ////    ////
        // RAW Checker
        do_write(8'h10, 32'hDEADBEEF);
        do_read (8'h10);  
        ////    ////    ////    ////    ////    ////

        // End
        wait_ten;
        $finish;
    end

endmodule
