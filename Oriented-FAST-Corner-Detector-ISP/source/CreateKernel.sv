`timescale 1ns / 10ps

module CreateKernel #(
    parameter [3:0] SIZE = 4'd3
) (
    input logic clk, n_rst,
    input logic [2:0] sigma,
    input logic start,
    output logic [SIZE-1:0][SIZE-1:0][7:0] kernel,
    output logic done,
    output logic err

);
// logic readyFlag;      // Ready signal for moving through rows/columns
logic end_row, end_column; // Signal for end of row/columns
logic [3:0] cur_x, cur_y;

logic [31:0] numerator, quotient;
logic [31:0] sum; // Holds the value to normalize with
logic start_nn; // Starts the normalization process
logic nextDone;       // Signals when to stop counting

logic [SIZE-1:0][SIZE-1:0][7:0] nnKernel;   // Hold the non-normalized values 
logic [SIZE-1:0][SIZE-1:0][7:0] nextKernel; // Used to clock the build kernel
logic contConv;   // Prevents the counter from moving forward until the matrix is ready

always_latch begin : Computation_Latch
    if (start_nn) contConv = 1;
    if (done) contConv = 0;
end

FlexCounter #(.SIZE(4)) rows_build (
    .clk(clk),
    .n_rst(n_rst),
    .count_enable((contConv || done)),
    .rollover_val(SIZE-4'd1),
    .clear(1'b0),
    .rollover_flag(end_row),
    .count_out(cur_x));

FlexCounter #(.SIZE(4)) columns_build (
    .clk(clk),
    .n_rst(n_rst),
    .count_enable(end_row && (contConv || done)),
    .rollover_val(SIZE-4'd1),
    .clear(1'b0),
    .rollover_flag(end_column),
    .count_out(cur_y));

InitKernel #(.SIZE(SIZE)) non_normalized_kernel (
    .clk(clk),
    .n_rst(n_rst),
    .start(start),
    .sigma(sigma),
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

