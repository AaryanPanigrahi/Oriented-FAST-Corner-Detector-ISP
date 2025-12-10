`timescale 1ns / 10ps
/* verilator coverage_off */

module tb_fast_pixel_pos ();

    localparam CLK_PERIOD = 10ns;
    localparam X_MAX = 5;
    localparam Y_MAX = 5;

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars;
    end

    logic clk, n_rst;
    logic [7:0] SRAM_in;
    logic start;

    logic write_SRAM4, new_trans, read_SRAM2;
    logic [$clog2(X_MAX) - 1:0] x_addr, y_addr, x_addr4, y_addr4;
    logic [7:0] indat;
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

    fast_pixel_pos #() DUT (
        .clk(clk),
        .n_rst(n_rst),
        .SRAM_in(SRAM_in),
        .start(start),
        .write_SRAM4(write_SRAM4),
        .read_SRAM2(read_SRAM2),
        .x_addr(x_addr),
        .y_addr(y_addr),
        .x_addr4(x_addr4),
        .y_addr4(y_addr4),
        .new_trans(new_trans)
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
  
    initial begin
        n_rst = 1;
        reset_dut;

        SRAM2.load_img("image/testing.hex", 4, 4);
        indat = 8'hAF;
        new_trans = 1;
        @(negedge clk);
        new_trans = 0;
        @(negedge clk);
        


        repeat(3) @(negedge clk);
        start = 1;
        repeat(3) @(negedge clk);
        indat = 8'hFF;
        repeat(30) @(negedge clk);

        

        $finish;
    end
endmodule

/* verilator coverage_on */

