`timescale 1ns / 10ps
/* verilator coverage_off */

module tb_InitKernel ();

    localparam CLK_PERIOD = 10ns;
    localparam MAX_KERNAL = 4'd7;

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars;
    end

    logic clk, n_rst;
    logic start;
    logic [2:0] sigma;
    logic [MAX_KERNAL-1:0][MAX_KERNAL-1:0][7:0] kernel;
    logic [$clog2(MAX_KERNAL)-1:0] kernel_size;
    logic [63:0] sum;
    logic done;

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
        start = '0;
        sigma = '0;
        @(posedge clk);
        @(posedge clk);
        @(negedge clk);
        n_rst = 1;
        @(posedge clk);
        @(posedge clk);
    end
    endtask

    InitKernel #(.MAX_KERNAL(MAX_KERNAL)) DUT (
        .clk(clk), .n_rst(n_rst),
        .start(start),
        .sigma(sigma),
        .kernel_size(kernel_size),
        .kernel(kernel),
        .sum(sum),
        .done(done));

    task build;
    begin
        start = 1'b1;
        @(negedge clk);
        start = 1'b0;

        
        repeat (MAX_KERNAL * MAX_KERNAL + 10) @(negedge clk);
    end
    endtask

    initial begin
        n_rst = 1;

        reset_dut; 

        sigma = 3'd2;
        kernel_size = 3;
        build();
        
        $finish;
    end
endmodule

/* verilator coverage_on */
