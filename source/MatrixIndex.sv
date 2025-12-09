`timescale 1ns / 10ps

module MatrixIndex #(
    parameter [3:0] SIZE = 4'd3
) (
    input logic clk, n_rst,
    input logic [3:0] cur_x, cur_y,
    input logic [SIZE-1:0][SIZE-1:0][7:0] kernel, in,
    input logic en_strobe,
    output logic [7:0] kernel_v, pixel_v
);
logic [7:0] next_pixel_v, next_kernel_v;

always_ff @(posedge clk, negedge n_rst) begin
    if (~n_rst) begin
        pixel_v <= '0;
        kernel_v <= '0;
    end
    else begin
        pixel_v <= next_pixel_v;
        kernel_v <= next_kernel_v;
    end
end
always_comb begin : Index_Kernel
    if(en_strobe) begin
        next_pixel_v = in[cur_x][cur_y][7:0];
        next_kernel_v = kernel[cur_x][cur_y][7:0];
    end
    else begin
        next_pixel_v = pixel_v;
        next_kernel_v = kernel_v;
    end
end

endmodule
