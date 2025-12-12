`timescale 1ns/10ps

module tb_writefile;

    logic clk = 0;
    logic n_rst = 0;
    logic done;

    // 10 ns clock
    always #5 clk = ~clk;

    // DUT
    writefile dut ();

    // Reset pulse
    initial begin
        n_rst = 0;
        #20 n_rst = 1;
    end

    // Stop when done asserted
    initial begin
        repeat(20) @(posedge clk);
        $finish;
    end

endmodule
