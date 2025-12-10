`timescale 1ns / 10ps
/* verilator coverage_off */

module tb_fast_top_level();

    localparam CLK_PERIOD = 10ns;
    localparam X_MAX = 10;
    localparam Y_MAX = 10;
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
    logic [11:0] corner_score;

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

    // task to toggle gaus_sample_flag only during wait states
    task automatic toggle_gauss_waiting(input int total_samples);
        int samples_sent = 0;
        begin
            gaus_sample_flag = 0;
            gaus_done        = 0;

            while (samples_sent < total_samples) begin

                // Only pulse during wait states
                if (DUT.fast_controller.current_state == DUT.fast_controller.S_INIT_WAIT ||
                    DUT.fast_controller.current_state == DUT.fast_controller.S_WAIT_GAUS) begin

                    // Pulse sample flag
                    gaus_sample_flag = 1;
                    @(negedge clk);
                    gaus_sample_flag = 0;
                    @(negedge clk);

                    samples_sent++;

                    // >>> Assert gaus_done on the LAST sample <<<
                    if (samples_sent == total_samples - 1) begin
                        gaus_done = 1;
                    end

                end else begin
                    // Not in Gaussian wait state — pause
                    @(negedge clk);
                end
            end
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
        .max_y(max_y),
        .corner_score(corner_score)
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
  
    sram_image #(.X_MAX(X_MAX), .Y_MAX(Y_MAX), .PIXEL_DEPTH(12)) SRAM4(
        .ramclk(clk),
        .x_addr(x_addr4),
        .y_addr(y_addr4),
        .ren(),
        .rdat(),
        .wen(write_SRAM4),
        .wdat(corner_score)        
    );
  
    initial begin
        reset_dut;
        max_x = 10;
        max_y = 10;
        @(negedge clk);
        new_trans = 0;
        @(negedge clk);
        new_trans = 1;
        SRAM2.load_img("image/testing.hex", X_MAX, Y_MAX);
        @(negedge clk);
        new_trans = 0;

        toggle_gauss_waiting(X_MAX * Y_MAX);

        while (!(DUT.fast_controller.current_state == DUT.fast_controller.S_DONE &&
                DUT.fast_compute.current_state == DUT.fast_compute.IDLE)) begin
            repeat(34)@(negedge clk);
        end


        // Dump output
        SRAM4.dump_img("image/smiley_ouuuut.hex", X_MAX, Y_MAX);

        $finish;
    end

endmodule

/* verilator coverage_on */

