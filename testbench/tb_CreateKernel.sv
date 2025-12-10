`timescale 1ns / 10ps

module tb_CreateKernel ();

    localparam CLK_PERIOD = 10ns;
    localparam MAX_KERNEL = 7;

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars;
    end

    logic clk, n_rst;
    logic [2:0] sigma;
    logic start, err, done;
    logic [MAX_KERNEL-1:0][MAX_KERNEL-1:0][7:0] kernel;
    logic [$clog2(MAX_KERNEL)-1:0] kernel_size;

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
        start = '0;
        @(posedge clk);
        @(posedge clk);
        @(negedge clk);
        n_rst = 1;
        @(posedge clk);
        @(posedge clk);
    end
    endtask

    task build;
    begin
        @(posedge clk);
        start = 1'b1;
        @(posedge clk);
        start = 1'b0;
        
        repeat (200) @(negedge clk);
    end
    endtask

    CreateKernel #(.MAX_KERNEL(MAX_KERNEL)) DUT (
        .clk(clk), .n_rst(n_rst),
        .sigma(sigma), .start(start),
        .kernel_size(kernel_size),
        .kernel(kernel),
        .err(err),
        .done(done));

    initial begin
        n_rst = 1;
        kernel_size = 3;
        sigma = 3'd1;
        reset_dut;

        repeat (5) @(negedge clk);
        kernel_size = 3;
        sigma = 3'd2;
        build();

        $finish;
    end
endmodule

/* verilator coverage_on */
