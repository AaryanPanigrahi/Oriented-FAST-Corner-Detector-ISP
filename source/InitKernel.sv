`timescale 1ns / 10ps

module InitKernel #(
    parameter MAX_KERNEL = 7
) (
    input logic clk, n_rst,
    input logic start,
    input logic [2:0] sigma,
    input logic [$clog2(MAX_KERNEL)-1:0] kernel_size,
    output logic [MAX_KERNEL-1:0][MAX_KERNEL-1:0][7:0] kernel,
    output logic [31:0] sum,
    output logic done
);

localparam int FRAC_BITS = 8;

// Lookup Table Logic
localparam int LUT_BITS = 8;
localparam int LUT_SIZE = 1 << LUT_BITS;
logic [7:0] lut_index;
logic [7:0] gauss_lut [0:LUT_SIZE-1];

// Gaussian Logic
logic signed [$clog2(MAX_KERNEL):0] calc_x, calc_y, delta_x, delta_y; // The x/y distance from the center
logic [$clog2(MAX_KERNEL)-1:0] curr_x, prev_x, curr_y, prev_y;
logic signed [7:0] calc_gauss_curr, calc_gauss; 
logic signed [$clog2(MAX_KERNEL):0] center;

// Division Logic (Q0.8)
logic [31:0] r2;
logic [31:0] denom;
logic [31:0] N_div;
logic [31:0] t_div;

logic nextDone, done_future1, done_future2; // Signals when to stop counting
logic [MAX_KERNEL-1:0][MAX_KERNEL-1:0][7:0] nextKernel;
logic [31:0] nextSum;
logic contConv_latch, contConv;  // Prevents the counter from moving forward until the matrix is ready
logic end_pos;

// Lookup table
initial begin
    integer i, tmp;
    real x;
    real val;

    for (i = 0; i < LUT_SIZE; i++) begin
        x   = i * (8.0 / 256.0);
        val = 100.0 * $exp(-x); // Compute Gaussian
        if (val < 0.0) val = 0.0;
        if (val > 255.0) val = 255.0;
        tmp = $rtoi(val);
        gauss_lut[i] = tmp[7:0];
    end
end


always_ff @(posedge clk, negedge n_rst) begin
    if(!n_rst) contConv_latch <= 0;

    else begin
        contConv_latch <= contConv && !end_pos;
    end
end

always_comb begin
    contConv = contConv_latch;
    if (start) contConv = 1;
end

always_ff @(posedge clk, negedge n_rst) begin
    if (!n_rst) begin
        done <= 0;
        done_future2 <= 0;
        done_future1 <= 0;
        sum <= 0;
    end
    else begin
        done_future2 <= nextDone;
        done_future1 <= done_future2;
        done         <= done_future1;
        sum <= nextSum;
    end
end

always_comb begin
    nextDone = 0;
    if (end_pos && contConv) nextDone = 1'b1;
end

logic [$clog2(MAX_KERNEL)-1:0] idx_x, idx_x2, idx_y, idx_y2;
always_ff @(posedge clk, negedge n_rst) begin
    if(~n_rst) begin
        for (idx_y = 0; idx_y < MAX_KERNEL; idx_y++) begin
            for (idx_x = 0; idx_x < MAX_KERNEL; idx_x++) begin
                kernel[idx_x][idx_y][7:0] <= '0;
            end
        end
    end

    else begin
        if (done_future1) kernel <= nextKernel;
    end 
end

pixel_pos #(.X_MAX(MAX_KERNEL), .Y_MAX(MAX_KERNEL), .MODE(1)) kernel_pos (
    .clk(clk), .n_rst(n_rst),
    .new_trans(start),
    .update_pos((contConv)),
    .max_x(kernel_size),          
    .max_y(kernel_size),         
    .curr_x(curr_x),
    .curr_y(curr_y),
    .end_pos(end_pos),
    .next_dir());

always_comb begin
    // Ditance calc
    center  = ($signed({1'b0, kernel_size}) - $signed(4'd1)) >>> 1;
    delta_x = $signed({1'b0, curr_x}) - center;
    delta_y = $signed({1'b0, curr_y}) - center;
    calc_x = (delta_x >= 0) ? delta_x : -delta_x;
    calc_y = (delta_y >= 0) ? delta_y : -delta_y;

    // Gaussian formula
    r2    = calc_x * calc_x + calc_y * calc_y;
    denom = 2 * sigma * sigma;

    N_div = r2 << FRAC_BITS;
    t_div = (N_div + (denom>>1)) / denom;

    if (t_div >= (8 << FRAC_BITS))
        lut_index = 8'hFF;  
    else
        lut_index = t_div[10:3];  
    
    calc_gauss = gauss_lut[lut_index];

    // Accumulator
    nextSum = sum;
    if(contConv && !nextDone) begin
        nextSum = sum + calc_gauss[7:0];
    end
end

always_ff @(posedge clk, negedge n_rst) begin
    if (!n_rst) begin
        prev_x <= '0;
        prev_y <= '0;
    end

    else begin
        prev_x <= curr_x;
        prev_y <= curr_y;
    end
end

always_ff @(posedge clk, negedge n_rst) begin
    if (!n_rst) begin
        calc_gauss_curr <= '0;

        // Reset Vals
        for (idx_y2 = 0; idx_y2 < MAX_KERNEL; idx_y2++) begin
            for (idx_x2 = 0; idx_x2 < MAX_KERNEL; idx_x2++) begin
                nextKernel[idx_x2][idx_y2][7:0] <= '0;
            end
        end
    end

    else begin
        calc_gauss_curr <= calc_gauss;

        // Reset Module
        if (start) begin
            for (idx_y2 = 0; idx_y2 < MAX_KERNEL; idx_y2++) begin
                for (idx_x2 = 0; idx_x2 < MAX_KERNEL; idx_x2++) begin
                    nextKernel[idx_x2][idx_y2][7:0] <= '0;
                end
            end
        end

        else nextKernel[prev_x][prev_y][7:0] <= calc_gauss_curr[7:0];
    end
end

endmodule
