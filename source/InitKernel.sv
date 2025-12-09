`timescale 1ns / 10ps

module InitKernel #(
    parameter MAX_KERNAL = 7
) (
    input logic clk, n_rst,
    input logic start,
    input logic [2:0] sigma,
    input logic [$clog2(MAX_KERNAL)-1:0] kernel_size,
    output logic [MAX_KERNAL-1:0][MAX_KERNAL-1:0][7:0] kernel,
    output logic [31:0] sum,
    output logic done
);

real e = 2.718281828;
real calc_gauss; // Holds the calculation
real calc_x, calc_y; //The x/y distance from the center
bit [31:0] real_bits_gauss; 
// gauss - Holds the calculated value from the Gaussian function 
// accu - Holds the accumulator total
logic end_row;              // Clear signal move column
logic end_column;           // Signal for end of kernel operations
logic [$clog2(MAX_KERNAL)-1:0] curr_x, curr_y;
logic nextDone;       // Signals when to stop counting
// logic [7:0] nextKernel [SIZE-1:0][SIZE-1:0];
// logic [7:0] bufferKernel [SIZE-1:0][SIZE-1:0];
logic [MAX_KERNAL-1:0][MAX_KERNAL-1:0][7:0] nextKernel;
logic [3:0] center;
assign center = (kernel_size-1)/2;
logic [31:0] nextSum;
logic contConv;   // Prevents the counter from moving forward until the matrix is ready

always_latch begin : Computation_Latch
    if (start) contConv = 1;
    if (done) contConv = 0;
end

logic [$clog2(MAX_KERNAL)-1:0] idx_x, idx_x2, idx_y, idx_y2;

always_ff @(posedge clk, negedge n_rst) begin
    if(~n_rst) begin
        done <= '0;
        sum <= '0;

        for (idx_y = 0; idx_y < MAX_KERNAL; idx_y++) begin
            for (idx_x = 0; idx_x < MAX_KERNAL; idx_x++) begin
                kernel[idx_x][idx_y][7:0] <= '0;
            end
        end
    end
    else begin
        done <= nextDone;
        sum <= nextSum;

        if (nextDone) kernel <= nextKernel;
    end 
end

pixel_pos #(.X_MAX(MAX_KERNAL), .Y_MAX(MAX_KERNAL), .MODE(1)) kernel_pos (
    .clk(clk), .n_rst(n_rst),
    .new_trans(start),
    .update_pos((contConv || done)),
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
    if(contConv) begin
        nextSum = sum + real_bits_gauss;
    end
    
    if (end_pos) nextDone = 1'b1;
    else nextDone = 1'b0;
end

always_ff @(posedge clk, negedge n_rst) begin
    if (!n_rst) begin
        // Reset Vals
        for (idx_y2 = 0; idx_y2 < MAX_KERNAL; idx_y2++) begin
            for (idx_x2 = 0; idx_x2 < MAX_KERNAL; idx_x2++) begin
                nextKernel[idx_x2][idx_y2][7:0] <= '0;
            end
        end
    end
    else begin
        // Reset Module
        if (start) begin
            for (idx_y2 = 0; idx_y2 < MAX_KERNAL; idx_y2++) begin
                for (idx_x2 = 0; idx_x2 < MAX_KERNAL; idx_x2++) begin
                    nextKernel[idx_x2][idx_y2][7:0] <= '0;
                end
            end
        end

        else nextKernel[curr_y][curr_x][7:0] = real_bits_gauss[7:0];
    end
end

endmodule
