`timescale 1ns / 10ps
/* verilator coverage_off */

module tb_ComputeBW ();

    localparam CLK_PERIOD = 10ns;

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars;
    end

    logic clk, n_rst;
    logic [7:0] pixel_red;
    logic [7:0] pixel_green;
    logic [7:0] pixel_blue;
    logic start;
    logic clear;
    logic clear_flag;
    logic [7:0] grayed_pixel;

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
        pixel_red = '0;
        pixel_green = '0;
        pixel_blue = '0;
        start = 1'b0;
        clear = 1'b0;
        @(posedge clk);
        @(posedge clk);
        @(negedge clk);
        n_rst = 1;
        @(posedge clk);
        @(posedge clk);
    end
    endtask

    task comp;
    begin
        @(posedge clk);
        start = 1'b1;
        @(posedge clk);
        start = 1'b0;
        
        while(clear_flag == 0) begin
            @(negedge clk);
        end
        repeat (2) @(posedge clk);
        clear = 1'b1;
        @(posedge clk);
        clear = 1'b0;
    end
    endtask

    ComputeBW DUT (
    .clk(clk), .n_rst(n_rst),
    .pixel_red(pixel_red),
    .pixel_green(pixel_green),
    .pixel_blue(pixel_blue),
    .start(start),
    .clear(clear),
    .clear_flag(clear_flag),
    .grayed_pixel(grayed_pixel));

    //Testing Reals
    real red = 0.299;
    real green = 0.577;
    real blue = 0.114;
    real expected;
    real percent_error;

    initial begin
        n_rst = 1;
        reset_dut;

        // pixel_red = 8'd100;
        // pixel_green = 8'd50;
        // pixel_blue = 8'd25;

        // comp();

        for (int i = 0; i < 255; i++) begin
            for (int j = 0; j < 255; j += 2) begin
                for (int k = 0; k < 255; k += 3) begin
                    pixel_red = i;
                    pixel_green = j;
                    pixel_blue = k;
                    comp();
                    expected = pixel_red * red + pixel_green * green + pixel_blue * blue;
                    percent_error = $sqrt((((grayed_pixel - expected) / grayed_pixel) * 100) ** 2);
                    if (percent_error > 5) begin 
                        $display("Incorrect value for red = %d, green = %d, blue = %d", i, j, k );
                        $display("Percent error: %d percent.    Expected:   %d.     Got:       %d", percent_error, expected, grayed_pixel);
                    end
                    @(negedge clk);
                    
                end
            end
        end

        reset_dut;
        $finish;
    end
endmodule

/* verilator coverage_on */

