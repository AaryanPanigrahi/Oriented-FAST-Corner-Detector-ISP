`timescale 1ns / 10ps
/* verilator coverage_off */

module tb_ComputeKernel ();

    localparam CLK_PERIOD = 10ns;

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars;
    end

    parameter [3:0] SIZE = 4'd5;
    logic clk, n_rst;
    logic [SIZE-1:0][SIZE-1:0][7:0] input_matrix, kernel;
    logic start;
    logic [7:0] blurred_pixel;
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
        input_matrix = '0;
        start = '0;
        @(posedge clk);
        @(posedge clk);
        @(negedge clk);
        n_rst = 1;
        @(posedge clk);
        @(posedge clk);
    end
    endtask

    ComputeKernel #(.SIZE(SIZE)) DUT (
        .clk(clk), .n_rst(n_rst),
        .input_matrix(input_matrix),
        .kernel(kernel),
        .start(start),
        .blurred_pixel(blurred_pixel),
        .done(done));

    logic kernel_start, kernel_done;
    CreateKernel #(.SIZE(SIZE)) build_kernel (
        .clk(clk), .n_rst(n_rst),
        .sigma(3'd1),
        .start(kernel_start),
        .kernel(kernel),
        .done(kernel_done),
        .err());

    task build;
    begin
        kernel_start = 1'b1;
        @(negedge clk);
        kernel_start = 1'b0;
        while(kernel_done == 0) begin
            @(negedge clk);
        end
    end
    endtask

    initial begin
        n_rst = 1;
        reset_dut();
        
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

        start = 1'b1;
        repeat (3) @(negedge clk);
        start = 1'b0;
        while(done == 0) begin
            @(negedge clk);
        end
        repeat (5) @(negedge clk);
        reset_dut;

        $finish;
    end
endmodule

/* verilator coverage_on */
