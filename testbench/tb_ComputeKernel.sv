`timescale 1ns / 10ps
/* verilator coverage_off */

module tb_ComputeKernel ();

    localparam CLK_PERIOD = 10ns;
    localparam [3:0] MAX_KERNEL = 4'd7;

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars;
    end

    logic clk, n_rst;
    logic [MAX_KERNEL-1:0][MAX_KERNEL-1:0][7:0] input_matrix, kernel;
    logic start;
    logic [7:0] blurred_pixel;
    logic [$clog2(MAX_KERNEL)-1:0] kernel_size;
    logic done;
    logic clear, clear_flag;
    logic [2:0] sigma;
    
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
        input_matrix = '0;
        start = '0;
        @(posedge clk);
        n_rst = 1;
        @(posedge clk);
    end
    endtask

    logic kernel_start, kernel_done;
    CreateKernel #(.MAX_KERNEL(MAX_KERNEL)) build_kernel (
        .clk(clk), .n_rst(n_rst),
        // Params
        .sigma(sigma),
        .kernel_size(kernel_size),
        // IO
        .start(kernel_start),
        .done(kernel_done),
        // Output
        .err(),
        .kernel(kernel));

    ComputeKernel #(.MAX_KERNEL(MAX_KERNEL)) DUT (
        .clk(clk), .n_rst(n_rst),
        // Params
        .kernel_size(kernel_size),
        // IO
        .start(start),
        .done(done),
        // Input Arrays
        .input_matrix(input_matrix),
        .kernel(kernel),
        // Out
        .blurred_pixel(blurred_pixel),
        // Telemetry
        .clear(clear),
        .clear_flag(clear_flag));

    task build;
    begin
        @(posedge clk);
        kernel_start = 1'b1;
        @(posedge clk);
        kernel_start = 1'b0;
        
        //repeat (500) @(negedge clk);
        while(kernel_done == 0) begin
            @(negedge clk);
        end
    end
    endtask

    initial begin
        n_rst = 1;
        kernel_size = 1;
        sigma = 1;
        start = 0;
        clear = 0;
        kernel_start = 0;
        reset_dut();

        sigma = 1;
        kernel_size = 3;
        
        build();

        input_matrix[0][0] = 8'd10;
        input_matrix[1][0] = 8'd10;
        input_matrix[2][0] = 8'd10;
        input_matrix[3][0] = 8'd10;
        input_matrix[4][0] = 8'd10;

        input_matrix[0][1] = 8'd10;
        input_matrix[1][1] = 8'd50;
        input_matrix[2][1] = 8'd50;
        input_matrix[3][1] = 8'd50;
        input_matrix[4][1] = 8'd10;

        input_matrix[0][2] = 8'd10;
        input_matrix[1][2] = 8'd50;
        input_matrix[2][2] = 8'd200;
        input_matrix[3][2] = 8'd50;
        input_matrix[4][2] = 8'd10;

        input_matrix[0][3] = 8'd10;
        input_matrix[1][3] = 8'd50;
        input_matrix[2][3] = 8'd50;
        input_matrix[3][3] = 8'd50;
        input_matrix[4][3] = 8'd10;

        input_matrix[0][4] = 8'd10;
        input_matrix[1][4] = 8'd10;
        input_matrix[2][4] = 8'd10;
        input_matrix[3][4] = 8'd10;
        input_matrix[4][4] = 8'd10;


        @(posedge clk);
        start = 1'b1;
        @(posedge clk);
        start = 1'b0;

        //repeat (500) @(negedge clk);
        while(done == 0) begin
            @(negedge clk);
        end
        repeat (5) @(negedge clk);
        reset_dut;

        $finish;
    end
endmodule

/* verilator coverage_on */
