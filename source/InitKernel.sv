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

real e = 2.718281828;
real calc_gauss; // Holds the calculation
real calc_x, calc_y; //The x/y distance from the center
bit [31:0] real_bits_gauss, real_bits_gauss_curr; 
logic [$clog2(MAX_KERNEL)-1:0] curr_x, prev_x, curr_y, prev_y;
logic nextDone, done_future1, done_future2;       // Signals when to stop counting
logic [MAX_KERNEL-1:0][MAX_KERNEL-1:0][7:0] nextKernel;
logic [3:0] center;
assign center = (kernel_size-1)/2;
logic [31:0] nextSum;
logic contConv_latch, contConv;   // Prevents the counter from moving forward until the matrix is ready
logic end_pos;

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
    calc_x = $sqrt((curr_x - center) ** 2); // The x-axis distance from the center
    calc_y = $sqrt((curr_y - center) ** 2); // The x-axis distance from the center

    // Gaussian formula
    calc_gauss = 100 * e ** (-(calc_x ** 2 + calc_y ** 2)/(2 * sigma ** 2));
    real_bits_gauss = $rtoi(calc_gauss); 
    
    // Accumulator
    nextSum = sum;
    if(contConv && !nextDone) begin
        nextSum = sum + real_bits_gauss;
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
        real_bits_gauss_curr <= '0;

        // Reset Vals
        for (idx_y2 = 0; idx_y2 < MAX_KERNEL; idx_y2++) begin
            for (idx_x2 = 0; idx_x2 < MAX_KERNEL; idx_x2++) begin
                nextKernel[idx_x2][idx_y2][7:0] <= '0;
            end
        end
    end

    else begin
        real_bits_gauss_curr <= real_bits_gauss;

        // Reset Module
        if (start) begin
            for (idx_y2 = 0; idx_y2 < MAX_KERNEL; idx_y2++) begin
                for (idx_x2 = 0; idx_x2 < MAX_KERNEL; idx_x2++) begin
                    nextKernel[idx_x2][idx_y2][7:0] <= '0;
                end
            end
        end

        else nextKernel[prev_x][prev_y][7:0] <= real_bits_gauss_curr[7:0];
    end
end

endmodule
