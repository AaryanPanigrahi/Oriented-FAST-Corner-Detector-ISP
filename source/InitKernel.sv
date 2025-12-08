`timescale 1ns / 10ps

module InitKernel #(
    parameter [3:0] SIZE = 4'd3
) (
    input logic clk, n_rst,
    input logic start,
    input logic [2:0] sigma,
    output logic [SIZE-1:0][SIZE-1:0][7:0] kernel,
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
logic [3:0] cur_x, cur_y;
logic nextDone;       // Signals when to stop counting
// logic [7:0] nextKernel [SIZE-1:0][SIZE-1:0];
// logic [7:0] bufferKernel [SIZE-1:0][SIZE-1:0];
logic [SIZE-1:0][SIZE-1:0][7:0] nextKernel;
logic [3:0] center;
assign center = (SIZE-1)/2;
logic [31:0] nextSum;
logic contConv;   // Prevents the counter from moving forward until the matrix is ready

always_latch begin : Computation_Latch
    if (start) contConv = 1;
    if (done) contConv = 0;
end

always_ff @(posedge clk, negedge n_rst) begin
    if(~n_rst) begin
        done <= '0;
        kernel <= '0;
        sum <= '0;
    end
    else begin
        done <= nextDone;
        kernel <= nextKernel;
        sum <= nextSum;
    end 
end

// genvar i;
// genvar j;
// generate
//     for(i = 1; i < (SIZE); i++) begin
//         for(j = 1; i < (SIZE); i++) begin
//             assign kernel[i-1][j-1] = {bufferKernel[i-1][j-1], 8'b0};
//         end
//     end
// endgenerate

FlexCounter #(.SIZE(4)) rows_init (
    .clk(clk),
    .n_rst(n_rst),
    .count_enable((contConv || done)),
    .rollover_val(SIZE-4'd1),
    .clear(1'b0),
    .rollover_flag(end_row),
    .count_out(cur_x));

FlexCounter #(.SIZE(4)) columns_init (
    .clk(clk),
    .n_rst(n_rst),
    .count_enable(end_row && (contConv || done)),
    .rollover_val(SIZE-4'd1),
    .clear(1'b0),
    .rollover_flag(end_column),
    .count_out(cur_y));

always_comb begin
    
    // Ditance calc
    calc_x = $sqrt((cur_x - center) ** 2); // The x-axis distance from the center
    calc_y = $sqrt((cur_y - center) ** 2); // The x-axis distance from the center

    // Gaussian formula
    calc_gauss = 100 * e ** (-(calc_x ** 2 + calc_y ** 2)/(2 * sigma ** 2));
    real_bits_gauss = $rtoi(calc_gauss); 
    nextKernel[cur_y][cur_x] = real_bits_gauss[7:0];
    
    // Accumulator
    nextSum = sum;
    if(contConv) begin
        nextSum = sum + real_bits_gauss;
    end
    
    if (end_column && end_row) nextDone = 1'b1;
    else nextDone = 1'b0;
end

endmodule

