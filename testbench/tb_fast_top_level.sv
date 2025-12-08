`timescale 1ns / 10ps
/* verilator coverage_off */

module tb_fast_top_level();

    localparam CLK_PERIOD = 10ns;
    localparam X_MAX = 5;
    localparam Y_MAX = 5;
    localparam THRESHOLD = 20;

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars;
    end

    logic clk, n_rst;
    logic [7:0] SRAM_in;
    logic gaus_sample_flag, gaus_done;
    logic new_trans;
    logic write_SRAM4, read_SRAM2;
    logic [$clog2(X_MAX):0] x_addr, y_addr, x_addr4, y_addr4;
    logic [$clog2(X_MAX) - 1:0] max_y, max_x;

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
        @(posedge clk);
        @(posedge clk);
        @(negedge clk);
        n_rst = 1;
        @(posedge clk);
        @(posedge clk);
    end
    endtask

    task toggle_gauss(
        input int CYCLES
    );
        for (int i = 0; i < CYCLES; i++) begin
            gaus_sample_flag = 1;
            @(negedge clk);
            gaus_sample_flag = 0;
            @(negedge clk);
        end
    endtask

    fast_top_level #(.X_MAX(X_MAX), .Y_MAX(Y_MAX), .THRESHOLD(THRESHOLD)) DUT (
        .clk(clk),
        .n_rst(n_rst),
        .SRAM_in(SRAM_in),
        .gaus_done(gaus_done),
        .gaus_sample_flag(gaus_sample_flag),
        .write_SRAM4(write_SRAM4),
        .read_SRAM2(read_SRAM2),
        .x_addr(x_addr),
        .y_addr(y_addr),
        .x_addr4(x_addr4),
        .y_addr4(y_addr4),
        .new_trans(new_trans),
        .max_x(max_x),
        .max_y(max_y)
    );

    sram_image #(.X_MAX(X_MAX), .Y_MAX(Y_MAX)) SRAM2(
        .ramclk(clk),
        .x_addr(x_addr),
        .y_addr(y_addr),
        .ren(read_SRAM2),
        .rdat(SRAM_in),
        .wen(),
        .wdat()        
    );
  
    initial begin
        n_rst = 1;
        reset_dut;
        gaus_sample_flag = 0;
        new_trans = 0;
        max_y = X_MAX;
        max_x = Y_MAX;
        SRAM2.load_img("image/testing.hex", X_MAX, Y_MAX);
        @(negedge clk);
        new_trans = 1;
        @(negedge clk);
        new_trans = 0;
        toggle_gauss(X_MAX * 3);
        repeat(26) @(negedge clk);
        @(negedge clk);
        repeat(70) @(negedge clk);
        toggle_gauss(X_MAX);
        repeat(100) @(negedge clk);

        $finish;
    end
endmodule

/* verilator coverage_on */

