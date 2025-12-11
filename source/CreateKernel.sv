`timescale 1ns / 10ps

module CreateKernel #(
    parameter MAX_KERNEL = 3
) (
    input logic clk, n_rst,
    input logic [2:0] sigma,
    input logic [$clog2(MAX_KERNEL)-1:0] kernel_size,
    input logic start,
    output logic [MAX_KERNEL-1:0][MAX_KERNEL-1:0][7:0] kernel,
    output logic done,
    output logic err
);

// logic readyFlag;      // Ready signal for moving through rows/columns
logic end_row, end_column; // Signal for end of row/columns
logic [$clog2(MAX_KERNEL)-1:0] cur_x, cur_y;

logic [31:0] numerator, quotient;
logic [31:0] sum; // Holds the value to normalize with
logic start_nn; // Starts the normalization process
logic nextDone;       // Signals when to stop counting

logic [MAX_KERNEL-1:0][MAX_KERNEL-1:0][7:0] nnKernel;   // Hold the non-normalized values 
logic [MAX_KERNEL-1:0][MAX_KERNEL-1:0][7:0] nextKernel; // Used to clock the build kernel
logic contConv, contConv_latch;   // Prevents the counter from moving forward until the matrix is ready
logic [$clog2(MAX_KERNEL)-1:0] row_rollover_val, col_rollover_val;

always_comb begin
    row_rollover_val = kernel_size - 1'b1;
    col_rollover_val = kernel_size - 1'b1;
end


always_ff @(posedge clk, negedge n_rst) begin
    if(!n_rst) contConv_latch <= 0;

    else begin
        contConv_latch <= contConv && !done;
    end
end

always_comb begin
    contConv = contConv_latch;
    if (start_nn) contConv = 1;
end

FlexCounter #(.SIZE($clog2(MAX_KERNEL))) rows_build (
    .clk(clk),
    .n_rst(n_rst),
    .count_enable((contConv || done)),
    .rollover_val(row_rollover_val),
    .clear(1'b0),
    .rollover_flag(end_row),
    .count_out(cur_x));

FlexCounter #(.SIZE($clog2(MAX_KERNEL))) columns_build (
    .clk(clk),
    .n_rst(n_rst),
    .count_enable(end_row && (contConv || done)),
    .rollover_val(col_rollover_val),
    .clear(1'b0),
    .rollover_flag(end_column),
    .count_out(cur_y));

InitKernel #(.MAX_KERNEL(MAX_KERNEL)) non_normalized_kernel (
    .clk(clk),
    .n_rst(n_rst),
    .start(start),
    .sigma(sigma),
    .kernel_size(kernel_size),
    .kernel(nnKernel),
    .done(start_nn),
    .sum(sum));

always_ff @(posedge clk, negedge n_rst) begin
    if (~n_rst) begin
        kernel <= '0;
        done <= '0;
    end
    else begin 
        kernel <= nextKernel;
        done <= nextDone;
    end
end

always_comb begin : Normalize_Matrix
    // Default cases
    nextKernel = kernel;
    nextDone = 1'b0;
    err = 1'b0;
    numerator = '0;
    quotient = '0;

    // Normalize matrix
    if (contConv)begin 
        
        numerator = {24'd0, nnKernel[cur_y][cur_x]};  
        numerator = numerator << 8;

        if (sum != 0) begin
            quotient = numerator / sum;
        end
        else begin
            quotient = 32'd0;
            err = 1'b1;
        end
        nextKernel[cur_y][cur_x] = quotient[7:0];
    end

    if (end_column && end_row) nextDone = 1'b1;
end

endmodule
