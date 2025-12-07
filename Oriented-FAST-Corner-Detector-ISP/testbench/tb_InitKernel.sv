// `timescale 1ns / 10ps
// /* verilator coverage_off */

// module tb_InitKernel ();

//     localparam CLK_PERIOD = 10ns;

//     initial begin
//         $dumpfile("waveform.vcd");
//         $dumpvars;
//     end

//     parameter [3:0] SIZE = 4'd3;
//     logic clk, n_rst;
//     logic start;
//     logic [2:0] sigma;
//     logic [SIZE-1:0][SIZE-1:0][7:0] kernel;
//     logic [63:0] sum;
//     logic done;
//     logic [63:0] test_cur;

//     // clockgen
//     always begin
//         clk = 0;
//         #(CLK_PERIOD / 2.0);
//         clk = 1;
//         #(CLK_PERIOD / 2.0);
//     end

//     task reset_dut;
//     begin
//         test_cur = "Reset";
//         n_rst = 0;
//         start = '0;
//         sigma = '0;
//         @(posedge clk);
//         @(posedge clk);
//         @(negedge clk);
//         n_rst = 1;
//         @(posedge clk);
//         @(posedge clk);
//     end
//     endtask

//     InitKernel #(.SIZE(SIZE)) DUT (
//         .clk(clk), .n_rst(n_rst),
//         .start(start),
//         .sigma(sigma),
//         .kernel(kernel),
//         .sum(sum),
//         .done(done));

//     task build;
//     begin
//         start = 1'b1;
//         @(negedge clk);
//         start = 1'b0;
//         repeat (25) @(negedge clk);
//     end
//     endtask

//     initial begin
//         n_rst = 1;

//         reset_dut; 

//         test_cur = "Test 1";
//         sigma = 3'd2;
//         build();



//         $finish;
//     end
// endmodule

// /* verilator coverage_on */


`timescale 1ns / 10ps
/* verilator coverage_off */

module tb_InitKernel ();

    localparam CLK_PERIOD = 10ns;

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars;
    end

    parameter [3:0] SIZE = 4'd5;
    logic clk, n_rst;
    logic start;
    logic [2:0] sigma;
    logic [SIZE-1:0][SIZE-1:0][7:0] kernel;
    logic [63:0] sum;
    logic done;
    logic [63:0] test_cur;

    // clockgen
    always begin
        clk = 0;
        #(CLK_PERIOD / 2.0);
        clk = 1;
        #(CLK_PERIOD / 2.0);
    end

    task reset_dut;
    begin
        test_cur = "Reset";
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

    InitKernel #(.SIZE(SIZE)) DUT (
        .clk(clk), .n_rst(n_rst),
        .start(start),
        .sigma(sigma),
        .kernel(kernel),
        .sum(sum),
        .done(done));

    task build;
    begin
        start = 1'b1;
        @(negedge clk);
        start = 1'b0;
        repeat (25) @(negedge clk);
    end
    endtask

    initial begin
        n_rst = 1;

        reset_dut; 

        test_cur = "Test 1";
        sigma = 3'd2;
        build();



        $finish;
    end
endmodule

/* verilator coverage_on */

