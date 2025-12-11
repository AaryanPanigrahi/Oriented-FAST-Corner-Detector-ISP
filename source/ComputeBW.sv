`timescale 1ns / 10ps

module ComputeBW (
    input logic clk, n_rst,
    input logic [7:0] pixel_red,
    input logic [7:0] pixel_green,
    input logic [7:0] pixel_blue,
    input logic start,
    input logic clear,
    output logic clear_flag,
    output logic [7:0] grayed_pixel
);
// Parameters
localparam [7:0] RED   = 8'b01001101;
localparam [7:0] GREEN = 8'b10010110;
localparam [7:0] BLUE  = 8'b00011101;

// Comp Logic
logic [7:0] nextGray; 
logic [17:0] tempGray;
logic next_clear_flag;

always_ff @(posedge clk, negedge n_rst) begin
    if (!n_rst) begin
        grayed_pixel <= '0;
        clear_flag <= 1'b0;
    end
    else begin
        grayed_pixel <= nextGray[7:0];
        clear_flag <= next_clear_flag;
    end
end

always_comb begin
    // Default Case
    nextGray = grayed_pixel;
    next_clear_flag = clear_flag;
    tempGray = '0;

    if (start) begin
        // Applies the weights to each color
        tempGray = 
        ((RED  * pixel_red) +
        (GREEN * pixel_green) +
        (BLUE  * pixel_blue));
        // Rounds the gray scaled value
        nextGray = (tempGray + 18'd128) >> 8; 
        next_clear_flag = 1'b1;
    end

    else if (clear) begin 
        nextGray = '0;
        next_clear_flag = 1'b0;
    end
end

endmodule

