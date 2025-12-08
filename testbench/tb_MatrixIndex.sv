`timescale 1ns / 10ps
/* verilator coverage_off */

module tb_MatrixIndex ();

    localparam CLK_PERIOD = 10ns;

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars;
    end

    parameter [3:0] SIZE = 4'd3;
    logic clk, n_rst;
    logic [3:0] cur_x, cur_y;
    logic [SIZE-1:0][SIZE-1:0][7:0] kernel, in;
    logic en_strobe;
    logic [7:0] kernel_v, pixel_v;

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

    task strobe;
    begin
        en_strobe = 1'b1;
        @(negedge clk);
        en_strobe = 1'b0;
        @(negedge clk);
    end
    endtask

    MatrixIndex #(.SIZE(SIZE)) DUT (
        .clk(clk), .n_rst(n_rst),
        .cur_x(cur_x),
        .cur_y(cur_y),
        .kernel(kernel),
        .in(in),
        .en_strobe(en_strobe),
        .kernel_v(kernel_v),
        .pixel_v(pixel_v)
    );

    int i, n;

    initial begin
        n_rst = 1;
        en_strobe = 1'b0;

        kernel[0][0] = 8'b00011001;
        kernel[1][0] = 8'b00011101;
        kernel[2][0] = 8'b00011001;
        kernel[0][1] = 8'b00011101;
        kernel[1][1] = 8'b00100001;
        kernel[2][1] = 8'b00011101;
        kernel[0][2] = 8'b00011001;
        kernel[1][2] = 8'b00011101;
        kernel[2][2] = 8'b00011001;

        in[0][0] = 8'd25;
        in[1][0] = 8'd100;
        in[2][0] = 8'd25;
        in[0][1] = 8'd50;
        in[1][1] = 8'd150;
        in[2][1] = 8'd50;
        in[0][2] = 8'd25;
        in[1][2] = 8'd100;
        in[2][2] = 8'd25;

        for(i = 0; i < 3; i++) begin // Columns
            cur_x = 0;
            cur_y = i;
            
            for(n = 0; n < 3; n++) begin // Rows
                cur_x = n;
                strobe();
                @(negedge clk);
            end
        end
        reset_dut;

        $finish;
    end
endmodule

/* verilator coverage_on */

