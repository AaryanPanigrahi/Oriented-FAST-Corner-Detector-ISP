`timescale 1ns / 10ps
/* verilator coverage_off */

module tb_KernelAccumulator ();

    localparam CLK_PERIOD = 10ns;

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars;
    end

    parameter [3:0] SIZE = 4'd3;
    logic clk, n_rst;
    logic [SIZE-1:0][SIZE-1:0][7:0] in, kernel;
    logic en_strobe;
    logic [3:0] cur_x, cur_y;
    logic clear, start, ready;
    logic [7:0] sum;

    KernelAccumulator DUT(
        .clk(clk), .n_rst(n_rst),
        .in(in),
        .kernel(kernel),
        .en_strobe(en_strobe),
        .cur_x(cur_x),
        .cur_y(cur_y),
        .clear(clear),
        .start(start),
        .ready(ready),
        .sum(sum)
    );

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

    MatrixIndex #() DUT (.*);

    initial begin
        n_rst = 1;

        
        reset_dut;

        $finish;
    end
endmodule

/* verilator coverage_on */

