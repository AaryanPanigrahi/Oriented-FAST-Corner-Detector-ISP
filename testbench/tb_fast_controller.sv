`timescale 1ns / 10ps
/* verilator coverage_off */

module tb_fast_controller ();

    localparam CLK_PERIOD = 10ns;

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars;
    end

    logic clk, n_rst;

    // Gaussian signals
    logic gaus_sample_flag;
    logic gaus_done;

    // FAST signals
    logic fast_done_flag;

    logic fast_start;

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

    fast_controller #(.WIDTH(5)) DUT (
        .clk(clk),
        .n_rst(n_rst),
        .gaus_sample_flag(gaus_sample_flag),
        .gaus_done(gaus_done),
        .fast_done_flag(fast_done_flag),
        .fast_start(fast_start)
    );

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

    task toggle_fast(
        input int CYCLES
    );
        for (int i = 0; i < CYCLES; i++) begin
            fast_done_flag = 1;
            @(negedge clk);
            fast_done_flag = 0;
            @(negedge clk);
        end
    endtask


    initial begin
        n_rst = 1;
        gaus_done = 0;
        reset_dut;

        toggle_gauss(16);
        toggle_fast(5);
        toggle_gauss(4);
        gaus_sample_flag = 1;
        gaus_done = 1;
        @(negedge clk);
        gaus_done = 0;
        gaus_sample_flag = 0;
        toggle_fast(5);
        

        $finish;
    end
endmodule

/* verilator coverage_on */

