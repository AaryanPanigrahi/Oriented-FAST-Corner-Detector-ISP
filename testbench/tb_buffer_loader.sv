`timescale 1ns / 10ps
/* verilator coverage_off */

module tb_buffer_loader ();

    logic [8:0] curr_x, curr_y;
    logic [7:0] input_pixel;
    logic start;
    logic [8:0] x_addr, y_addr;
    logic done;
    logic [7:0] buff_output [15:0];
    logic [7:0] center_value;

    localparam CLK_PERIOD = 10ns;

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars;
    end

    logic clk, n_rst;

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

    buffer_loader DUT (
        .clk(clk),
        .n_rst(n_rst),
        .curr_x(curr_x),
        .curr_y(curr_y),
        .input_pixel(input_pixel),
        .start(start),
        .x_addr(x_addr),
        .y_addr(y_addr),
        .done(done),
        .buff_output(buff_output),
        .center_value(center_value)
    );

    integer i = 0;

    task PRINT_BUFF_LOADER;
    begin
        for (i = 0; i < 16; i++) begin
            $display("buff_output[%0d] = %0d (0x%02h)", 
                 i, buff_output[i], buff_output[i]);
        end
    end
    endtask

    initial begin
        n_rst = 1;

        reset_dut;

        input_pixel = 8'b11111111;
        curr_x = 9'b000000100;
        curr_y = 9'b000000100;

        repeat(2) @(negedge clk);
        start = 1;
        repeat(36) @(negedge clk);
        PRINT_BUFF_LOADER;

        $finish;
    end
endmodule

/* verilator coverage_on */

