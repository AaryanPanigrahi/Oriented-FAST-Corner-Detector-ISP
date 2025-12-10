`timescale 1ns / 10ps
/* verilator coverage_off */

module tb_pipelined_buffer_loader ();

    localparam CLK_PERIOD = 10ns;

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars;
    end

    logic clk, n_rst;
    logic signed [8:0] curr_x, curr_y;
    logic [7:0] input_pixel;
    logic start;
    logic [8:0] x_addr, y_addr, x_addr4, y_addr4;
    logic update_sample, read_SRAM2, write_SRAM4;

    // clockgen
    always begin
        clk = 0;
        #(CLK_PERIOD / 2.0);
        clk = 1;
        #(CLK_PERIOD / 2.0);
    end

    // DUT instantiation
    pipelined_buffer_loader DUT (
        .clk(clk),
        .n_rst(n_rst),
        .curr_x(curr_x),
        .curr_y(curr_y),
        .input_pixel(input_pixel),
        .start(start),
        .x_addr(x_addr),
        .y_addr(y_addr),
        .x_addr4(x_addr4),
        .y_addr4(y_addr4),
        .update_sample(update_sample),
        .read_SRAM2(read_SRAM2),
        .write_SRAM4(write_SRAM4)
    );

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


    initial begin
        n_rst = 1;

        reset_dut;

        input_pixel = 8'hAF;
        curr_x = 9'b00000000;
        curr_y = 9'b00000000;

        repeat(2) @(negedge clk);
        start = 1;
        repeat(4) @(negedge clk);
        input_pixel = 8'hFF;
        repeat(26) @(negedge clk);
        //input_pixel = 8'h0F;

        reset_dut;
        
        input_pixel = 8'hAF;
        curr_x = 9'b000001000;
        curr_y = 9'b000001000;
        
        repeat(16) @(negedge clk);


        // input_pixel = 8'hAF;
        // curr_x = 9'b000000100;
        // curr_y = 9'b000000100;

        // repeat(6) @(negedge clk);
        // input_pixel = 8'hFF;
        // repeat(10) @(negedge clk);
        // //input_pixel = 8'h0F;

        // repeat(5) @(negedge clk);
        // repeat(25) @(negedge clk);

        $finish;
    end
endmodule

/* verilator coverage_on */

